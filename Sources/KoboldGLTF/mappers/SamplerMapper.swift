func mapSamplers(_ raw: [Sampler]?) -> [KGLTFSampler] {
    return (raw ?? []).map(mapSampler)
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
    return switch wrap {
    case .standardRepeat: .standardRepeat
    case .mirroredRepeat: .mirroredRepeat
    case .clampToEdge: .clampToEdge
    }
}

func mapSamplerMinFilter(_ raw: Sampler.SamplerMinFilter?) -> KGLTFSampler.KGLTFSamplerMinFilter? {
    guard let minFilter = raw else {
        return nil
    }
    return switch minFilter {
    case .nearest: .nearest
    case .linear: .linear
    case .nearestMipMapNearest: .nearestMipMapNearest
    case .linearMipMapNearest: .linearMipMapNearest
    case .nearestMipMapLinear: .nearestMipMapLinear
    case .linearMipMapLinear: .linearMipMapLinear
    }
}

func mapSamplerMagFilter(_ raw: Sampler.SamplerMagFilter?) -> KGLTFSampler.KGLTFSamplerMagFilter? {
    guard let magFilter = raw else {
        return nil
    }
    return switch magFilter {
    case .nearest: .nearest
    case .linear: .linear
    }
}
