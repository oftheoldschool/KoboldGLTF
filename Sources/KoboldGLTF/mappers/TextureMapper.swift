func mapTextures(
    _ raw: [Texture], 
    samplers: [KGSampler],
    images: [KGImage]
) -> [KGTexture] {
    return raw.map { mapTexture($0, samplers: samplers, images: images) }
}

func mapTexture(
    _ raw: Texture, 
    samplers: [KGSampler],
    images: [KGImage]
) -> KGTexture {
    return KGTexture(
        sampler: samplers[raw.sampler], 
        source: images[raw.source])    
}
