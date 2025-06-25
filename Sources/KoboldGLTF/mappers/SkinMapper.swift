func mapSkins(
    _ raw: [Skin],
    accessors: [KGAccessor],
    nodes: [KGNode]
) -> [KGSkin] {
    return raw.map { mapSkin($0, accessors: accessors, nodes: nodes) }
}

func mapSkin(
    _ raw: Skin,
    accessors: [KGAccessor],
    nodes: [KGNode]
) -> KGSkin {
    return KGSkin(
        name: raw.name, 
        inverseBindMatrices: accessors[raw.inverseBindMatrices], 
        joints: raw.joints.map { nodes[$0] })
}
