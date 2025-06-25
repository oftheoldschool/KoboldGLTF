enum ComponentType: Int, Decodable {
    case byte = 5120
    case ubyte = 5121
    case short = 5122
    case ushort = 5123
    case uint = 5125
    case float = 5126
}

enum AccessorType: String, Decodable {
    case scalar = "SCALAR"
    case vec2 = "VEC2"
    case vec3 = "VEC3"
    case vec4 = "VEC4"
    case mat2 = "MAT2"
    case mat3 = "MAT3"
    case mat4 = "MAT4"
}

struct AccessorByte: Decodable {
    let bufferView: Int
    let componentType: ComponentType
    let count: Int
    let max: [Int8]?
    let min: [Int8]?
    let type: AccessorType
}

struct AccessorUByte: Decodable {
    let bufferView: Int
    let componentType: ComponentType
    let count: Int
    let max: [UInt8]?
    let min: [UInt8]?
    let type: AccessorType
}

struct AccessorShort: Decodable {
    let bufferView: Int
    let componentType: ComponentType
    let count: Int
    let max: [Int16]?
    let min: [Int16]?
    let type: AccessorType
}

struct AccessorUShort: Decodable {
    let bufferView: Int
    let componentType: ComponentType
    let count: Int
    let max: [UInt16]?
    let min: [UInt16]?
    let type: AccessorType
}

struct AccessorUInt: Decodable {
    let bufferView: Int
    let componentType: ComponentType
    let count: Int
    let max: [UInt32]?
    let min: [UInt32]?
    let type: AccessorType
}

struct AccessorFloat: Decodable {
    let bufferView: Int
    let componentType: ComponentType
    let count: Int
    let max: [Float]?
    let min: [Float]?
    let type: AccessorType
}

enum Accessor: Decodable {
    case byte(AccessorByte)
    case ubyte(AccessorUByte)
    case short(AccessorShort)
    case ushort(AccessorUShort)
    case uint(AccessorUInt)
    case float(AccessorFloat)

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
        let type = try container.decode(ComponentType.self, forKey: .componentType)
        let singleContainer = try decoder.singleValueContainer()
        switch type {
        case .byte : self = .byte(try singleContainer.decode(AccessorByte.self))
        case .ubyte : self = .ubyte(try singleContainer.decode(AccessorUByte.self))
        case .short : self = .short(try singleContainer.decode(AccessorShort.self))
        case .ushort : self = .ushort(try singleContainer.decode(AccessorUShort.self))
        case .uint : self = .uint(try singleContainer.decode(AccessorUInt.self))
        case .float : self = .float(try singleContainer.decode(AccessorFloat.self))
        }
    }
}
