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
    
    //generate random seedphrase from wordpool
    func generateSeedPhrase()->[String]{
        //randomly generate 12 words as a new seed phrase
        var newSeedPhrase:[String]=[]
        for _ in 1...12{
            var randomGeneratedWordIndex = Int.random(in: 0...SeedPhraseWordPool.englishWordPool.count-1)
            while newSeedPhrase.contains(SeedPhraseWordPool.englishWordPool[randomGeneratedWordIndex]){
                randomGeneratedWordIndex = Int.random(in: 0...SeedPhraseWordPool.englishWordPool.count-1)
                print("Duplicate word generated, regenerating..")
            }
            newSeedPhrase += [SeedPhraseWordPool.englishWordPool[randomGeneratedWordIndex]]
        }
        return newSeedPhrase
    }
    
    //check seed phrase exist
    func seedPhraseExisted(trailSeedPhrase:[String]) -> Bool{
        print("Verifying Seed Phrase Existence...")
        let wallets = loader.loadWallet()
        for validWallet in wallets {
            if trailSeedPhrase == validWallet.seedPhrase {
                print("Trail Seed Phrase Existed...Regenerating New Seed Phrase...")
                return true
            }
        }
        return false
    }
    
    //generate seed phrase if not exist
    func newSeedPhrase() -> [String] {
        //generate seed phrase from wordpool
        var trailSeedPhrase = generateSeedPhrase()
        // regenerate a seed phrase if exist
        while seedPhraseExisted(trailSeedPhrase: trailSeedPhrase){
            trailSeedPhrase = generateSeedPhrase()
        }
        return trailSeedPhrase
    }
    
    
}
