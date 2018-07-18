![EtherWalletKit: an Ethereum Wallet Toolkit for iOS](https://i.imgur.com/Qyva4AF.png)
[![Swift](https://img.shields.io/badge/Swift-4.1-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-9.4-blue.svg)](https://developer.apple.com/xcode)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Introduction

EtherWalletKit is an Ethereum Wallet Toolkit for iOS.<br><br>
I hope cryptocurrency and decentralized token economy become more widely adapted.
However, some developers hesitate to add a crypto wallet on apps since blockchian and cryptocurrency are complex and require many new knowledge. <br><br>
Don't worry. <br>With EtherWalletKit, you can implement Ethereum wallet without a server and blockchain knowledge.

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate EtherWalletKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'EtherWalletKit'
end
```

Then, run the following command:

```bash
$ pod install
```


## Quick Start

#### 0. Don't forget to import it

``` swift

import EtherWalletKit

```

#### 1. Create an Ethereum Wallet

```swift
// Generate a new account with its new password.
EtherWallet.account.generateAccount(password: "ABCDEFG")

// Import an existing account from its private key and set its new password.
EtherWallet.account.importAccount(privateKey: "1ab71820a87018205a0b9172530ae3910db8a0f0a9f0d92238, password: "ABCDEFG")
```

Note: ```Password``` will be automatically saved to the device and it is required to access the wallet.

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
// send Ether to an address. The password should be eqaul to the password of wallet created.
EtherWallet.transaction.sendEther(to: "0x7777787C97a35d37Db8E5afb0C92BCfd4F6480bE", amount: "1.5", password: "ABCDEFG") { txHash in
    print(txHash)
}

// send Ether to an address.
EtherWallet.transaction.sendToken(to: "0x7777787C97a35d37Db8E5afb0C92BCfd4F6480bE", contractAddress: "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07", amount: "20", password: "ABCDEFG", decimal: 18) { txHash in
    print(txHash)
}
```

Note: ```password``` should be eqaul to the password of wallet created. Also you can put ```gasPrice``` as an extra parameter to set gas price for the transcation.

## Contribution

* Make sure you have a [GitHub account](https://github.com/signup/free)
* Create a GitHub pull request for your contribution
  * Clearly describe the issue or feature.
* Fork the repository on GitHub
* Create a topic branch from where you want to base your work. ([Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) is welcome)
  * Please avoid working directly on the `master` branch.
* Make sure you have added the necessary tests for your changes and make sure all tests pass.


## Donation

Only aceept cryptocurrency :joy: <br>

**ETH**: *0x7777787C97a35d37Db8E5afb0C92BCfd4F6480bE*


## License

EtherWalletKit is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
