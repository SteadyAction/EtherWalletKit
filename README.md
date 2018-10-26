
<p align="center">
<a href="https://github.com/SteadyAction/EtherWalletKit">
<img src="https://i.imgur.com/Qyva4AF.png" height="240" alt="EtherWalletKit">
</a>

[![Swift](https://img.shields.io/badge/Swift-4.1-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-9.4-blue.svg)](https://developer.apple.com/xcode)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<img src="https://img.shields.io/badge/os-iOS-green.svg?style=flat" alt="iOS">

## Introduction

EtherWalletKit is an Ethereum Wallet Toolkit for iOS.<br><br>
I hope cryptocurrency and decentralized token economy become more widely adapted.
However, some developers hesitate to add a crypto wallet on apps since blockchian and cryptocurrency are complex and require many new knowledge. <br><br>
Don't worry. <br>With EtherWalletKit, you can implement an Ethereum wallet without a server and blockchain knowledge.

## Features
#### Released Features
* Creating/Importing an account(address and private key)
* Checking Ether and tokens balance
* Sending Ether and tokens to other addresses
* Browsing token information
* Testnet(Rinkeby & Ropsten) support
#### Planned Features
* Browsing transaction history 
* Keystore / BIP39 Mnemonics
* Custom configuration / advanced transactions
* Multiple accounts
* Third party APIs
* ERC-721 supports

## Installation

### CocoaPods

<p>To integrate EtherWalletKit into your Xcode project using <a href="http://cocoapods.org">CocoaPods</a>, specify it in your <code>Podfile</code>:</p>

<pre><code class="ruby language-ruby">pod 'EtherWalletKit'</code></pre>

## Quick Start

#### 0. Don't forget to import it

``` swift

import EtherWalletKit

```

#### 1. Create an Ethereum Wallet

```swift
// Generate a new account with its new password.
try? EtherWallet.account.generateAccount(password: "ABCDEFG")

// Import an existing account from its private key and set its new password.
try? EtherWallet.account.importAccount(privateKey: "1dcbc1d6e0a4587a3a9095984cf051a1bc6ed975f15380a0ac97f01c0c045062, password: "ABCDEFG")
```

Note: ```password``` will be encrypted and saved to the device and it will be required to access the wallet.

#### 2. Get balance

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

#### 3. Send

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

For full documentation, please see [THIS](./Docs/Document.md).

## Notes

* Nothing will be sent to a server. Everything will be worked on the local device and Ethereum Blockchain.
* You dont need to download and sync the nodes because [Infura](https://infura.io/) is doing it for you.
* ```password``` for wallet is equal to the password for the keystore file. Always make sure a ```password``` is long enough for security.


## Contribution

* Make sure you have a [GitHub account](https://github.com/signup/free)
* Create a GitHub pull request for your contribution
  * Clearly describe the issue or feature.
* Fork the repository on GitHub
* Create a topic branch from where you want to base your work. ([Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) is welcome)
  * Please avoid working directly on the `master` branch.
* Make sure you have added the necessary tests for your changes and make sure all tests pass.


## Donation

Only accept cryptocurrency :joy: <br>

**ETH**: *0x7777787C97a35d37Db8E5afb0C92BCfd4F6480bE* <br>
**XLM**: GBWP4JXW4PJGORNTVN3ZIFRZN5NXDNU534G5KULGPUGJE7IHCQILUQ3B


## License

EtherWalletKit is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
