import web3swift
import BigInt

extension EtherWallet {
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
