import Foundation
import simd

public struct KGAsset {
    public let version: String
    public let minVersion: String?
    public let generator: String?
    public let copyright: String?
}

public class KGBuffer {
    public let data: Data
    
    init(data: Data) {
        self.data = data
    }
}

public class KGBufferView {
    public let buffer: KGBuffer
    public let byteLength: Int
    public let byteOffset: Int
    
    init(
        buffer: KGBuffer,
        byteLength: Int,
        byteOffset: Int
    ) {
        self.buffer = buffer
        self.byteLength = byteLength
        self.byteOffset = byteOffset
    }
}

public enum KGComponentType {
    case byte
    case ubyte
    case short
    case ushort
    case uint
    case float
}

public class KGNode {
    public let id: Int
    public let name: String
    public let mesh: KGMesh?
    public var skin: KGSkin?
    public var parent: KGNode?
    public var children: [KGNode]?
    public let rotation: simd_quatf?
    public let translation: SIMD3<Float>?
    public let scale: SIMD3<Float>?
    
    init(
        id: Int,
        name: String,
        mesh: KGMesh?,
        skin: KGSkin?,
        parent: KGNode?,
        children: [KGNode]?,
        rotation: simd_quatf?,
        translation: SIMD3<Float>?,
        scale: SIMD3<Float>?
    ) {
        self.id = id
        self.name = name
        self.mesh = mesh
        self.skin = skin
        self.parent = parent
        self.children = children
        self.rotation = rotation
        self.translation = translation
        self.scale = scale
    }
}

public class KGScene {
    public let name: String
    public let nodes: [KGNode]
    
    init(name: String, nodes: [KGNode]) {
        self.name = name
        self.nodes = nodes
    }
}

public class KGSampler {
    public enum KGSamplerMagFilter: Decodable {
        case nearest
        case linear
    }
    
    public enum KGSamplerMinFilter: Decodable {
        case nearest
        case linear
        case nearestMipMapNearest
        case linearMipMapNearest
        case nearestMipMapLinear
        case linearMipMapLinear
    }
    
    public enum KGSamplerWrap: Decodable {
        case clampToEdge
        case mirroredRepeat
        case standardRepeat
    }

    public let minFilter: KGSamplerMinFilter?
    public let magFilter: KGSamplerMagFilter?
    public let wrapS: KGSamplerWrap?
    public let wrapT: KGSamplerWrap?
    
    init(
        minFilter: KGSamplerMinFilter?,
        magFilter: KGSamplerMagFilter?,
        wrapS: KGSamplerWrap?,
        wrapT: KGSamplerWrap?
    ) {
        self.minFilter = minFilter
        self.magFilter = magFilter
        self.wrapS = wrapS
        self.wrapT = wrapT
    }
}

public class KGImage {
    public let name: String
    public let bufferView: KGBufferView
    public let mimeType: String
    
    init(
        name: String,
        bufferView: KGBufferView,
        mimeType: String
    ) {
        self.name = name
        self.bufferView = bufferView
        self.mimeType = mimeType
    }
}

public struct KGTextureInfo {
    public let texture: KGTexture
}

public class KGMaterial {
    public struct KGPBRMetallicRoughness {
        public let metallicFactor: Float?
        public let roughnessFactor: Float?
        public let baseColorTexture: KGTextureInfo?
    }
    
    public let name: String
    public let doubleSided: Bool
    public let pbrMetallicRoughness: KGPBRMetallicRoughness?
    
    init(
        name: String,
        doubleSided: Bool,
        pbrMetallicRoughness: KGPBRMetallicRoughness?
    ) {
        self.name = name
        self.doubleSided = doubleSided
        self.pbrMetallicRoughness = pbrMetallicRoughness
    }
}

public struct KGTexture {
    public let sampler: KGSampler
    public let source: KGImage
}

public struct KGSkin {
    public let name: String
    public let inverseBindMatrices: KGAccessor
    public let joints: [KGNode]
}

public enum KGAnimationChannelTargetPath {
    case translation
    case rotation
    case scale
}

public struct KGAnimationChannelTarget {
    public let node: KGNode
    public let path: KGAnimationChannelTargetPath
}

public struct KGAnimationChannel {
    public let sampler: KGAnimationSampler
    public let target: KGAnimationChannelTarget
}

public enum KGAnimationSamplerInterpolation {
    case linear
    case step
    case cubicSpline
}

public class KGAnimationSampler {
    public let interpolation: KGAnimationSamplerInterpolation
    public let input: KGAccessor
    public let output: KGAccessor
    
    init(
        interpolation: KGAnimationSamplerInterpolation,
        input: KGAccessor,
        output: KGAccessor
    ) {
        self.interpolation = interpolation
        self.input = input
        self.output = output
    }
}

public struct KGAnimation {
    public let name: String
    public let channels: [KGAnimationChannel]
    public let samplers: [KGAnimationSampler]
}

public enum KGAttributeType {
    case position
    case normal
    case tangent
    case texCoord(n: Int)
    case color(n: Int)
    case joints(n: Int)
    case weights(n: Int)
    
    public var rawValue : Int {
        get {
            switch self {
            case .position: return 0
            case .normal: return 1
            case .tangent: return 2
            case .texCoord(n: _): return 3
            case .color(n: _): return 4
            case .joints(n: _): return 5
            case .weights(n: _): return 6
            }
        }
    }
}

public struct KGMesh {
    public struct KGMeshPrimitive {
        public let indices: KGAccessor
        public let material: KGMaterial
        public let attributes: [KGAttributeType: KGAccessor]
    }
    
    public let name: String
    public let primitives: [KGMeshPrimitive]
}

extension KGAttributeType: Hashable, Equatable, Comparable {
    public static func == (
        lhs: KGAttributeType, 
        rhs: KGAttributeType
    ) -> Bool {
        switch (lhs, rhs) {
        case (.position, .position), (.normal, .normal), (.tangent, .tangent):
            return true
        case (.texCoord(let li), .texCoord(let ri)),
            (.color(let li), .color(let ri)),
            (.joints(let li), .joints(let ri)),
            (.weights(let li), .weights(let ri)):
            return li == ri
        default:
            return false
        }
    }
   
    public static func < (lhs: KGAttributeType, rhs: KGAttributeType) -> Bool {
        switch (lhs, rhs) {
        case (.texCoord(let ia), .texCoord(let ib)),
            (.weights(let ia), .weights(let ib)),
            (.joints(let ia), .joints(let ib)),
            (.color(let ia), .color(let ib)):
            return ia < ib
        default:
            return lhs.rawValue < rhs.rawValue
        }
    }
}

public struct KGFile {
    public let asset: KGAsset
    public let buffers: [KGBuffer]
    public let bufferViews: [KGBufferView]
    public let accessors: [KGAccessor]
    public let nodes: [KGNode]
    public let scenes: [KGScene]
    public let scene: KGScene
    public let samplers: [KGSampler]
    public let images: [KGImage]
    public let textures: [KGTexture]
    public let materials: [KGMaterial]
    public let skins: [KGSkin]
    public let meshes: [KGMesh]
    public let animations: [KGAnimation]
}
