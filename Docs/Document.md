## Getting Started

#### 0. Don't forget to import it

``` swift

import EtherWalletKit

```

#### Mainet or Testnet(Rinkeby)
If you want to work on the testnet(Rinkeby), use `EtherWalletRinkeby` instead of `EtherWallet`.

#### Create an Ethereum Wallet

```swift
// Generate a new account with its new password.
try? EtherWallet.account.generateAccount(password: "ABCDEFG")

// Import an existing account from its private key and set its new password.
try? EtherWallet.account.importAccount(privateKey: "1dcbc1d6e0a4587a3a9095984cf051a1bc6ed975f15380a0ac97f01c0c045062, password: "ABCDEFG")
```

Note: ```password``` will be encrypted and saved to the device and it will be required to access the wallet.

#### Get account information
```swift
// Get address of your account
let address = EtherWallet.account.address

// Get private key of your account
let privateKey = try! EtherWallet.account.privateKey(password: "ABCDEFG")
```

#### Get balance

```swift
// Get balance of Ether
EtherWallet.balance.etherBalance { balance in
    print(balance)
}

// Get balance of a token
EtherWallet.balance.tokenBalance(contractAddress: "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07") { balance in
    print(balance)
}
```

#### Send

```swift
// send Ether to an address.
EtherWallet.transaction.sendEther(to: "0x7777787C97a35d37Db8E5afb0C92BCfd4F6480bE", amount: "1.5", password: "ABCDEFG") { txHash in
    print(txHash)
}

// send a token to an address.
EtherWallet.transaction.sendToken(to: "0x7777787C97a35d37Db8E5afb0C92BCfd4F6480bE", contractAddress: "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07", amount: "20", password: "ABCDEFG", decimal: 18) { txHash in
    print(txHash)
}
```

Note: ```password``` should be eqaul to the password of wallet created. Also you can put ```gasPrice``` as an extra parameter to set gas price for the transcation.
