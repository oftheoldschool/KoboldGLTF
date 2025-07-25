    func mapAccessors(
    _ raw: [Accessor],
    bufferViews: [KGLTFBufferView]
    ) -> [KGLTFAccessor] {
    return raw.compactMap { rawAccessor in
        return mapAccessor(rawAccessor, bufferViews: bufferViews)
    }
}

func mapComponentType(_ raw: ComponentType) -> KGLTFComponentType {
    return switch raw {
    case .byte: .byte
    case .ubyte: .ubyte
    case .short: .short
    case .ushort: .ushort
    case .uint: .uint
    case .float: .float
    }
}

func mapAccessorType(_ raw: AccessorType) -> KGLTFAccessorType {
    return switch raw {
    case .scalar: .scalar
    case .vec2: .vec2
    case .vec3: .vec3
    case .vec4: .vec4
    case .mat2: .mat2
    case .mat3: .mat3
    case .mat4: .mat4
    }
}

func mapAccessor(
    _ raw: Accessor,
    bufferViews: [KGLTFBufferView]
) -> KGLTFAccessor {
    switch raw {
    case .byte(let rawAccessor):
        return .byte(
            KGLTFAccessorByte(
                bufferView: bufferViews[rawAccessor.bufferView], 
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .ubyte(let rawAccessor):
        return .ubyte(
            KGLTFAccessorUByte(
                bufferView: bufferViews[rawAccessor.bufferView],
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .short(let rawAccessor):
        return .short(
            KGLTFAccessorShort(
                bufferView: bufferViews[rawAccessor.bufferView], 
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .ushort(let rawAccessor):
        return .ushort(
            KGLTFAccessorUShort(
                bufferView: bufferViews[rawAccessor.bufferView],
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .uint(let rawAccessor):
        return .uint(
            KGLTFAccessorUInt(
                bufferView: bufferViews[rawAccessor.bufferView],
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .float(let rawAccessor):
        return .float(
            KGLTFAccessorFloat(
                bufferView: bufferViews[rawAccessor.bufferView], 
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    }
}
