public enum KGLTFError: Error {
    case filenameNotSupported(String)
    case fileNotFound(String)
    case fileNotReadable(String)
    case fileHeaderInvalid(String)
    case bufferDataUnknown(String)
    case bufferURIDataInvalid(String)
    case bufferURIDataUnsupported(String)
    case bufferURIDataLengthMismatch(String)
    case attributeTypeUnknown(String)
    case nodeDataMismatch(String)
}
