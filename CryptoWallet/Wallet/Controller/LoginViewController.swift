//
//  ViewController.swift
//  Wallet
//
//  Created by Kin Kwan Chang on 5/5/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    var wallet = Wallet()
    var wallets: [Wallet] = []
    var loader = WalletLoader()
    var address: String = ""
    let generator = WalletGenerator()
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var walletName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.wallets = loader.loadWallet()
    }
    
    // Create alert for display
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // Add action for user dismiss the alert by click "OK"
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion:nil)}))
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAccount" {
            recoverWallet()
            let VC = segue.destination as! AccountViewController
            VC.address = self.address
            VC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    //recover wallet address
    func recoverWallet() {
        //access existing wallet from private key
        if loader.checkPrivatekey(privatekey: addressTextField.text!) == true {
            self.address = loader.getWallet(privatekey: addressTextField.text!).address
            print("Recover from private key, " + self.address)
            
            return
        }
        //access existing wallet
        if loader.checkAddress(walletAddress: addressTextField.text!) == true {
            self.address = addressTextField.text!
            print("Loading existing address: " + self.address)
            
            return
        }
        //recover from seed phrase
        if  checkRecoveryPhrase(seedPhrase: addressTextField.text!) == true {
            let seedString = addressTextField.text!
            let seedArray = seedString.components(separatedBy: " ")
            if generator.seedPhraseExisted(trailSeedPhrase: seedArray) {
                self.address = loader.getWallet(seedPhrase: seedArray).address
                print("Loading existing wallet from recovery phrase, " + self.address)
                
                return
            }
            //new address recover from seed phrase
            else {
                self.wallet = Wallet(seedPhrase: seedArray)
                self.address = wallet.address
                self.wallet.walletName = walletName.text!
                loader.saveWallet(wallet: wallet, savedWallets: wallets)
                print("Recovering wallet..." + self.address)
                
                return
            }
        }
        // if wallet address is empty
        if addressTextField.text  == "" {
            // Display alert message
            createAlert(title: "ERROR", message: "Please input a valid 0x wallet address")
            
            return
        }
        //create new wallet
        else if addressTextField.text!.starts(with: "0x") {
            self.wallet = Wallet(address: addressTextField.text!)
            self.address = wallet.address
            self.wallet.walletName = walletName.text!
            loader.saveWallet(wallet: wallet, savedWallets: wallets)
            print("Creating Wallet: " + self.address)
            
            return
        }
        //invalid input
        else {
            createAlert(title: "ERROR", message: "Invalid Input! Please input 0x address or seed phrase separated by space")
            return
        }
    }
    
    //check if input is recovery phrase
    func checkRecoveryPhrase(seedPhrase: String) -> Bool {
        let seedString = addressTextField.text!
        let seedArray = seedString.components(separatedBy: " ")
        let pool = Set(SeedPhraseWordPool.englishWordPool)
        let subset = Set(seedArray)
        if seedArray.count == 12 && subset.isSubset(of: pool) == true {
            return true
        }
        return false
    }
}

