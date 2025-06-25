func mapBufferViews(
    _ raw: [BufferView],
    buffers: [KGBuffer]
) -> [KGBufferView] {
    return raw.map { mapBufferView($0, buffers: buffers) }
}

func mapBufferView(
    _ raw: BufferView,
    buffers: [KGBuffer]
) -> KGBufferView {
    return KGBufferView(
        buffer: buffers[raw.buffer],
        byteLength: raw.byteLength,
        byteOffset: raw.byteOffset
    )
}
