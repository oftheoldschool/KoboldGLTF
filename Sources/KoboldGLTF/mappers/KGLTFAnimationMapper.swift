func mapAnimations(
    _ raw: [KRawGLTFAnimation],
    accessors: [KGLTFAccessor],
    nodes: [KGLTFNode]
) -> [KGLTFAnimation] {
    return raw.map { 
        mapAnimation(
            $0, 
            accessors: accessors,
            nodes: nodes)
    }
}

func mapAnimation(
    _ raw: KRawGLTFAnimation,
    accessors: [KGLTFAccessor],
    nodes: [KGLTFNode]
) -> KGLTFAnimation {
    let samplers = mapAnimationSamplers(
        raw.samplers,
        accessors: accessors)
    let channels = mapAnimationChannels(
        raw.channels,
        samplers: samplers,
        nodes: nodes)
    return KGLTFAnimation(
        name: raw.name, 
        channels: channels, 
        samplers: samplers)
}

func mapAnimationChannels(
    _ raw: [KRawGLTFAnimationChannel],
    samplers: [KGLTFAnimationSampler],
    nodes: [KGLTFNode]
) -> [KGLTFAnimationChannel] {
    return raw.map { rawChannel in
        KGLTFAnimationChannel(
            sampler: samplers[rawChannel.sampler], 
            target: mapAnimationChannelTarget(
                rawChannel.target,
                nodes: nodes))
    }
}

func mapAnimationChannelTarget(
    _ raw: KRawGLTFAnimationChannelTarget,
    nodes: [KGLTFNode]
) -> KGLTFAnimationChannelTarget {
    return KGLTFAnimationChannelTarget(
        node: nodes[raw.node], 
        path: mapAnimationChannelTargetPath(raw.path))
}

func mapAnimationChannelTargetPath(
    _ raw: KRawGLTFAnimationChannelTargetPath
) -> KGLTFAnimationChannelTargetPath {
    switch raw {
    case .translation: return .translation
    case .rotation: return .rotation
    case .scale: return .scale
    }
}

func mapAnimationSamplers(
    _ raw: [KRawGLTFAnimationSampler],
    accessors: [KGLTFAccessor]
) -> [KGLTFAnimationSampler] {
    return raw.map { rawSampler in
        return KGLTFAnimationSampler(
            interpolation: mapAnimationSamplerInterpolation(rawSampler.interpolation), 
            input: accessors[rawSampler.input], 
            output: accessors[rawSampler.output])
    }
}

func mapAnimationSamplerInterpolation(
    _ raw: KRawGLTFAnimationSamplerInterpolation
) -> KGLTFAnimationSamplerInterpolation {
    switch raw {
    case .linear: return .linear
    case .step: return .step
    case .cubicSpline: return .cubicSpline
    }
}
