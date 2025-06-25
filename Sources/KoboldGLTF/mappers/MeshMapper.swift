func mapMeshes(
    _ raw: [Mesh],
    accessors: [KGAccessor],
    materials: [KGMaterial]
) throws -> [KGMesh] {
    return try raw.map { 
        try mapMesh(
            $0,
            accessors: accessors,
            materials: materials) 
    }
}

func mapMesh(
    _ raw: Mesh,
    accessors: [KGAccessor],
    materials: [KGMaterial]
) throws -> KGMesh {
    return KGMesh(
        name: raw.name, 
        primitives: try mapPrimitives(
            raw.primitives, 
            accessors: accessors, 
            materials: materials))
}

func mapPrimitives(
    _ raw: [MeshPrimitive],
    accessors: [KGAccessor],
    materials: [KGMaterial]
) throws -> [KGMesh.KGMeshPrimitive] {
    return try raw.map { 
        KGMesh.KGMeshPrimitive(
            indices: accessors[$0.indices], 
            material: materials[$0.material], 
            attributes: try mapPrimitiveAttributes(
                $0.attributes, 
                accessors: accessors))
    }
}

func mapPrimitiveAttributes(
    _ raw: [String: Int],
    accessors: [KGAccessor]
) throws -> [KGAttributeType: KGAccessor] {
    return Dictionary(
        uniqueKeysWithValues: 
            try raw.map { (k, v) in 
                (try mapAttributeType(k), accessors[v])
            })
} 

func mapAttributeType(_ raw: String) throws -> KGAttributeType {
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
    throw KGError.attributeTypeUnknown(raw)
}
