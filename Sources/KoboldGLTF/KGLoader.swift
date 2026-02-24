import Foundation

public class KGLTFLoader {
    public init() {

    }

    public func loadGLTF(url: URL) throws -> KGLTFFile {
        if url.pathExtension == "gltf" {
            return try loadJSON(url: url)
        } else if url.pathExtension == "glb" {
            return try loadBinary(url: url)
        } else {
            throw KGLTFError.filenameNotSupported(url.absoluteString)
        }
    }

    public func loadGLTF(resource: String) throws -> KGLTFFile {
        if resource.hasSuffix("gltf") {
            return try loadJSON(resource: resource)
        } else if resource.hasSuffix("glb") {
            return try loadBinary(resource: resource)
        } else {
            throw KGLTFError.filenameNotSupported(resource)
        }
    }

    private func loadJSON(url: URL) throws -> KGLTFFile {
        let gltfJson = try String(contentsOf: url, encoding: String.Encoding.utf8)
        return try loadJSON(gltfJson: gltfJson)
    }

    private func loadJSON(resource: String) throws -> KGLTFFile {
        let gltfPath = Bundle.main.path(forResource: resource, ofType: nil)!
        let gltfJson = try String(contentsOfFile: gltfPath, encoding: String.Encoding.utf8)
        return try loadJSON(gltfJson: gltfJson)
    }

    private func loadJSON(gltfJson: String) throws -> KGLTFFile {
        let gltfRaw = try JSONDecoder().decode(GLTFFile.self, from: gltfJson.data(using: .utf8)!)
        return try mapGLTF(gltfRaw)
    }

    private func loadBinary(url: URL) throws -> KGLTFFile {
        let gltfData: Data
        do {
            gltfData = try Data(contentsOf: url)
        } catch {
            throw KGLTFError.fileNotReadable("Unable to read file due to \(error.localizedDescription)")
        }

        return try loadBinary(gltfData: gltfData)
    }

    private func loadBinary(resource: String) throws -> KGLTFFile {
        guard let gltfPath = Bundle.main.url(
            forResource: resource,
            withExtension: nil
        ) else {
            throw KGLTFError.fileNotFound(resource)
        }
        let gltfData: Data
        do {
            gltfData = try Data(contentsOf: gltfPath)
        } catch {
            throw KGLTFError.fileNotReadable("Unable to read file due to \(error.localizedDescription)")
        }

        return try loadBinary(gltfData: gltfData)
    }

    private func loadBinary(gltfData: Data) throws -> KGLTFFile {
        var magic: UInt32 = 0
        var version: UInt32 = 0
        var length: UInt32 = 0

        gltfData[0..<12].withUnsafeBytes { bytes in
            magic = bytes.load(fromByteOffset: 0, as: UInt32.self)
            version = bytes.load(fromByteOffset: 4, as: UInt32.self)
            length = bytes.load(fromByteOffset: 8, as: UInt32.self)
        }

        let expectedMagic: UInt32 = 0x46546C67

        if expectedMagic != magic {
            throw KGLTFError.fileHeaderInvalid("Version: \(version), Length: \(length), Expected magic: \(String(expectedMagic, radix: 16)), Actual magic: \(String(magic, radix: 16))")
        }

        var currentOffset: UInt32 = 12
        var gltfRaw: GLTFFile!
        var binData: [UInt8]?

        while currentOffset < length {
            var chunkSize: UInt32 = 0
            var chunkType: BinaryChunkType!

            gltfData[currentOffset..<(currentOffset + 8)].withUnsafeBytes { bytes in
                chunkSize = bytes[0..<4].load(as: UInt32.self)
                chunkType = BinaryChunkType(rawValue: bytes[4..<8].load(as: UInt32.self))!
            }

            if chunkType == .json {
                let jsonString = gltfData[(currentOffset + 8)..<(currentOffset + 8 + chunkSize)].withUnsafeBytes { bytes in
                    String(bytes: bytes, encoding: .utf8)
                }
                gltfRaw = try! JSONDecoder().decode(GLTFFile.self, from: jsonString!.data(using: .utf8)!)
            } else if chunkType == .bin {
                var outData = [UInt8]()
                outData += gltfData[(currentOffset + 8)..<(currentOffset + 8 + chunkSize)]
                binData = outData
            }

            currentOffset += 8 + chunkSize
        }

        return try mapGLTF(gltfRaw, binData: binData)
    }

    private func mapGLTF(_ raw: GLTFFile, binData: [UInt8]? = nil) throws -> KGLTFFile {
        let buffers = try mapBuffers(raw.buffers, binData: binData)
        let bufferViews = mapBufferViews(raw.bufferViews, buffers: buffers)
        let accessors = mapAccessors(raw.accessors, bufferViews: bufferViews)
        let samplers = mapSamplers(raw.samplers)
        let images = mapImages(raw.images, bufferViews: bufferViews)
        let textures = mapTextures(raw.textures, samplers: samplers, images: images)
        let materials = mapMaterials(raw.materials, textures: textures)
        let meshes = try mapMeshes(raw.meshes, accessors: accessors, materials: materials)
        let nodes = try mapNodes(raw.nodes, meshes: meshes)
        let scenes = mapScenes(raw.scenes, nodes: nodes)
        var skins: [KGLTFSkin] = []
        if let rawSkins = raw.skins {
            skins = mapSkins(rawSkins, accessors: accessors, nodes: nodes)
        }
        var animations: [KGLTFAnimation] = []
        if let rawAnimations = raw.animations {
            animations = mapAnimations(rawAnimations, accessors: accessors, nodes: nodes)
        }

        updateNodesWithSkin(nodes: nodes, rawNodes: raw.nodes, skins: skins)

        return KGLTFFile(
            asset: mapAsset(raw.asset),
            buffers: buffers,
            bufferViews: bufferViews,
            accessors: accessors,
            nodes: nodes,
            scenes: scenes,
            scene: scenes[raw.scene],
            samplers: samplers,
            images: images,
            textures: textures,
            materials: materials,
            skins: skins,
            meshes: meshes,
            animations: animations
        )
    }
}
