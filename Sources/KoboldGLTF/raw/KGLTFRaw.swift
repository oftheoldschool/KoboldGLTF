struct KRawGLTFAsset: Decodable {
    let version: String
    let minVersion: String?
    let generator: String?
    let copyright: String?
}

struct KRawGLTFScene: Decodable {
    let name: String
    let nodes: [Int]
}

struct KRawGLTFNode: Decodable {
    let name: String
    let mesh: Int?
    let skin: Int?
    let children: [Int]?
    let rotation: [Float]?
    let translation: [Float]?
    let scale: [Float]?
}

enum KRawGLTFAnimationChannelTargetPath: String, Decodable {
    case translation = "translation"
    case rotation = "rotation"
    case scale = "scale"
}

struct KRawGLTFAnimationChannelTarget: Decodable {
    let node: Int
    let path: KRawGLTFAnimationChannelTargetPath
}

struct KRawGLTFAnimationChannel: Decodable {
    let sampler: Int
    let target: KRawGLTFAnimationChannelTarget
}

enum KRawGLTFAnimationSamplerInterpolation: String, Decodable {
    case linear = "LINEAR"
    case step = "STEP"
    case cubicSpline = "CUBICSPLINE"
}

struct KRawGLTFAnimationSampler: Decodable {
    let interpolation: KRawGLTFAnimationSamplerInterpolation
    let input: Int
    let output: Int
}

struct KRawGLTFAnimation: Decodable {
    let name: String
    let channels: [KRawGLTFAnimationChannel]
    let samplers: [KRawGLTFAnimationSampler]
}

struct KRawGLTFTextureInfo: Decodable {
    let index: Int
}

struct KRawGLTFMaterial: Decodable {
    struct KRawGLTFPBRMetallicRoughness: Decodable {
        let metallicFactor: Float
        let roughnessFactor: Float
        let baseColorTexture: KRawGLTFTextureInfo
    }

    let name: String
    let doubleSided: Bool?
    let pbrMetallicRoughness: KRawGLTFPBRMetallicRoughness?
}

struct KRawGLTFMeshPrimitive: Decodable {
    let indices: Int
    let material: Int
    let attributes: [String: Int]
}

struct KRawGLTFMesh: Decodable {
    let name: String
    let primitives: [KRawGLTFMeshPrimitive]
}

struct KRawGLTFTexture: Decodable {
    let sampler: Int
    let source: Int
}

struct KRawGLTFImage: Decodable {
    let name: String
    let bufferView: Int
    let mimeType: String
}

struct KRawGLTFSkin: Decodable {
    let name: String
    let inverseBindMatrices: Int
    let joints: [Int]
}

struct KRawGLTFBufferView: Decodable {
    let buffer: Int
    let byteLength: Int
    let byteOffset: Int
}

struct KRawGLTFSampler: Decodable {
    enum KRawGLTFSamplerMagFilter: Int, Decodable {
        case nearest = 9728
        case linear = 9729
    }

    enum KRawGLTFSamplerMinFilter: Int, Decodable {
        case nearest = 9728
        case linear = 9729
        case nearestMipMapNearest = 9984
        case linearMipMapNearest = 9985
        case nearestMipMapLinear = 9986
        case linearMipMapLinear = 9987
    }

    enum KRawGLTFSamplerWrap: Int, Decodable {
        case clampToEdge = 33071
        case mirroredRepeat = 33648
        case standardRepeat = 10497
    }

    let minFilter: KRawGLTFSamplerMinFilter?
    let magFilter: KRawGLTFSamplerMagFilter?
    let wrapS: KRawGLTFSamplerWrap?
    let wrapT: KRawGLTFSamplerWrap?
}

struct KRawGLTFBuffer: Decodable {
    let byteLength: Int
    let uri: String?
}

struct KRawGLTFFile: Decodable {
    let asset: KRawGLTFAsset
    let scene: Int
    let scenes: [KRawGLTFScene]
    let nodes: [KRawGLTFNode]
    let animations: [KRawGLTFAnimation]?
    let materials: [KRawGLTFMaterial]
    let meshes: [KRawGLTFMesh]
    let textures: [KRawGLTFTexture]
    let images: [KRawGLTFImage]
    let skins: [KRawGLTFSkin]?
    let accessors: [KRawGLTFAccessor]
    let bufferViews: [KRawGLTFBufferView]
    let samplers: [KRawGLTFSampler]
    let buffers: [KRawGLTFBuffer]
}
