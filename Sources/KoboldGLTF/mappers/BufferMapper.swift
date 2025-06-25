import Foundation

func mapBuffers(_ raw: [Buffer], binData: [UInt8]?) throws -> [KGBuffer] {
    return try raw.map { try mapBuffer($0, binData: binData) }
}

func mapBuffer(_ raw: Buffer, binData: [UInt8]?) throws -> KGBuffer {
    let byteLength = raw.byteLength
    
    if let uri = raw.uri {
        // format should be "data:application/octet-stream;base64,"
        if uri.starts(with: "data:") {
            let mimeTypeStart = uri.index(after: uri.firstIndex(of: ":")!)
            let mimeTypeEnd = uri.firstIndex(of: ";")!
            let _ = uri[mimeTypeStart ..< mimeTypeEnd]
            
            let encodingStart = uri.index(after: mimeTypeEnd)
            let encodingEnd = uri.firstIndex(of: ",")!
            let encoding = uri[encodingStart ..< encodingEnd]
            
            let encodedDataStart = uri.index(after: encodingEnd)
            let encodedData: String = String(uri[encodedDataStart...])
            
            if encoding == "base64" {
                if let data = Data(base64Encoded: encodedData) {
                    if data.count != byteLength {
                        throw KGError.bufferURIDataLengthMismatch("base64 encoded buffer found with actual size \(data.count) and expected size \(byteLength)")
                    }
                    return KGBuffer(data: data)
                } else {
                    throw KGError.bufferURIDataInvalid("could not decode URI data with encoding \(encoding), expected size \(byteLength)")
                }
            } else {
                throw KGError.bufferURIDataUnsupported("URI data with encoding \(encoding) is not supported")
            }
        }
    } else if let data = binData {
        return KGBuffer(data: Data(data))
    }

    throw KGError.bufferDataUnknown("Neither uri nor binary data supplied")
}
