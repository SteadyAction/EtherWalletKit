struct EtherscanTxAPIResponse: Decodable {
    let message: String
    let status: String
    let result: [GeneralTransactionData]
}

struct EtherscanTokenTxAPIResponse: Decodable {
    let message: String
    let status: String
    let result: [TokenTransactionData]
}
