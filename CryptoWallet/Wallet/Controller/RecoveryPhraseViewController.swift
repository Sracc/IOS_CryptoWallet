//
//  RecoveryPhraseViewController.swift
//  Wallet
//
//  Created by Yan Hua on 13/5/2022.
//

import Foundation
import UIKit

class RecoveryPhraseViewController: UIViewController {
    var wallets:[Wallet] = []
    var KEY_LOCAL_WALLETS = "wallet"
    var recoveryPhraseInput:[String] = []
    var verifiedWallet:Wallet = Wallet()
    
    let loader = WalletLoader()
    let generator = WalletGenerator()
    
    @IBOutlet weak var wordInput1: UITextField!
    @IBOutlet weak var wordInput2: UITextField!
    @IBOutlet weak var wordInput3: UITextField!
    @IBOutlet weak var wordInput4: UITextField!
    //
    @IBOutlet weak var wordInput5: UITextField!
    @IBOutlet weak var wordInput6: UITextField!
    @IBOutlet weak var wordInput7: UITextField!
    @IBOutlet weak var wordInput8: UITextField!
    //
    @IBOutlet weak var wordInput9: UITextField!
    @IBOutlet weak var wordInput10: UITextField!
    @IBOutlet weak var wordInput11: UITextField!
    @IBOutlet weak var wordInput12: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login View Loaded Successfully...")
        
    }
    
    //get the seed phrase input
    func getRecoveryPhraseInput() -> [String]{
        //get input from textfield 1 to 12
        var inputSeedPhrase:[String] = []
        let inputTextfieldLists:[UITextField] = [wordInput1, wordInput2, wordInput3, wordInput4, wordInput5, wordInput6, wordInput7, wordInput8, wordInput9, wordInput10, wordInput11, wordInput12]
        for index in 0...11{
            inputSeedPhrase += [inputTextfieldLists[index].text!]
        }
        print(inputSeedPhrase)
        return inputSeedPhrase
    }
    
    func verifyRecoveryPhrase(recoveryPhraseInput:[String])->Bool{
        print("Verifying Seed Phrase Input...")
        if recoveryPhraseInput == verifiedWallet.seedPhrase {
            return true
        }
        return false
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        if segue.identifier=="showAccount"{
            wallets = loader.loadWallet()
            verifiedWallet.privateKey = generator.generatePrivateKey()
            verifiedWallet.address = generator.generatePublicAddress()
            //save wallet to user defaults
            loader.saveWallet(wallet: verifiedWallet, savedWallets: wallets)
            
            let toView = segue.destination as! AccountViewController
            toView.wallet = verifiedWallet
            toView.address = verifiedWallet.address
            toView.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    //error msg for seed phrase input validation
    override func shouldPerformSegue(withIdentifier showAccount: String, sender: Any?) -> Bool {
        recoveryPhraseInput = getRecoveryPhraseInput()
        if verifyRecoveryPhrase(recoveryPhraseInput:recoveryPhraseInput){
            return true
        }
        else {
            let alert = UIAlertController(title:"Incorrect Recovery Phase Alert!",message:"Please check your input...",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Try Again",style:.default,handler:{(action) in alert.dismiss(animated:true,completion:nil)}))
            present(alert,animated:true,completion:nil)
            return false
        }
    }
    
}

