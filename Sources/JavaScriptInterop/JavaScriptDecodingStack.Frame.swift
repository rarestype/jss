extension JavaScriptDecodingStack {
    @frozen @usableFromInline enum Frame: Sendable {
        case field(String)
        case index(Int)
    }
}
