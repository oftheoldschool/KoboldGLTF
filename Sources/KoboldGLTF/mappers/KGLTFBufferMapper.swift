import Foundation

func mapBuffers(_ raw: [KRawGLTFBuffer], binData: [UInt8]?) throws -> [KGLTFBuffer] {
    return try raw.map { try mapBuffer($0, binData: binData) }
}

func mapBuffer(_ raw: KRawGLTFBuffer, binData: [UInt8]?) throws -> KGLTFBuffer {
    let byteLength = raw.byteLength
    
    if let uri = raw.uri {
        // format should be "data:application/octet-stream;base64,"
        if uri.starts(with: "data:") {
            let mimeTypeStart = uri.index(after: uri.firstIndex(of: ":")!)
            let mimeTypeEnd = uri.firstIndex(of: ";")!
            let mimeType = uri[mimeTypeStart ..< mimeTypeEnd]
            
            let encodingStart = uri.index(after: mimeTypeEnd)
            let encodingEnd = uri.firstIndex(of: ",")!
            let encoding = uri[encodingStart ..< encodingEnd]
            
            let encodedDataStart = uri.index(after: encodingEnd)
            let encodedData: String = String(uri[encodedDataStart...])
            
            if encoding == "base64" {
                if let data = Data(base64Encoded: encodedData) {
                    if data.count != byteLength {
                        throw KGLTFError.bufferURIDataLengthMismatch("base64 encoded buffer found with actual size \(data.count) and expected size \(byteLength)")
                    }
                    return KGLTFBuffer(data: data)
                } else {
                    throw KGLTFError.bufferURIDataInvalid("could not decode URI data with encoding \(encoding), expected size \(byteLength)")
                }
            } else {
                throw KGLTFError.bufferURIDataUnsupported("URI data with encoding \(encoding) is not supported")
            }
        }
    } else if let data = binData {
        return KGLTFBuffer(data: Data(data))
    }

    throw KGLTFError.bufferDataUnknown("Neither uri nor binary data supplied")
}
