import Foundation
import simd

public struct KGLTFAsset {
    public let version: String
    public let minVersion: String?
    public let generator: String?
    public let copyright: String?
}

public class KGLTFBuffer {
    public let data: Data
    
    init(data: Data) {
        self.data = data
    }
}

public class KGLTFBufferView {
    public let buffer: KGLTFBuffer
    public let byteLength: Int
    public let byteOffset: Int
    
    init(
        buffer: KGLTFBuffer,
        byteLength: Int,
        byteOffset: Int
    ) {
        self.buffer = buffer
        self.byteLength = byteLength
        self.byteOffset = byteOffset
    }
}

public enum KGLTFComponentType {
    case byte
    case ubyte
    case short
    case ushort
    case uint
    case float
}

public class KGLTFNode {
    public let id: Int
    public let name: String
    public let mesh: KGLTFMesh?
    public var skin: KGLTFSkin?
    public var parent: KGLTFNode?
    public var children: [KGLTFNode]?
    public let rotation: simd_quatf?
    public let translation: SIMD3<Float>?
    public let scale: SIMD3<Float>?
    
    init(
        id: Int,
        name: String,
        mesh: KGLTFMesh?,
        skin: KGLTFSkin?,
        parent: KGLTFNode?,
        children: [KGLTFNode]?,
        rotation: simd_quatf?,
        translation: SIMD3<Float>?,
        scale: SIMD3<Float>?
    ) {
        self.id = id
        self.name = name
        self.mesh = mesh
        self.skin = skin
        self.parent = parent
        self.children = children
        self.rotation = rotation
        self.translation = translation
        self.scale = scale
    }
}

public class KGLTFScene {
    public let name: String
    public let nodes: [KGLTFNode]
    
    init(name: String, nodes: [KGLTFNode]) {
        self.name = name
        self.nodes = nodes
    }
}

public class KGLTFSampler {
    public enum KGLTFSamplerMagFilter: Decodable {
        case nearest
        case linear
    }
    
    public enum KGLTFSamplerMinFilter: Decodable {
        case nearest
        case linear
        case nearestMipMapNearest
        case linearMipMapNearest
        case nearestMipMapLinear
        case linearMipMapLinear
    }
    
    public enum KGLTFSamplerWrap: Decodable {
        case clampToEdge
        case mirroredRepeat
        case standardRepeat
    }

    public let minFilter: KGLTFSamplerMinFilter?
    public let magFilter: KGLTFSamplerMagFilter?
    public let wrapS: KGLTFSamplerWrap?
    public let wrapT: KGLTFSamplerWrap?
    
    init(
        minFilter: KGLTFSamplerMinFilter?,
        magFilter: KGLTFSamplerMagFilter?,
        wrapS: KGLTFSamplerWrap?,
        wrapT: KGLTFSamplerWrap?
    ) {
        self.minFilter = minFilter
        self.magFilter = magFilter
        self.wrapS = wrapS
        self.wrapT = wrapT
    }
}

public class KGLTFImage {
    public let name: String
    public let bufferView: KGLTFBufferView
    public let mimeType: String
    
    init(
        name: String,
        bufferView: KGLTFBufferView,
        mimeType: String
    ) {
        self.name = name
        self.bufferView = bufferView
        self.mimeType = mimeType
    }
}

public struct KGLTFTextureInfo {
    public let texture: KGLTFTexture
}

public class KGLTFMaterial {
    public struct KGPBRMetallicRoughness {
        public let metallicFactor: Float?
        public let roughnessFactor: Float?
        public let baseColorTexture: KGLTFTextureInfo?
    }
    
    public let name: String
    public let doubleSided: Bool
    public let pbrMetallicRoughness: KGPBRMetallicRoughness?
    
    init(
        name: String,
        doubleSided: Bool,
        pbrMetallicRoughness: KGPBRMetallicRoughness?
    ) {
        self.name = name
        self.doubleSided = doubleSided
        self.pbrMetallicRoughness = pbrMetallicRoughness
    }
}

