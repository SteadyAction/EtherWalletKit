import web3swift
import BigInt

public class EtherWallet {
    private static let shared = EtherWallet()
    public static let account: AccountService = EtherWallet.shared
    public static let balance: BalanceService = EtherWallet.shared
    public static let info: InfoService = EtherWallet.shared
    public static let transaction: TransactionService = EtherWallet.shared
    public static let util: UtilService = EtherWallet.shared
    
    private let web3Main = Web3.InfuraMainnetWeb3()
    let keystoreDirectoryName = "/keystore"
    let keystoreFileName = "/key.json"
    let MnemonicsKeystoreKey = "MnemonicsKeystoreKey"
    let defaultGasLimitForTokenTransfer = 100000
    
    var options: Web3Options
    var keystoreCache: EthereumKeystoreV3?
    
    var web3Instance: web3 {
        return web3Main
    }
    
    private init() {
        options = Web3Options.defaultOptions()
        options.gasLimit = BigUInt(defaultGasLimitForTokenTransfer)
        setupOptionsFrom()
    }
    
    func setupOptionsFrom() {
        if let address = address {
            options.from = EthereumAddress(address)
        } else {
            options.from = nil
        }
    }
}


