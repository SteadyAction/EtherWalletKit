import web3swift
import BigInt

extension EtherWallet {
    public func sendEtherSync(to address: String, amount: String, password: String, gasPrice: String? = nil) throws -> String {
        guard let toAddress = EthereumAddress(address) else { throw WalletError.invalidAddress }
        let keystore = try loadKeystore()
        
        let etherBalance = try etherBalanceSync()
        guard let etherBalanceInDouble = Double(etherBalance) else { throw WalletError.conversionFailure }
        guard let amountInDouble = Double(amount) else { throw WalletError.conversionFailure }
        guard etherBalanceInDouble >= amountInDouble else { throw WalletError.notEnoughBalance }
        
        let keystoreManager = KeystoreManager([keystore])
        web3Main.addKeystoreManager(keystoreManager)
        
        if let gasPrice = gasPrice {
            options.gasPrice = BigUInt(gasPrice)
        }
        options.value = Web3.Utils.parseToBigUInt(amount, units: .eth)
        
        let intermediateSend = web3Main.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!.method(options: options)!
        let sendResult = intermediateSend.send(password: password)
        switch sendResult {
        case .success(let result):
            guard let txhash = result["txhash"] else { throw WalletError.networkFailure }
            return txhash
        case .failure(_):
            throw WalletError.networkFailure
        }
    }
    
    public func sendEther(to address: String, amount: String, password: String, gasPrice: String? = nil, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let txHash = try? self.sendEtherSync(to: address, amount: amount, password: password, gasPrice: gasPrice)
            DispatchQueue.main.async {
                completion(txHash)
            }
        }
    }
    
    public func sendTokenSync(to toAddress: String, contractAddress: String, amount: String, password: String, decimal: Int, gasPrice: String? = nil) throws -> String {
        guard let tokenAddress = EthereumAddress(contractAddress) else { throw WalletError.invalidAddress }
        guard let fromAddress = address else { throw WalletError.accountDoesNotExist }
        guard let fromEthereumAddress = EthereumAddress(fromAddress) else { throw WalletError.invalidAddress }
        guard let toEthereumAddress = EthereumAddress(toAddress) else { throw WalletError.invalidAddress }
        
        let keystore = try loadKeystore()
        let keystoreManager = KeystoreManager([keystore])
        web3Main.addKeystoreManager(keystoreManager)
        
        var options = Web3Options.defaultOptions()
        options.from = fromEthereumAddress
        
        if let gasPrice = gasPrice {
            options.gasPrice = BigUInt(gasPrice)
        }
        options.gasLimit = BigUInt(defaultGasLimitForTokenTransfer)
        
        guard let tokenAmount = Web3.Utils.parseToBigUInt(amount, decimals: decimal) else { throw WalletError.conversionFailure }
        let parameters = [toEthereumAddress, tokenAmount] as [AnyObject]
        guard let contract = web3Main.contract(Web3.Utils.erc20ABI, at: tokenAddress, abiVersion: 2) else { throw WalletError.contractFailure }
        guard let contractMethod = contract.method("transfer", parameters: parameters, options: options) else { throw WalletError.contractFailure }
        
        let contractCall =  contractMethod.send(password: password, onBlock: "latest")
        switch contractCall {
        case .success(let result):
            guard let txhash = result["txhash"] else { throw WalletError.networkFailure }
            return txhash
        case .failure(_):
            throw WalletError.networkFailure
        }
    }
    
    public func sendToken(to toAddress: String, contractAddress: String, amount: String, password: String, decimal:Int, gasPrice: String? = nil, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let txHash = try? self.sendTokenSync(to: toAddress, contractAddress: contractAddress, amount: amount, password: password, decimal: decimal, gasPrice: gasPrice)
            DispatchQueue.main.async {
                completion(txHash)
            }
        }
    }
}
