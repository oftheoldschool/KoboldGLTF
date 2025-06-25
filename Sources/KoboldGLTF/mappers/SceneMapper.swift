func mapScenes(_ raw: [Scene], nodes: [KGNode]) -> [KGScene] {
    return raw.map { mapScene($0, nodes: nodes) }
}

func mapScene(_ raw: Scene, nodes: [KGNode]) -> KGScene {
    return KGScene(
        name: raw.name, 
        nodes: raw.nodes.map { nodes[$0] })
} 
