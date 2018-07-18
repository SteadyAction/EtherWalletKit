public enum WalletError: Error {
    case accountDoesNotExist
    case invalidPath
    case invalidKey
    case invalidAddress
    case malformedKeystore
    case networkFailure
    case conversionFailure
    case notEnoughBalance
    case contractFailure
}
