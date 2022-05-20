//
//  CreateWalletViewController.swift
//  Wallet
//
//  Created by Yan Hua on 13/5/2022.
//

import Foundation
import UIKit

class CreateNewWalletViewController: UIViewController {
    var wallets:[Wallet] = []
    var newWallet:Wallet = Wallet()
//    var KEY_LOCAL_WALLETS = "wallet"
    
    let loader = WalletLoader()//wallet loader

    
   
    //
    @IBOutlet weak var wordLabel1: UILabel!
    @IBOutlet weak var wordLabel2: UILabel!
    @IBOutlet weak var wordLabel3: UILabel!
    @IBOutlet weak var wordLabel4: UILabel!
    //
    @IBOutlet weak var wordLabel5: UILabel!
    @IBOutlet weak var wordLabel6: UILabel!
    @IBOutlet weak var wordLabel7: UILabel!
    @IBOutlet weak var wordLabel8: UILabel!
    //
    @IBOutlet weak var wordLabel9: UILabel!
    @IBOutlet weak var wordLabel10: UILabel!
    @IBOutlet weak var wordLabel11: UILabel!
    @IBOutlet weak var wordLabel12: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Create New Wallet View Loaded Successfully...")
        
        //load wallets from user default
        self.wallets = loader.loadWallet()
        
//        let savedWallets = self.readWalletsFromLocal()
//        if savedWallets.count != 0 {
//            wallets=savedWallets
//        }
        
        //do something
        var trailSeedPhrase = generateSeedPhrase()
        while seedPhraseExisted(trailSeedPhrase: trailSeedPhrase){
            trailSeedPhrase = generateSeedPhrase()
        }
        newWallet.seedPhrase = trailSeedPhrase
        print("Valid New Seed Phrase Has Been Generated...")
        displaySeedPhrase(seedPhrase: newWallet.seedPhrase)
    }

    //generate random seedphrase from wordpool
    func generateSeedPhrase()->[String]{
        //randomly generate 12 words as a new seed phrase
        var newSeedPhrase:[String]=[]
        for _ in 1...12{
            let randomGeneratedWordIndex = Int.random(in: 1...SeedPhraseWordPool.englishWordPool.count)
            newSeedPhrase += [SeedPhraseWordPool.englishWordPool[randomGeneratedWordIndex]]
            //func to avoid duplicate seedPhrase in user default
        }
        //
        print(newSeedPhrase)
        //
        return newSeedPhrase
    }
    
    //check seed phrase existence
    func seedPhraseExisted(trailSeedPhrase:[String]) -> Bool{
        print("Verifying Seed Phrase Existence...")
        for validWallet in wallets {
            if trailSeedPhrase == validWallet.seedPhrase {
                print("Trail Seed Phrase Existed...Regenerating New Seed Phrase...")
                return true
            }
        }
        return false
    }
    
    //show seed phrase on screen
    func displaySeedPhrase(seedPhrase:[String]){
        let labelLists:[UILabel] = [wordLabel1,wordLabel2,wordLabel3,wordLabel4,wordLabel5,wordLabel6,wordLabel7,wordLabel8,wordLabel9,wordLabel10,wordLabel11,wordLabel12]
        for index in 0...11{
         labelLists[index].text=newWallet.seedPhrase[index]
         }
        
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        if segue.identifier=="goToVerify"{
//            wallets+=[newWallet]
//            writeWalletsToLocal(newWallets:wallets)
            let toView = segue.destination as! RecoveryPhraseViewController
            toView.verifiedWallet = self.newWallet
        }
    }
    
}

