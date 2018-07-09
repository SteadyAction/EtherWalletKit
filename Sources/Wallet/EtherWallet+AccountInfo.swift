import web3swift

extension EtherWallet {
    public var hasAccount: Bool {
        return (try? loadKeystore()) != nil
    }
    
    public var address: String? {
        guard let keystore = try? loadKeystore() else { return nil }
        return keystore.getAddress()?.address
    }
    
    public func privateKey(password: String) throws -> String {
        let keystore = try loadKeystore()
        guard let address = keystore.getAddress()?.address else {
            throw WalletError.malformedKeystore
        }
        guard let ethereumAddress = EthereumAddress(address) else {
            throw  WalletError.invalidAddress
        }
        let privateKeyData = try keystore.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress)
        
        return privateKeyData.toHexString()
    }
    
    public func isCorrectPassword(_ password: String) -> Bool {
        return (try? privateKey(password: password)) != nil
    }
}
