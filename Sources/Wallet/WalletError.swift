enum WalletError: Error {
    case accountDoesNotExist
    case invalidPath
    case invalidKey
    case malformedKeystore
}
