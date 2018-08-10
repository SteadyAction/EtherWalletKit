import web3swift

public class EtherWalletRinkeby: EtherWallet {
    private let web3Rinkeby = Web3.InfuraRinkebyWeb3()
    
    override var web3Instance: web3 {
        return web3Rinkeby
    }
}

public class EtherWalletRopsten: EtherWallet {
    private let web3Ropsten = Web3.InfuraRopstenWeb3()
    
    override var web3Instance: web3 {
        return web3Ropsten
    }
}
