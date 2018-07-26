import XCTest
@testable import EtherWalletKit

class EtherWalletKitTest: XCTestCase {
    private let password = "PASSWORD123"
    
    func testAccount() {
        guard let _  = try? EtherWallet.account.generateAccount(password: password) else {
            XCTFail()
            return
        }
        
        XCTAssert(EtherWallet.account.hasAccount)
        
        guard let address = EtherWallet.account.address else {
            XCTFail()
            return
        }
        XCTAssert(address.count == 42)
        
        guard let privateKey = try? EtherWallet.account.privateKey(password: password) else {
            XCTFail()
            return
        }
        XCTAssert(privateKey.count == 64)
        
        guard let _ = try? EtherWallet.account.importAccount(privateKey: privateKey, password: password) else {
            XCTFail()
            return
        }
        
        XCTAssert(address == EtherWallet.account.address)
        
        XCTAssert(EtherWallet.account.verifyPassword(password))
        XCTAssertFalse(EtherWallet.account.verifyPassword("WRONG_PASSWORD"))
    }
}