public struct KGLTFTexture {
    public let sampler: KGLTFSampler
    public let source: KGLTFImage
}

public struct KGLTFSkin {
    public let name: String
    public let inverseBindMatrices: KGLTFAccessor
    public let joints: [KGLTFNode]
}

public enum KGLTFAnimationChannelTargetPath {
    case translation
    case rotation
    case scale
}

public struct KGLTFAnimationChannelTarget {
    public let node: KGLTFNode
    public let path: KGLTFAnimationChannelTargetPath
}

public struct KGLTFAnimationChannel {
    public let sampler: KGLTFAnimationSampler
    public let target: KGLTFAnimationChannelTarget
}

public enum KGLTFAnimationSamplerInterpolation {
    case linear
    case step
    case cubicSpline
}

public class KGLTFAnimationSampler {
    public let interpolation: KGLTFAnimationSamplerInterpolation
    public let input: KGLTFAccessor
    public let output: KGLTFAccessor
    
    init(
        interpolation: KGLTFAnimationSamplerInterpolation,
        input: KGLTFAccessor,
        output: KGLTFAccessor
    ) {
        self.interpolation = interpolation
        self.input = input
        self.output = output
    }
}

public struct KGLTFAnimation {
    public let name: String
    public let channels: [KGLTFAnimationChannel]
    public let samplers: [KGLTFAnimationSampler]
}

public enum KGLTFAttributeType {
    case position
    case normal
    case tangent
    case texCoord(n: Int)
    case color(n: Int)
    case joints(n: Int)
    case weights(n: Int)
    
    public var rawValue : Int {
        get {
            return switch self {
            case .position: 0
            case .normal: 1
            case .tangent: 2
            case .texCoord(n: _): 3
            case .color(n: _): 4
            case .joints(n: _): 5
            case .weights(n: _): 6
            }
        }
    }
}

public enum KGLTFMeshPrimitiveMode: Int {
    case points
    case lines
    case lineLoop
    case lineStrip
    case triangles
    case triangleStrip
    case triangleFan
}

public struct KGLTFMesh {
    public struct KGLTFMeshPrimitive {
        public let mode: KGLTFMeshPrimitiveMode
        public let indices: KGLTFAccessor
        public let material: KGLTFMaterial?
        public let attributes: [KGLTFAttributeType: KGLTFAccessor]
    }
    
    public let name: String
    public let primitives: [KGLTFMeshPrimitive]
}

extension KGLTFAttributeType: Hashable, Equatable, Comparable {
    public static func == (
        lhs: KGLTFAttributeType, 
        rhs: KGLTFAttributeType
    ) -> Bool {
        switch (lhs, rhs) {
        case (.position, .position), (.normal, .normal), (.tangent, .tangent):
            return true
        case (.texCoord(let li), .texCoord(let ri)),
            (.color(let li), .color(let ri)),
            (.joints(let li), .joints(let ri)),
            (.weights(let li), .weights(let ri)):
            return li == ri
        default:
            return false
        }
    }
   
    public static func < (lhs: KGLTFAttributeType, rhs: KGLTFAttributeType) -> Bool {
        switch (lhs, rhs) {
        case (.texCoord(let ia), .texCoord(let ib)),
            (.weights(let ia), .weights(let ib)),
            (.joints(let ia), .joints(let ib)),
            (.color(let ia), .color(let ib)):
            return ia < ib
        default:
            return lhs.rawValue < rhs.rawValue
        }
    }
}

public struct KGLTFFile {
    public let asset: KGLTFAsset
    public let buffers: [KGLTFBuffer]
    public let bufferViews: [KGLTFBufferView]
    public let accessors: [KGLTFAccessor]
    public let nodes: [KGLTFNode]
    public let scenes: [KGLTFScene]
    public let scene: KGLTFScene
    public let samplers: [KGLTFSampler]
    public let images: [KGLTFImage]
    public let textures: [KGLTFTexture]
    public let materials: [KGLTFMaterial]
    public let skins: [KGLTFSkin]
    public let meshes: [KGLTFMesh]
    public let animations: [KGLTFAnimation]
}
