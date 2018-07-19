import web3swift

public protocol InfoService {
    func decimalsForToken(address: String) throws -> String?
    func symbolForToken(address: String) throws -> String?
}

extension EtherWallet: InfoService {
    public func decimalsForToken(address: String) throws -> String? {
        let contract = try erc20contract(address: address)
        let parameters = [AnyObject]()
        let decimalCallResult = contract.method("decimals", parameters: parameters, extraData: Data(), options: options)?.call(options: nil)
        guard case .success(let decimalsInfo)? = decimalCallResult, let decimals = decimalsInfo["0"] else { throw WalletError.networkFailure }
        
        return String(describing: decimals)
    }
    
    public func symbolForToken(address: String) throws -> String? {
        let contract = try erc20contract(address: address)
        let parameters = [AnyObject]()
        let symbolCallResult = contract.method("symbol", parameters: parameters, extraData: Data(), options: options)?.call(options: nil)
        guard case .success(let symbolInfo)? = symbolCallResult, let symbol = symbolInfo["0"] as? String else { throw WalletError.networkFailure }
        
        if symbol.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return nil
        }
        
        return symbol
    }
    
    private func erc20contract(address: String) throws -> web3.web3contract {
        let contractEthreumAddress = EthereumAddress(address)
        guard let contract = web3Main.contract(Web3.Utils.erc20ABI, at: contractEthreumAddress) else { throw WalletError.contractFailure }
        
        return contract
    }
}
