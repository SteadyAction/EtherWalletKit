import web3swift

public class EtherWallet {
    public class Utils { private init() { } }
    
    public static let shared = EtherWallet()
    
    private let web3Main = Web3.InfuraMainnetWeb3()
    
    private let keystoreDirectoryName = "/keystore"
    private let keystoreFileName = "/key.json"
    
    private var keystoreCache: EthereumKeystoreV3? = nil
    
    private init() { }
    
    public var hasAccount: Bool {
        return (try? loadKeystore()) != nil
    }
    
    public var address: String? {
        guard let keystore = try? loadKeystore() else { return nil }
        return keystore.getAddress()?.address
    }
    
    public func generateAccount(password: String) throws {
        guard let keystore = try EthereumKeystoreV3(password: password) else {
            throw WalletError.malformedKeystore
        }
        
        try saveKeystore(keystore)
    }
    
    public func importAccount(privateKey: String, password: String) throws {
        guard let privateKeyData = Data.fromHex(privateKey) else {
            throw WalletError.invalidKey
        }
        guard let keystore = try EthereumKeystoreV3(privateKey: privateKeyData, password: password) else {
            throw WalletError.malformedKeystore
        }
        
        try saveKeystore(keystore)
    }
    
    private func saveKeystore(_ keystore: EthereumKeystoreV3) throws {
        keystoreCache = keystore
        
        guard let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            throw WalletError.invalidPath
        }
        guard let keystoreParams = keystore.keystoreParams else {
            throw WalletError.malformedKeystore
        }
        guard let keystoreData = try? JSONEncoder().encode(keystoreParams) else {
            throw WalletError.malformedKeystore
        }
        if !FileManager.default.fileExists(atPath: userDir + keystoreDirectoryName) {
            do {
                try FileManager.default.createDirectory(atPath: userDir + keystoreDirectoryName, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw WalletError.invalidPath
            }
        }
        
        FileManager.default.createFile(atPath: userDir + keystoreDirectoryName + keystoreFileName, contents: keystoreData, attributes: nil)
    }
    
    private func loadKeystore() throws -> EthereumKeystoreV3 {
        if let keystore = keystoreCache {
            return keystore
        }
        
        guard let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            throw WalletError.invalidPath
        }
        guard let keystoreManager = KeystoreManager.managerForPath(userDir + keystoreDirectoryName) else {
            throw WalletError.malformedKeystore
        }
        guard let address = keystoreManager.addresses?.first else {
            throw WalletError.malformedKeystore
        }
        guard let keystore = keystoreManager.walletForAddress(address) as? EthereumKeystoreV3 else {
            throw WalletError.malformedKeystore
        }
        
        keystoreCache = keystore
        
        return keystore
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
