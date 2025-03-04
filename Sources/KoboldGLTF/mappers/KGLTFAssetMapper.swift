func mapAsset(_ raw: KRawGLTFAsset) -> KGLTFAsset {
    return KGLTFAsset(
        version: raw.version,
        minVersion: raw.minVersion,
        generator: raw.generator,
        copyright: raw.copyright
    )
}
