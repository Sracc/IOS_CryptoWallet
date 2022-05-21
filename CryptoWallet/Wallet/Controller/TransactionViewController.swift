//
//  TransactionViewController.swift
//  Wallet
//
//  Created by Kin Kwan Chang on 15/5/22.
//

import UIKit

class TransactionViewController: UIViewController {

    // Default value before received from SendViewController
    var fromWalletAddress:String = ""
    var balance:Double = 0
    var toWalletAddress:String = ""
    var amountSent: String = ""
    var tokenSent: String = ""
    var ethBalance: Double = 0
    var usdcBalance: Double = 0
    var apeBalance: Double = 0
    var tethBalance: Double = 0
    var tusdcBalance: Double = 0
    var tapeBalance: Double = 0
    var wallet = Wallet() //sender wallet
    var tWallet = Wallet() //toWallet
    var wallets: [Wallet] = []
    var loader = WalletLoader()

    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var token: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var tokenBalance: UILabel!
    @IBOutlet weak var to: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load sender wallet
        wallet = loader.getWallet(walletAddress: fromWalletAddress)
        wallets = loader.loadWallet()
        
        //load toWallet
        tWallet = loader.getWallet(walletAddress: toWalletAddress)
        
        //load toWallet balance
        tethBalance = tWallet.ethBalance
        tusdcBalance = tWallet.usdcBalance
        tapeBalance = tWallet.apeBalance
        
        // Display information
        from.text = "\(fromWalletAddress)"
        token.text = "\(tokenSent)"
        amount.text = "\(amountSent)"
        tokenBalance.text = "\(balance)"
        to.text = "\(toWalletAddress)"
    }
    @IBAction func completeSend(_ sender: UIButton) {
        switch tokenSent{
        case "ETH":
            //update fromWallet ETH balance
            wallet.ethBalance = ethBalance - Double(amountSent)!
            loader.updateBalance(wallet: wallet)
            //update toWallet ETH balance
            tWallet.ethBalance = tethBalance + Double(amountSent)!
            loader.updateBalance(wallet: tWallet)
            
        case "USDC":
            //update fromWallet USDC
            wallet.usdcBalance = usdcBalance - Double(amountSent)!
            loader.updateBalance(wallet: wallet)
            
            //update toWallet USDC
            tWallet.usdcBalance = tusdcBalance + Double(amountSent)!
            loader.updateBalance(wallet: tWallet)
            
        case "APE":
            //update fromWallet APE
            wallet.apeBalance = apeBalance - Double(amountSent)!
            loader.updateBalance(wallet: wallet)
            
            //update toWallet APE
            tWallet.apeBalance = tapeBalance + Double(amountSent)!
            loader.updateBalance(wallet: tWallet)
            
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
            if segue.identifier == "completeSend"{
            let toView = segue.destination as! AccountViewController
            toView.address = fromWalletAddress
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
