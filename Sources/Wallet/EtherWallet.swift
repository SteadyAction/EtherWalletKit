import web3swift
import BigInt

public class EtherWallet {
    public class Utils {
        static let shared = EtherWallet.Utils()
        private init() { }
    }
    
    public static let shared = EtherWallet()
    
    private let web3Main = Web3.InfuraMainnetWeb3()
    
    private let keystoreDirectoryName = "/keystore"
    private let keystoreFileName = "/key.json"
    private let gasLimitForTokenTransfer = 100000
    private let gasLimitForEthTransfer = 21000
    
    private var options: Web3Options
    private var keystoreCache: EthereumKeystoreV3?
    
    private init() {
        options = Web3Options.defaultOptions()
        options.gasLimit = BigUInt(gasLimitForTokenTransfer)
        setupOptionsFrom()
    }
    
    private func setupOptionsFrom() {
        if let address = address {
            options.from = EthereumAddress(address)
        } else {
            options.from = nil
        }
    }
    
    // MARK: Account Info
    
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
    
    // MARK: Account Creation
    
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
        
        setupOptionsFrom()
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
    
    // MARK: Account Balance
    
    public func etherBalanceSync() throws -> String {
        guard let address = address else { throw WalletError.accountDoesNotExist }
        guard let ethereumAddress = EthereumAddress(address) else { throw WalletError.invalidAddress }
        
        let balanceInWeiUnitResult = web3Main.eth.getBalance(address: ethereumAddress)
        guard case .success(let balanceInWei) = balanceInWeiUnitResult else { throw WalletError.networkFailure }

        guard let balanceInEtherUnitStr = Web3.Utils.formatToEthereumUnits(balanceInWei, toUnits: Web3.Utils.Units.eth, decimals: 8, decimalSeparator: ".") else { throw WalletError.conversionFailure }
        
        return balanceInEtherUnitStr
    }
    
    public func etherBalance(completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let balance = try? self.etherBalanceSync()
            DispatchQueue.main.async {
                completion(balance)
            }
        }
    }
    
    public func tokenBalance(contractAddress: String) throws -> String {
        let contractEthreumAddress = EthereumAddress(contractAddress)
        guard let contract = web3Main.contract(Web3.Utils.erc20ABI, at: contractEthreumAddress) else { throw
            WalletError.invalidAddress
        }
        guard let address = address else { throw WalletError.accountDoesNotExist }
        
        let parameters = [address as AnyObject]
        let contractMethod = contract.method("balanceOf", parameters: parameters, extraData: Data(), options: options)
        let balanceOfCallResult = contractMethod?.call(options: nil)
        guard case .success(let balanceInfo)? = balanceOfCallResult, let balance = balanceInfo["0"] as? BigUInt else { throw WalletError.networkFailure
        }
        
        return "\(balance)"
    }
    
    public func tokenBalanceAsync(contractAddress: String, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let balance = try? self.tokenBalance(contractAddress: contractAddress)
            DispatchQueue.main.async {
                completion(balance)
            }
        }
    }
}
