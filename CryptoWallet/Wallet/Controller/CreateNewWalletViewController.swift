//
//  CreateWalletViewController.swift
//  Wallet
//
//  Created by Yan Hua on 13/5/2022.
//

import Foundation
import UIKit

class CreateNewWalletViewController: UIViewController {
    var newWallet:Wallet = Wallet()
    
    let loader = WalletLoader()//wallet loader
    let generator = WalletGenerator()//wallet generator

    
   
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
        
        
        //do something
        
        //generate new wallet from seed phrase
        newWallet.seedPhrase = generator.newSeedPhrase()
        print(newWallet.seedPhrase)
        print("Valid New Seed Phrase Has Been Generated...")
        displaySeedPhrase(seedPhrase: newWallet.seedPhrase)
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
            let toView = segue.destination as! RecoveryPhraseViewController
            toView.verifiedWallet = self.newWallet
        }
    }
    
}

