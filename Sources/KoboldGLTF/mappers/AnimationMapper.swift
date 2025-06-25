func mapAnimations(
    _ raw: [Animation],
    accessors: [KGAccessor],
    nodes: [KGNode]
) -> [KGAnimation] {
    return raw.map { 
        mapAnimation(
            $0, 
            accessors: accessors,
            nodes: nodes)
    }
}

func mapAnimation(
    _ raw: Animation,
    accessors: [KGAccessor],
    nodes: [KGNode]
) -> KGAnimation {
    let samplers = mapAnimationSamplers(
        raw.samplers,
        accessors: accessors)
    let channels = mapAnimationChannels(
        raw.channels,
        samplers: samplers,
        nodes: nodes)
    return KGAnimation(
        name: raw.name, 
        channels: channels, 
        samplers: samplers)
}

func mapAnimationChannels(
    _ raw: [AnimationChannel],
    samplers: [KGAnimationSampler],
    nodes: [KGNode]
) -> [KGAnimationChannel] {
    return raw.map { rawChannel in
        KGAnimationChannel(
            sampler: samplers[rawChannel.sampler], 
            target: mapAnimationChannelTarget(
                rawChannel.target,
                nodes: nodes))
    }
}

func mapAnimationChannelTarget(
    _ raw: AnimationChannelTarget,
    nodes: [KGNode]
) -> KGAnimationChannelTarget {
    return KGAnimationChannelTarget(
        node: nodes[raw.node], 
        path: mapAnimationChannelTargetPath(raw.path))
}

func mapAnimationChannelTargetPath(
    _ raw: AnimationChannelTargetPath
) -> KGAnimationChannelTargetPath {
    switch raw {
    case .translation: return .translation
    case .rotation: return .rotation
    case .scale: return .scale
    }
}

func mapAnimationSamplers(
    _ raw: [AnimationSampler],
    accessors: [KGAccessor]
) -> [KGAnimationSampler] {
    return raw.map { rawSampler in
        return KGAnimationSampler(
            interpolation: mapAnimationSamplerInterpolation(rawSampler.interpolation), 
            input: accessors[rawSampler.input], 
            output: accessors[rawSampler.output])
    }
}

func mapAnimationSamplerInterpolation(
    _ raw: AnimationSamplerInterpolation
) -> KGAnimationSamplerInterpolation {
    switch raw {
    case .linear: return .linear
    case .step: return .step
    case .cubicSpline: return .cubicSpline
    }
}
