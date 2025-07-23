func mapSamplers(_ raw: [Sampler]) -> [KGLTFSampler] {
    return raw.map(mapSampler)
} 

func mapSampler(_ raw: Sampler) -> KGLTFSampler {
    return KGLTFSampler(
        minFilter: mapSamplerMinFilter(raw.minFilter), 
        magFilter: mapSamplerMagFilter(raw.magFilter), 
        wrapS: mapSamplerWrap(raw.wrapS), 
        wrapT: mapSamplerWrap(raw.wrapT))
}

func mapSamplerWrap(_ raw: Sampler.SamplerWrap?) -> KGLTFSampler.KGLTFSamplerWrap? {
    guard let wrap = raw else {
        return nil
    }
    switch wrap {
    case .standardRepeat: return .standardRepeat
    case .mirroredRepeat: return .mirroredRepeat
    case .clampToEdge: return .clampToEdge
    }
}

func mapSamplerMinFilter(_ raw: Sampler.SamplerMinFilter?) -> KGLTFSampler.KGLTFSamplerMinFilter? {
    guard let minFilter = raw else {
        return nil
    }
    switch minFilter {
    case .nearest: return .nearest
    case .linear: return .linear
    case .nearestMipMapNearest: return .nearestMipMapNearest
    case .linearMipMapNearest: return .linearMipMapNearest
    case .nearestMipMapLinear: return .nearestMipMapLinear
    case .linearMipMapLinear: return .linearMipMapLinear
    }
}

func mapSamplerMagFilter(_ raw: Sampler.SamplerMagFilter?) -> KGLTFSampler.KGLTFSamplerMagFilter? {
    guard let magFilter = raw else {
        return nil
    }
    switch magFilter {
    case .nearest: return .nearest
    case .linear: return .linear
    }
}
