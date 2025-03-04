func mapSkins(
    _ raw: [KRawGLTFSkin],
    accessors: [KGLTFAccessor],
    nodes: [KGLTFNode]
) -> [KGLTFSkin] {
    return raw.map { mapSkin($0, accessors: accessors, nodes: nodes) }
}

func mapSkin(
    _ raw: KRawGLTFSkin,
    accessors: [KGLTFAccessor],
    nodes: [KGLTFNode]
) -> KGLTFSkin {
    return KGLTFSkin(
        name: raw.name, 
        inverseBindMatrices: accessors[raw.inverseBindMatrices], 
        joints: raw.joints.map { nodes[$0] })
}
