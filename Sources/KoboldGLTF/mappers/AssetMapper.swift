func mapAsset(_ raw: Asset) -> KGAsset {
    return KGAsset(
        version: raw.version,
        minVersion: raw.minVersion,
        generator: raw.generator,
        copyright: raw.copyright
    )
}
