import web3swift

extension EtherWallet {
    public func sendEtherSync(to address: String, amount: String, password: String, transactionFee: String? = nil) throws -> String {
        return ""
    }
    
    public func sendEther(to address: String, amount: String, password: String, transactionFee: String? = nil, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let txHash = try? self.sendEtherSync(to: address, amount: amount, password: password, transactionFee: transactionFee)
            DispatchQueue.main.async {
                completion(txHash)
            }
        }
    }
    
    public func sendTokenSync(to address: String, contractAddress: String, amount: String, password: String, decimal: Int, with transactionFee: String? = nil) throws -> String {
        return ""
    }
    
    public func sendToken(to toAddress: String, contractAddress: String, amount: String, password: String, decimal:Int, with transactionFee: String? = nil, completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            let txHash = try? self.sendTokenSync(to: toAddress, contractAddress: contractAddress, amount: amount, password: password, decimal: decimal, with: transactionFee)
            DispatchQueue.main.async {
                completion(txHash)
            }
        }
    }
}
