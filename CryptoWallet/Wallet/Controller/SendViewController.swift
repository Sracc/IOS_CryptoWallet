//
//  SendViewController.swift
//  Wallet
//
//  Created by Kin Kwan Chang on 15/5/22.
//

import UIKit

class SendViewController: UIViewController {

    // Default value before received from AccountViewController
    var walletAddress:String = ""
    var currencyType = ""
    var eBalance:Double = 0
    var uBalance:Double = 0
    var aBalance:Double = 0
    var tokenBalance:Double = 0
    var wallet = Wallet()
    var wallets: [Wallet] = []
    var loader = WalletLoader()
    
    @IBOutlet weak var fromWallet: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var toWallet: UITextField!
    @IBOutlet weak var ethBalance: UILabel!
    @IBOutlet weak var usdcBalance: UILabel!
    @IBOutlet weak var apeBalance: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load decoded wallet data
        wallets = loader.loadWallet()
        wallet = loader.getWallet(walletAddress: walletAddress)
        eBalance = wallet.ethBalance
        uBalance = wallet.usdcBalance
        aBalance = wallet.apeBalance
        
        // Display information
        fromWallet.text = "\(walletAddress)"
        ethBalance.text = "\(eBalance)"
        usdcBalance.text = "\(uBalance)"
        apeBalance.text = "\(aBalance)"
    }
    
    // Check receiver wallet address
    func checkToWallet (){
        // if wallet address is empty
        if toWallet.text  == ""{
            // Display alert message
            createAlert(title: "ERROR", message: "Unable to send to this wallet")
        }
        // check wallet address existence
        if loader.checkAddress(walletAddress: toWallet.text!) != true {
            // Display alert message
            createAlert(title: "ERROR", message: "Wallet does not exist")
        }
        //Check self wallet
        if toWallet.text == walletAddress {
            createAlert(title: "ERROR", message: "Can't send to self wallet")
        }
    }
    
    // Check token balance
    func checkBalance (balance:Double, sendAmount:String){
        // if the send amount is double
        if let sendAmount = Double(amount.text!){
            // Then, check whether the send amount is greater than current balance or not
            if sendAmount > balance {
                // if the send amount is greater than current balance
                createAlert(title:"ERROR", message: "Insufficient balance")
            }
            // Calculate the token balance after send
            tokenBalance = balance - sendAmount
        }
        // if the send amount is not double
        else{
            // Display alert message
            createAlert(title: "ERROR", message: "Please use valid amount")
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
    
    // Click "Send"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send ETH
        if segue.identifier == "sendETH"{
            let toView = segue.destination as! TransactionViewController
            // Check receiver wallet address
            checkToWallet()
            // Check token balance and input amount
            checkBalance(balance: eBalance, sendAmount: amount.text!)
            // Pass data to TransactionViewController
            toView.fromWalletAddress = walletAddress
            toView.balance = tokenBalance
            toView.amountSent = amount.text!
            toView.toWalletAddress = toWallet.text!
            toView.tokenSent = "ETH"
            toView.ethBalance = eBalance
            toView.usdcBalance = uBalance
            toView.apeBalance = aBalance
            //Hide back button
            toView.navigationItem.setHidesBackButton(true, animated: true)
        }
        // Send USDC
        else if segue.identifier == "sendUSDC"{
            let toView = segue.destination as! TransactionViewController
            // Check receiver wallet address
            checkToWallet()
            // Check token balance and input amount
            checkBalance(balance: uBalance, sendAmount: amount.text!)
            // Pass data to TransactionViewController
            toView.fromWalletAddress = walletAddress
            toView.balance = tokenBalance
            toView.amountSent = amount.text!
            toView.toWalletAddress = toWallet.text!
            toView.tokenSent = "USDC"
            toView.ethBalance = eBalance
            toView.usdcBalance = uBalance
            toView.apeBalance = aBalance
            //Hide back button
            toView.navigationItem.setHidesBackButton(true, animated: true)
            
        }
        // Send APE
        else if segue.identifier == "sendAPE"{
            let toView = segue.destination as! TransactionViewController
            // Check receiver wallet address
            checkToWallet()
            // Check token balance and input amount
            checkBalance(balance: aBalance, sendAmount: amount.text!)
            // Pass data to TransactionViewController
            toView.fromWalletAddress = walletAddress
            toView.balance = tokenBalance
            toView.amountSent = amount.text!
            toView.toWalletAddress = toWallet.text!
            toView.tokenSent = "APE"
            toView.ethBalance = eBalance
            toView.usdcBalance = uBalance
            toView.apeBalance = aBalance
            //hide back button
            toView.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
