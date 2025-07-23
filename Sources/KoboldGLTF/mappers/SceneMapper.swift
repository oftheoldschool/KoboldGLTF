func mapScenes(_ raw: [Scene], nodes: [KGLTFNode]) -> [KGLTFScene] {
    return raw.map { mapScene($0, nodes: nodes) }
}

func mapScene(_ raw: Scene, nodes: [KGLTFNode]) -> KGLTFScene {
    return KGLTFScene(
        name: raw.name, 
        nodes: raw.nodes.map { nodes[$0] })
} 
