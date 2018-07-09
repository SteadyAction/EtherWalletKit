import web3swift
import BigInt

public class EtherWallet {
    public class Utils {
        static let shared = EtherWallet.Utils()
        private init() { }
    }
    
    public static let shared = EtherWallet()
    
    public let defaultGasLimitForTokenTransfer = 100000
    let web3Main = Web3.InfuraMainnetWeb3()
    let keystoreDirectoryName = "/keystore"
    let keystoreFileName = "/key.json"
    
    var options: Web3Options
    var keystoreCache: EthereumKeystoreV3?
    
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
