func mapTextures(
    _ raw: [KRawGLTFTexture], 
    samplers: [KGLTFSampler],
    images: [KGLTFImage]
) -> [KGLTFTexture] {
    return raw.map { mapTexture($0, samplers: samplers, images: images) }
}

func mapTexture(
    _ raw: KRawGLTFTexture, 
    samplers: [KGLTFSampler],
    images: [KGLTFImage]
) -> KGLTFTexture {
    return KGLTFTexture(
        sampler: samplers[raw.sampler], 
        source: images[raw.source])    
}
