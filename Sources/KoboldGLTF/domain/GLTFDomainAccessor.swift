public enum KGAccessorType {
    case scalar
    case vec2
    case vec3
    case vec4
    case mat2
    case mat3
    case mat4
}

public protocol KGAccessorCommon {
    associatedtype T: Comparable
    
    var bufferView: KGBufferView { get }
    var type: KGAccessorType { get }
    var count: Int { get }
    var min: [T]? { get }
    var max: [T]? { get }
    static var sizeBytes: Int { get }
}

public extension KGAccessorCommon {
    func toArray() -> [[T]] {
        let data = bufferView.buffer.data
        let dataStart = bufferView.byteOffset
        let dataEnd = dataStart + bufferView.byteLength
        let accessorData = data.subdata(in: dataStart..<dataEnd)
        
        var componentCount = 0
        switch type {
        case .scalar: componentCount = 1
        case .vec2: componentCount = 2
        case .vec3: componentCount = 3
        case .vec4: componentCount = 4
        case .mat2: componentCount = 4
        case .mat3: componentCount = 9
        case .mat4: componentCount = 16
        }
        
        return accessorData.withUnsafeBytes { (castArray: UnsafeRawBufferPointer) in
            stride(from: 0, to: count * componentCount, by: componentCount).map { groupOffset in
                (0..<componentCount).map { componentOffset in
                    let byteOffset = (groupOffset + componentOffset) * MemoryLayout<T>.size
                    return castArray.load(
                        fromByteOffset: byteOffset,
                        as: T.self)
                }
            }
        }
    }
}

public struct KGAccessorByte: KGAccessorCommon {
    public let bufferView: KGBufferView
    public let type: KGAccessorType
    public let count: Int
    public let min: [Int8]?
    public let max: [Int8]?
    public static let sizeBytes: Int = 1
}

public struct KGAccessorUByte: KGAccessorCommon {
    public let bufferView: KGBufferView
    public let type: KGAccessorType
    public let count: Int
    public let min: [UInt8]?
    public let max: [UInt8]?
    public static let sizeBytes: Int = 1
}

public struct KGAccessorShort: KGAccessorCommon {
    public let bufferView: KGBufferView
    public let type: KGAccessorType
    public let count: Int
    public let min: [Int16]?
    public let max: [Int16]?
    public static let sizeBytes: Int = 2
}

public struct KGAccessorUShort: KGAccessorCommon {
    public let bufferView: KGBufferView
    public let type: KGAccessorType
    public let count: Int
    public let min: [UInt16]?
    public let max: [UInt16]?
    public static let sizeBytes: Int = 2
}

public struct KGAccessorUInt: KGAccessorCommon {
    public let bufferView: KGBufferView
    public let type: KGAccessorType
    public let count: Int
    public let min: [UInt32]?
    public let max: [UInt32]?
    public static let sizeBytes: Int = 4
}

public struct KGAccessorFloat: KGAccessorCommon {
    public let bufferView: KGBufferView
    public let type: KGAccessorType
    public let count: Int
    public let min: [Float]?
    public let max: [Float]?
    public static let sizeBytes: Int = 4
}

public enum KGAccessor {
    case byte(KGAccessorByte)
    case ubyte(KGAccessorUByte)
    case short(KGAccessorShort)
    case ushort(KGAccessorUShort)
    case uint(KGAccessorUInt)
    case float(KGAccessorFloat)
}
