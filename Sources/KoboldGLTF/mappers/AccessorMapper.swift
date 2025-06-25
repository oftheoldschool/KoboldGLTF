func mapAccessors(
    _ raw: [Accessor],
    bufferViews: [KGBufferView]
) -> [KGAccessor] {
    return raw.compactMap { rawAccessor in
        return mapAccessor(rawAccessor, bufferViews: bufferViews)
    }
}

func mapComponentType(_ raw: ComponentType) -> KGComponentType {
    switch raw {
    case .byte: return .byte
    case .ubyte: return .ubyte
    case .short: return .short
    case .ushort: return .ushort
    case .uint: return .uint
    case .float: return .float
    }
}

func mapAccessorType(_ raw: AccessorType) -> KGAccessorType {
    switch raw {
    case .scalar: return .scalar
    case .vec2: return .vec2
    case .vec3: return .vec3
    case .vec4: return .vec4
    case .mat2: return .mat2
    case .mat3: return .mat3
    case .mat4: return .mat4
    }
}

func mapAccessor(
    _ raw: Accessor,
    bufferViews: [KGBufferView]
) -> KGAccessor {
    switch raw {
    case .byte(let rawAccessor):
        return .byte(
            KGAccessorByte(
                bufferView: bufferViews[rawAccessor.bufferView], 
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .ubyte(let rawAccessor):
        return .ubyte(
            KGAccessorUByte(
                bufferView: bufferViews[rawAccessor.bufferView],
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .short(let rawAccessor):
        return .short(
            KGAccessorShort(
                bufferView: bufferViews[rawAccessor.bufferView], 
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .ushort(let rawAccessor):
        return .ushort(
            KGAccessorUShort(
                bufferView: bufferViews[rawAccessor.bufferView],
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .uint(let rawAccessor):
        return .uint(
            KGAccessorUInt(
                bufferView: bufferViews[rawAccessor.bufferView],
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    case .float(let rawAccessor):
        return .float(
            KGAccessorFloat(
                bufferView: bufferViews[rawAccessor.bufferView], 
                type: mapAccessorType(rawAccessor.type), 
                count: rawAccessor.count, 
                min: rawAccessor.min, 
                max: rawAccessor.max))
    }
}
