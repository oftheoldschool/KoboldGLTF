func mapMaterials(
    _ raw: [KRawGLTFMaterial],
    textures: [KGLTFTexture]
) -> [KGLTFMaterial] {
    return raw.map { mapMaterial($0, textures: textures) }
}

func mapMaterial(
    _ raw: KRawGLTFMaterial,
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
    _ raw: KRawGLTFMaterial.KRawGLTFPBRMetallicRoughness?,
    textures: [KGLTFTexture]
) -> KGLTFMaterial.KGLTFPBRMetallicRoughness? {
    guard let pbrMetallicRoughness = raw else {
        return nil
    }
    return KGLTFMaterial.KGLTFPBRMetallicRoughness(
        metallicFactor: pbrMetallicRoughness.metallicFactor, 
        roughnessFactor: pbrMetallicRoughness.roughnessFactor, 
        baseColorTexture: mapTextureInfo(
            pbrMetallicRoughness.baseColorTexture, 
            textures: textures))
}

func mapTextureInfo(
    _ raw: KRawGLTFTextureInfo,
    textures: [KGLTFTexture]
) -> KGLTFTextureInfo {
    return KGLTFTextureInfo(texture: textures[raw.index])
}
