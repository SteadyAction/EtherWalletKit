import Web3swift
import EthereumAddress

public protocol InfoService {
    func decimalsForTokenSync(address: String) throws -> Int
    func decimalsForToken(address: String, completion: @escaping (Int?) -> ())
    func symbolForTokenSync(address: String) throws -> String
    func symbolForToken(address: String, completion: @escaping (String?) -> ())
}

extension EtherWallet: InfoService {
    public func decimalsForTokenSync(address: String) throws -> Int {
        let contract = try erc20contract(address: address)
        let parameters = [AnyObject]()
        guard let decimalsInfo = try? contract.method("decimals", parameters: parameters, extraData: Data(), transactionOptions: transactionOptions)?.call(transactionOptions: nil), let decimals = decimalsInfo?["0"] else {
            throw WalletError.networkFailure
        }
        
        guard let result = decimals as? Int else {
            throw WalletError.unexpectedResult
        }
        
        return result
    }
    
    public func decimalsForToken(address: String, completion: @escaping (Int?) -> ()) {
        DispatchQueue.global().async {
            let decimals = try? self.decimalsForTokenSync(address: address)
            DispatchQueue.main.async {
                completion(decimals)
            }
        }
    }
    
    public func symbolForTokenSync(address: String) throws -> String {
        let contract = try erc20contract(address: address)
        let parameters = [AnyObject]()
        guard let symbolInfo = try? contract.method("symbol", parameters: parameters, extraData: Data(), transactionOptions: transactionOptions)?.call(transactionOptions: nil), let symbol = symbolInfo?["0"] as? String else {
            throw WalletError.networkFailure
        }
        
        if symbol.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            throw WalletError.unexpectedResult
        }
        
        return symbol
    }
    
    
    public func symbolForToken(address: String, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let symbol = try? self.symbolForTokenSync(address: address)
            DispatchQueue.main.async {
                completion(symbol)
            }
        }
    }
    
    private func erc20contract(address: String) throws -> web3.web3contract {
        let contractEthreumAddress = EthereumAddress(address)
        guard let contract = web3Instance.contract(Web3.Utils.erc20ABI, at: contractEthreumAddress) else { throw WalletError.contractFailure }
        
        return contract
    }
}
