func mapMeshes(
    _ raw: [Mesh],
    accessors: [KGLTFAccessor],
    materials: [KGLTFMaterial]
) throws -> [KGLTFMesh] {
    return try raw.map { 
        try mapMesh(
            $0,
            accessors: accessors,
            materials: materials) 
    }
}

func mapMesh(
    _ raw: Mesh,
    accessors: [KGLTFAccessor],
    materials: [KGLTFMaterial]
) throws -> KGLTFMesh {
    return KGLTFMesh(
        name: raw.name, 
        primitives: try mapPrimitives(
            raw.primitives, 
            accessors: accessors, 
            materials: materials))
}

func mapPrimitives(
    _ raw: [MeshPrimitive],
    accessors: [KGLTFAccessor],
    materials: [KGLTFMaterial]
) throws -> [KGLTFMesh.KGLTFMeshPrimitive] {
    return try raw.map { 
        KGLTFMesh.KGLTFMeshPrimitive(
            mode: mapPrimitiveMode($0.mode ?? .triangles),
            indices: accessors[$0.indices],
            material: $0.material.map { materialId in materials[materialId] }, 
            attributes: try mapPrimitiveAttributes(
                $0.attributes, 
                accessors: accessors))
    }
}

func mapPrimitiveMode(_ raw: MeshPrimitiveMode) -> KGLTFMeshPrimitiveMode {
    return switch raw {
    case .points: .points
    case .lines: .lines
    case .lineLoop: .lineLoop
    case .lineStrip: .lineStrip
    case .triangles: .triangles
    case .triangleStrip: .triangleStrip
    case .triangleFan: .triangleFan
    }
}

func mapPrimitiveAttributes(
    _ raw: [String: Int],
    accessors: [KGLTFAccessor]
) throws -> [KGLTFAttributeType: KGLTFAccessor] {
    return Dictionary(
        uniqueKeysWithValues: 
            try raw.map { (k, v) in 
                (try mapAttributeType(k), accessors[v])
            })
} 

func mapAttributeType(_ raw: String) throws -> KGLTFAttributeType {
    switch raw {
    case "POSITION": return .position
    case "NORMAL": return .normal
    case "TANGENT": return .tangent
    default:
        let attributePattern: Regex<(Substring, attributeType: Substring, attributeIndex: Substring)> = try! Regex(#"^(?<attributeType>WEIGHTS|JOINTS|COLOR|TEXCOORD)_(?<attributeIndex>\d+)$"#)
        if let result = try? attributePattern.wholeMatch(in: raw) {
            let attributeType = result.output.attributeType
            let attributeIndex = Int(result.output.attributeIndex)!
            switch attributeType {
            case "WEIGHTS": return .weights(n: attributeIndex)
            case "JOINTS": return .joints(n: attributeIndex)
            case "COLOR": return .color(n: attributeIndex)
            case "TEXCOORD": return .texCoord(n: attributeIndex)
            default: break
            }
        }
    }
    throw KGLTFError.attributeTypeUnknown(raw)
}
