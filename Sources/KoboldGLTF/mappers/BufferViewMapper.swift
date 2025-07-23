func mapBufferViews(
    _ raw: [BufferView],
    buffers: [KGLTFBuffer]
) -> [KGLTFBufferView] {
    return raw.map { mapBufferView($0, buffers: buffers) }
}

func mapBufferView(
    _ raw: BufferView,
    buffers: [KGLTFBuffer]
) -> KGLTFBufferView {
    return KGLTFBufferView(
        buffer: buffers[raw.buffer],
        byteLength: raw.byteLength,
        byteOffset: raw.byteOffset
    )
}
