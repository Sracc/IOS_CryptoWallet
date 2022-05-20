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

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var walletName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.wallets = loader.loadWallet()
    }
    
    // Check wallet address
    func checkWalletInput (){
        // if wallet address is empty
        if addressTextField.text  == ""{
            // Display alert message
            createAlert(title: "ERROR", message: "Please input a wallet address")
        }
        // Check wallet existence
        if loader.checkAddress(walletAddress: addressTextField.text!) == true {
            // Display alert message
            createAlert(title: "ERROR", message: "Wallet already exists")
        }
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
            checkWalletInput()
            self.wallet = Wallet(address: addressTextField.text!)
            self.wallet.walletName = walletName.text!
            loader.saveWallet(wallet: wallet, savedWallets: wallets)
            
            let VC = segue.destination as! AccountViewController
            VC.address = addressTextField.text!
            VC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }


}

