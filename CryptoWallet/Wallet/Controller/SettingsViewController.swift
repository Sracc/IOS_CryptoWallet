//
//  SettingsViewController.swift
//  Wallet
//
//  Created by 徐哲 on 2022/5/19.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let loader = WalletLoader()
    var buttonTitle: String = "USD"
    
    @IBOutlet weak var currencyPullDown: UIButton!
    
    @IBOutlet weak var themePullDown: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPullDown.showsMenuAsPrimaryAction=true
        // Do any additional setup after loading the view.
        self.buttonTitle = defaults.string(forKey: "CurrencyButton") ?? "USD"
        currencyPullDown.setTitle(buttonTitle, for: .normal)
        currencyPullDown.menu = UIMenu(children: [
            UIAction(title: "USD",  handler: { action in
                //                        print("Select Messages")
                self.currencyPullDown.setTitle("USD", for: .normal)
                self.defaults.set(1, forKey: "Currency")
                self.defaults.set("$", forKey: "CurrencySymbol")
                self.defaults.set("USD", forKey: "CurrencyButton")
            }),
            UIAction(title: "CNY", handler: { action in
                self.currencyPullDown.setTitle("CNY", for: .normal)
                self.defaults.set(6.71, forKey: "Currency")
                self.defaults.set("¥", forKey: "CurrencySymbol")
                self.defaults.set("CNY", forKey: "CurrencyButton")
                //                        print("Edit Pins")
            }),
            UIAction(title: "AUD", handler: { action in
                self.currencyPullDown.setTitle("AUD", for: .normal)
                self.defaults.set(1.42, forKey: "Currency")
                self.defaults.set("A$", forKey: "CurrencySymbol")
                self.defaults.set("AUD", forKey: "CurrencyButton")
                //                        print("Edit Name and Photo")
            })
        ])
        
        
        themePullDown.showsMenuAsPrimaryAction=true
        // Do any additional setup after loading the view.
        themePullDown.setTitle("Ethereum Mainnet", for: .normal)
        themePullDown.menu = UIMenu(children: [
            UIAction(title: "Ethereum Mainnet",  handler: { action in
                //                        print("Select Messages")
                self.themePullDown.setTitle("Ethereum Mainnet", for: .normal)
            }),
            UIAction(title: "Flashbots Protect RPC", handler: { action in
                self.themePullDown.setTitle("Flashbots Protect RPC", for: .normal)
                //                        print("Edit Pins")
            })
        ])
        
        
    }
    
    //delete all wallet
    @IBAction func resetData(_ sender: UIButton) {
        let loader = WalletLoader()
        //create alert
        let resetAlert = UIAlertController(title: "Remove Wallets" , message: "Are you sure to remove all wallets?", preferredStyle: UIAlertController.Style.alert)
        
        resetAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action: UIAlertAction!) in
            loader.deleteWallet(walletAddress: "")
            print("Data is deleted")
            //print wallet number in user default
            print(UserDefaults.standard.data(forKey: "wallets")?.count ?? 0)
            //go to home page
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
            vc!.navigationItem.setHidesBackButton(true, animated: true)
        }))
        
        resetAlert.addAction(UIAlertAction(title: "No", style: .default, handler: {(action: UIAlertAction!) in
            resetAlert.dismiss(animated: true, completion: nil)
            //print wallet count in user default
            print(UserDefaults.standard.data(forKey: "wallets")?.count ?? 0)
        }))
        
        present(resetAlert, animated: true, completion: nil)
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

