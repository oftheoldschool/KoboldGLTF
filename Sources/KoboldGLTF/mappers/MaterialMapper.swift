func mapMaterials(
    _ raw: [Material],
    textures: [KGTexture]
) -> [KGMaterial] {
    return raw.map { mapMaterial($0, textures: textures) }
}

func mapMaterial(
    _ raw: Material,
    textures: [KGTexture]
) -> KGMaterial {
    return KGMaterial(
        name: raw.name, 
        doubleSided: raw.doubleSided ?? false, 
        pbrMetallicRoughness: mapPbrMetallicRoughness(
            raw.pbrMetallicRoughness, 
            textures: textures))
}

func mapPbrMetallicRoughness(
    _ raw: Material.PBRMetallicRoughness?,
    textures: [KGTexture]
) -> KGMaterial.KGPBRMetallicRoughness? {
    guard let pbrMetallicRoughness = raw else {
        return nil
    }
    return KGMaterial.KGPBRMetallicRoughness(
        metallicFactor: pbrMetallicRoughness.metallicFactor, 
        roughnessFactor: pbrMetallicRoughness.roughnessFactor, 
        baseColorTexture: mapTextureInfo(
            pbrMetallicRoughness.baseColorTexture, 
            textures: textures))
}

func mapTextureInfo(
    _ raw: TextureInfo,
    textures: [KGTexture]
) -> KGTextureInfo {
    return KGTextureInfo(texture: textures[raw.index])
}
