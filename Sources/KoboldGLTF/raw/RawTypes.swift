enum BinaryChunkType: UInt32 {
    case json = 0x4E4F534A
    case bin = 0x004E4942
}

struct Asset: Decodable {
    let version: String
    let minVersion: String?
    let generator: String?
    let copyright: String?
}

struct Scene: Decodable {
    let name: String
    let nodes: [Int]
}

struct Node: Decodable {
    let name: String
    let mesh: Int?
    let skin: Int?
    let children: [Int]?
    let rotation: [Float]?
    let translation: [Float]?
    let scale: [Float]?
}

enum AnimationChannelTargetPath: String, Decodable {
    case translation = "translation"
    case rotation = "rotation"
    case scale = "scale"
}

struct AnimationChannelTarget: Decodable {
    let node: Int
    let path: AnimationChannelTargetPath
}

struct AnimationChannel: Decodable {
    let sampler: Int
    let target: AnimationChannelTarget
}

enum AnimationSamplerInterpolation: String, Decodable {
    case linear = "LINEAR"
    case step = "STEP"
    case cubicSpline = "CUBICSPLINE"
}

struct AnimationSampler: Decodable {
    let interpolation: AnimationSamplerInterpolation
    let input: Int
    let output: Int
}

struct Animation: Decodable {
    let name: String
    let channels: [AnimationChannel]
    let samplers: [AnimationSampler]
}

struct TextureInfo: Decodable {
    let index: Int
}

struct Material: Decodable {
    struct PBRMetallicRoughness: Decodable {
        let metallicFactor: Float
        let roughnessFactor: Float?
        let baseColorTexture: TextureInfo?
    }

    let name: String
    let doubleSided: Bool?
    let pbrMetallicRoughness: PBRMetallicRoughness?
}

enum MeshPrimitiveMode: Int, Decodable {
    case points = 0
    case lines = 1
    case lineLoop = 2
    case lineStrip = 3
    case triangles = 4
    case triangleStrip = 5
    case triangleFan = 6
}

struct MeshPrimitive: Decodable {
    let mode: MeshPrimitiveMode?
    let indices: Int
    let material: Int?
    let attributes: [String: Int]
}

struct Mesh: Decodable {
    let name: String
    let primitives: [MeshPrimitive]
}

struct Texture: Decodable {
    let sampler: Int
    let source: Int
}

struct Image: Decodable {
    let name: String
    let bufferView: Int
    let mimeType: String
}

struct Skin: Decodable {
    let name: String
    let inverseBindMatrices: Int
    let joints: [Int]
}

struct BufferView: Decodable {
    let buffer: Int
    let byteLength: Int
    let byteOffset: Int
}

struct Sampler: Decodable {
    enum SamplerMagFilter: Int, Decodable {
        case nearest = 9728
        case linear = 9729
    }

    enum SamplerMinFilter: Int, Decodable {
        case nearest = 9728
        case linear = 9729
        case nearestMipMapNearest = 9984
        case linearMipMapNearest = 9985
        case nearestMipMapLinear = 9986
        case linearMipMapLinear = 9987
    }

    enum SamplerWrap: Int, Decodable {
        case clampToEdge = 33071
        case mirroredRepeat = 33648
        case standardRepeat = 10497
    }

    let minFilter: SamplerMinFilter?
    let magFilter: SamplerMagFilter?
    let wrapS: SamplerWrap?
    let wrapT: SamplerWrap?
}

struct Buffer: Decodable {
    let byteLength: Int
    let uri: String?
}

struct GLTFFile: Decodable {
    let asset: Asset
    let scene: Int
    let scenes: [Scene]
    let nodes: [Node]
    let animations: [Animation]?
    let materials: [Material]?
    let meshes: [Mesh]
    let textures: [Texture]?
    let images: [Image]?
    let skins: [Skin]?
    let accessors: [Accessor]
    let bufferViews: [BufferView]
    let samplers: [Sampler]?
    let buffers: [Buffer]
}
