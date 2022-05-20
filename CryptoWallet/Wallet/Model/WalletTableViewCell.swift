//
//  WalletTableViewCell.swift
//  Wallet
//
//  Created by Kaitao Tan on 15/5/2022.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var walletAddress: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
