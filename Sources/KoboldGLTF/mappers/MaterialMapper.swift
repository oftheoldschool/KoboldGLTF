func mapMaterials(
    _ raw: [Material],
    textures: [KGLTFTexture]
) -> [KGLTFMaterial] {
    return raw.map { mapMaterial($0, textures: textures) }
}

func mapMaterial(
    _ raw: Material,
    textures: [KGLTFTexture]
) -> KGLTFMaterial {
    return KGLTFMaterial(
        name: raw.name, 
        doubleSided: raw.doubleSided ?? false, 
        pbrMetallicRoughness: mapPbrMetallicRoughness(
            raw.pbrMetallicRoughness, 
            textures: textures))
}

func mapPbrMetallicRoughness(
    _ raw: Material.PBRMetallicRoughness?,
    textures: [KGLTFTexture]
) -> KGLTFMaterial.KGPBRMetallicRoughness? {
    guard let pbrMetallicRoughness = raw else {
        return nil
    }
    return KGLTFMaterial.KGPBRMetallicRoughness(
        metallicFactor: pbrMetallicRoughness.metallicFactor, 
        roughnessFactor: pbrMetallicRoughness.roughnessFactor, 
        baseColorTexture: mapTextureInfo(
            pbrMetallicRoughness.baseColorTexture, 
            textures: textures))
}

func mapTextureInfo(
    _ raw: TextureInfo,
    textures: [KGLTFTexture]
) -> KGLTFTextureInfo {
    return KGLTFTextureInfo(texture: textures[raw.index])
}
