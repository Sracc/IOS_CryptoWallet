//
//  WalletGenerator.swift
//  Wallet
//
//  Created by Yan Hua on 14/5/2022.
//

import Foundation

public class WalletGenerator {
    let loader = WalletLoader()
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func generatePrivateKey() -> String {
        var privatekey: String = randomString(length: 48)
        while privatekeyExist(privatekey: privatekey) {
            privatekey = randomString(length: 48)
            }
        return privatekey
        }

    
    func generatePublicAddress() -> String {
        var publicAddress:String = "0x"+randomString(length: 40)
        while loader.checkAddress(walletAddress: publicAddress) {
            publicAddress = "0x"+randomString(length: 40)
        }
        return publicAddress
    }
    
    func privatekeyExist(privatekey: String) -> Bool {
        let wallets = loader.loadWallet()
        for wallet in wallets {
            if privatekey == wallet.privateKey {
                return true
            }
        }
        return false
    }
    
    
    
    
}
