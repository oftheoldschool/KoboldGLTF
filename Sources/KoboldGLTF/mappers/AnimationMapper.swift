func mapAnimations(
    _ raw: [Animation],
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
    _ raw: Animation,
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
    _ raw: [AnimationChannel],
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
    _ raw: AnimationChannelTarget,
    nodes: [KGLTFNode]
) -> KGLTFAnimationChannelTarget {
    return KGLTFAnimationChannelTarget(
        node: nodes[raw.node], 
        path: mapAnimationChannelTargetPath(raw.path))
}

func mapAnimationChannelTargetPath(
    _ raw: AnimationChannelTargetPath
) -> KGLTFAnimationChannelTargetPath {
    return switch raw {
    case .translation: .translation
    case .rotation: .rotation
    case .scale: .scale
    }
}

func mapAnimationSamplers(
    _ raw: [AnimationSampler],
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
    _ raw: AnimationSamplerInterpolation
) -> KGLTFAnimationSamplerInterpolation {
    return switch raw {
    case .linear: .linear
    case .step: .step
    case .cubicSpline: .cubicSpline
    }
}
