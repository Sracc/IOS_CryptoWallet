//
//  WalletListViewController.swift
//  Wallet
//
//  Created by Kaitao Tan on 15/5/2022.
//

import UIKit

class WalletListViewController: UIViewController {
    var wallet = Wallet()
    var wallets: [Wallet] = []
    var loader = WalletLoader()
    var addressArray = [Any]()
    var balanceArray = [Any]()
    
    @IBOutlet weak var walletList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load decoded wallet data
        wallets = loader.loadWallet()
        addressArray = loader.getAddressList(walletList: wallets)
        balanceArray = loader.getBalanceList(walletList: wallets)
    }
}

// Display information in table view
extension WalletListViewController: UITableViewDataSource, UITableViewDelegate {
    // Number of rows equal to the number of entry in the dictionary
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return balanceArray.count
    }
    // what cell shoud display in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath) as! WalletTableViewCell
        cell.walletAddress.text = addressArray[indexPath.row] as? String
        cell.balance.text = balanceArray[indexPath.row] as? String
        return cell
    }
    
    //select wallet to switch
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(walletList, cellForRowAt: indexPath) as! WalletTableViewCell
        let selectedWallet = cell.walletAddress.text!
        UIPasteboard.general.string = selectedWallet
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController {
            VC.address = selectedWallet
            self.navigationController?.pushViewController(VC, animated: true)
            VC.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
                                                

}
