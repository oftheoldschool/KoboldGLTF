public enum KGLTFAccessorType {
    case scalar
    case vec2
    case vec3
    case vec4
    case mat2
    case mat3
    case mat4
}

public protocol KGLTFAccessorCommon {
    associatedtype T: Comparable
    
    var bufferView: KGLTFBufferView { get }
    var type: KGLTFAccessorType { get }
    var count: Int { get }
    var min: [T]? { get }
    var max: [T]? { get }
    static var sizeBytes: Int { get }
}

public extension KGLTFAccessorCommon {
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
        
        print("converting accessor data of type \(type) and expected data size \(Self.sizeBytes) and actual data size \(bufferView.byteLength / count / componentCount) to data \(T.self) with size \(MemoryLayout<T>.size)")
        
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

public struct KGLTFAccessorByte: KGLTFAccessorCommon {
    public let bufferView: KGLTFBufferView
    public let type: KGLTFAccessorType
    public let count: Int
    public let min: [Int8]?
    public let max: [Int8]?
    public static let sizeBytes: Int = 1
}

public struct KGLTFAccessorUByte: KGLTFAccessorCommon {
    public let bufferView: KGLTFBufferView
    public let type: KGLTFAccessorType
    public let count: Int
    public let min: [UInt8]?
    public let max: [UInt8]?
    public static let sizeBytes: Int = 1
}

public struct KGLTFAccessorShort: KGLTFAccessorCommon {
    public let bufferView: KGLTFBufferView
    public let type: KGLTFAccessorType
    public let count: Int
    public let min: [Int16]?
    public let max: [Int16]?
    public static let sizeBytes: Int = 2
}

public struct KGLTFAccessorUShort: KGLTFAccessorCommon {
    public let bufferView: KGLTFBufferView
    public let type: KGLTFAccessorType
    public let count: Int
    public let min: [UInt16]?
    public let max: [UInt16]?
    public static let sizeBytes: Int = 2
}

public struct KGLTFAccessorUInt: KGLTFAccessorCommon {
    public let bufferView: KGLTFBufferView
    public let type: KGLTFAccessorType
    public let count: Int
    public let min: [UInt32]?
    public let max: [UInt32]?
    public static let sizeBytes: Int = 4
}

public struct KGLTFAccessorFloat: KGLTFAccessorCommon {
    public let bufferView: KGLTFBufferView
    public let type: KGLTFAccessorType
    public let count: Int
    public let min: [Float]?
    public let max: [Float]?
    public static let sizeBytes: Int = 4
}

public enum KGLTFAccessor {
    case byte(KGLTFAccessorByte)
    case ubyte(KGLTFAccessorUByte)
    case short(KGLTFAccessorShort)
    case ushort(KGLTFAccessorUShort)
    case uint(KGLTFAccessorUInt)
    case float(KGLTFAccessorFloat)
}
