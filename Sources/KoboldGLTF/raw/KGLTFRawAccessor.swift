enum KRawGLTFComponentType: Int, Decodable {
    case byte = 5120
    case ubyte = 5121
    case short = 5122
    case ushort = 5123
    case uint = 5125
    case float = 5126
}

enum KRawGLTFAccessorType: String, Decodable {
    case scalar = "SCALAR"
    case vec2 = "VEC2"
    case vec3 = "VEC3"
    case vec4 = "VEC4"
    case mat2 = "MAT2"
    case mat3 = "MAT3"
    case mat4 = "MAT4"
}

struct KRawGLTFAccessorByte: Decodable {
    let bufferView: Int
    let componentType: KRawGLTFComponentType
    let count: Int
    let max: [Int8]?
    let min: [Int8]?
    let type: KRawGLTFAccessorType
}

struct KRawGLTFAccessorUByte: Decodable {
    let bufferView: Int
    let componentType: KRawGLTFComponentType
    let count: Int
    let max: [UInt8]?
    let min: [UInt8]?
    let type: KRawGLTFAccessorType
}

struct KRawGLTFAccessorShort: Decodable {
    let bufferView: Int
    let componentType: KRawGLTFComponentType
    let count: Int
    let max: [Int16]?
    let min: [Int16]?
    let type: KRawGLTFAccessorType
}

struct KRawGLTFAccessorUShort: Decodable {
    let bufferView: Int
    let componentType: KRawGLTFComponentType
    let count: Int
    let max: [UInt16]?
    let min: [UInt16]?
    let type: KRawGLTFAccessorType
}

struct KRawGLTFAccessorUInt: Decodable {
    let bufferView: Int
    let componentType: KRawGLTFComponentType
    let count: Int
    let max: [UInt32]?
    let min: [UInt32]?
    let type: KRawGLTFAccessorType
}

struct KRawGLTFAccessorFloat: Decodable {
    let bufferView: Int
    let componentType: KRawGLTFComponentType
    let count: Int
    let max: [Float]?
    let min: [Float]?
    let type: KRawGLTFAccessorType
}

enum KRawGLTFAccessor: Decodable {
    case byte(KRawGLTFAccessorByte)
    case ubyte(KRawGLTFAccessorUByte)
    case short(KRawGLTFAccessorShort)
    case ushort(KRawGLTFAccessorUShort)
    case uint(KRawGLTFAccessorUInt)
    case float(KRawGLTFAccessorFloat)

    enum CodingKeys : String, CodingKey {
        case bufferView
        case componentType
        case count
        case max
        case min
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(KRawGLTFComponentType.self, forKey: .componentType)
        let singleContainer = try decoder.singleValueContainer()
        switch type {
        case .byte : self = .byte(try singleContainer.decode(KRawGLTFAccessorByte.self))
        case .ubyte : self = .ubyte(try singleContainer.decode(KRawGLTFAccessorUByte.self))
        case .short : self = .short(try singleContainer.decode(KRawGLTFAccessorShort.self))
        case .ushort : self = .ushort(try singleContainer.decode(KRawGLTFAccessorUShort.self))
        case .uint : self = .uint(try singleContainer.decode(KRawGLTFAccessorUInt.self))
        case .float : self = .float(try singleContainer.decode(KRawGLTFAccessorFloat.self))
        }
    }
}
