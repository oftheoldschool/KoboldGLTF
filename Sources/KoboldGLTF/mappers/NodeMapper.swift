import simd

func mapNodes(_ raw: [Node], meshes: [KGMesh]) throws -> [KGNode] {
    let mappedNodes = try raw.enumerated().map { index, rawNode in
        try mapNode(rawNode, id: index, meshes: meshes)
    }
    
    let nodes = mappedNodes.enumerated().map { index, mappedNode in
        let rawNode = raw[index]
        if rawNode.children == nil {
            return mappedNode
        }
        mappedNode.children = rawNode.children?.map { childIndex in
            let child = mappedNodes[childIndex]
            child.parent = mappedNode
            return child
        }
        return mappedNode
    }
    
    return nodes
}

func mapNode(_ raw: Node, id: Int, meshes: [KGMesh]) throws -> KGNode {
    var mesh: KGMesh?
    if let meshIndex = raw.mesh {
        mesh = meshes[meshIndex]
    }
    return KGNode(
        id: id,
        name: raw.name,
        mesh: mesh,
        skin: nil,
        parent: nil,
        children: nil, 
        rotation: try mapNodeQuat(raw.rotation),
        translation: try mapNodeVec3(raw.translation),
        scale: try mapNodeVec3(raw.scale))
}

func updateNodesWithSkin(
    nodes: [KGNode], 
    rawNodes: [Node],
    skins: [KGSkin]
) {
    zip(nodes, rawNodes).forEach { node, rawNode in
        if let skinIndex = rawNode.skin {
            node.skin = skins[skinIndex]
        }
    }
}

func mapNodeQuat(_ raw: [Float]?) throws -> simd_quatf? {
    guard let rawQuat = raw else {
        return nil
    }
    if rawQuat.count != 4 {
        throw KGError.nodeDataMismatch("Unable to map node rotation - received \(rawQuat.count) components instead of 4")
    }
    return simd_quatf(
        ix: rawQuat[0],
        iy: rawQuat[1],
        iz: rawQuat[2],
        r: rawQuat[3]
    )
}

func mapNodeVec3(_ raw: [Float]?) throws -> SIMD3<Float>? {
    guard let rawVec = raw else {
        return nil
    }
    if rawVec.count != 3 {
        throw KGError.nodeDataMismatch("Unable to map node translation, or scale - received \(rawVec.count) components instead of 3")
    }
    return SIMD3<Float>(rawVec)
}
