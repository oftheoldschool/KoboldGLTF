import Foundation

func mapImages(_ raw: [Image], bufferViews: [KGBufferView]) -> [KGImage] {
    return raw.map { raw in mapImage(raw, bufferViews: bufferViews) }
}

func hexDescription(data: Data) -> String {
    return data.reduce("") {$0 + String(format: "%02x ", $1)}
}

func mapImage(_ raw: Image, bufferViews: [KGBufferView]) -> KGImage {
    return KGImage(
        name: raw.name, 
        bufferView: bufferViews[raw.bufferView], 
        mimeType: raw.mimeType)
}
