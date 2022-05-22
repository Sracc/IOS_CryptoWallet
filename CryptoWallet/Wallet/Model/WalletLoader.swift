//
//  WalletLoader.swift
//  Wallet
//
//  Created by Kaitao Tan on 15/5/2022.
//

import Foundation

class WalletLoader {
    let defaults = UserDefaults.standard
    
    //save wallet
//    func saveWallet(walletAddress: String, savedWallets: [Wallet]) {
//        let wallet = Wallet(address: walletAddress)
//        var wallets: [Wallet] = savedWallets
//        if checkAddress(walletAddress: wallet.address) == false {
//        wallets.append(wallet)
//        defaults.set(try? PropertyListEncoder().encode(wallets), forKey: "wallets")
//        }
//    }
    
    //save wallet
    func saveWallet(wallet: Wallet, savedWallets: [Wallet]) {
        var wallets: [Wallet] = savedWallets
        if checkAddress(walletAddress: wallet.address) == false {
        wallets.append(wallet)
        defaults.set(try? PropertyListEncoder().encode(wallets), forKey: "wallets")
        }
        else
        {
            print("Cannot save Duplicate Address")
        }
    }
    
    //load list of wallets saved
    func loadWallet() -> [Wallet] {
        var wallets: [Wallet] = []
        if let data = defaults.data(forKey: "wallets") {
            if let savedWallets = try? PropertyListDecoder().decode([Wallet].self, from: data) {
                wallets = savedWallets
            }
        }
        return wallets
    }
    
    //check existence of wallet address
    func checkAddress(walletAddress: String) -> Bool {
        let wallets = loadWallet()
        for wallet in wallets {
            if wallet.address == walletAddress {
                print("Address exist")
                return true
            }
        }
        return false
    }
    
    //get wallet from address
    func getWallet(walletAddress: String) -> Wallet {
        let wallets = loadWallet()
        var foundWallet = Wallet()
        for wallet in wallets {
            if walletAddress == wallet.address {
                foundWallet = wallet
            }
        }
        return foundWallet
    }
    
    //return wallet address if matched
    func getAddress(walletAddress: String) -> String {
        var address: String = ""
        if checkAddress(walletAddress: walletAddress) == false {
            address = walletAddress
        }
        return address
    }
    
    //get ETH balance of a wallet
    func getBalanceOfETH(walletAddress: String) -> Double {
        let wallets = loadWallet()
        var ethBal: Double = 0
        for wallet in wallets {
            if wallet.address == walletAddress {
                ethBal = wallet.ethBalance
                break
                }
            }
        return ethBal
    }
    
    
    //get all the wallet address saved
    func getAddressList(walletList: [Wallet]) -> Array<Any> {
        var addressArray = [String]()
        let wallets = loadWallet()
        for wallet in wallets {
            addressArray.append(wallet.address)
            }
        return addressArray
        }
    
    //get the eth balance of all wallets
    func getBalanceList(walletList: [Wallet]) -> Array<Any> {
        var balanceArray = [String]()
        let wallets = loadWallet()
        for wallet in wallets {
            let balance: String = "\(wallet.ethBalance)"
            balanceArray.append(balance)
            }
        return balanceArray
        }
    
    
    //replace  the wallet at index
    func updateBalance(wallet: Wallet) {
        var wallets = loadWallet()
        var index = 0
        for w in wallets {
            if w.address == wallet.address {
                index = wallets.firstIndex(of: w)!
            }
        }
        wallets[index].ethBalance = wallet.ethBalance//update ETH
        wallets[index].usdcBalance = wallet.usdcBalance//Update USDC
        wallets[index].apeBalance = wallet.apeBalance//update WETH

        defaults.set(try? PropertyListEncoder().encode(wallets), forKey: "wallets")
    }
    
    
    //remove wallet
    func deleteWallet(walletAddress: String) {
        defaults.removeObject(forKey: "wallets")
    }
    
    //format currency to 2 decimal
    func currencyFormatter(price: Double, symbol: String) -> String {
        let priceString = String(format: "%.2f", price)
        return symbol+priceString
    }
    
    
    //check existence of private key
    func checkPrivatekey(privatekey: String) -> Bool {
        let wallets = loadWallet()
        for wallet in wallets {
            if wallet.privateKey == privatekey {
                print("Privatekey exist")
                return true
            }
        }
        return false
    }
    
    //get wallet from privatekey
    func getWallet(privatekey: String) -> Wallet {
        let wallets = loadWallet()
        var foundWallet = Wallet()
        for wallet in wallets {
            if privatekey == wallet.privateKey {
                foundWallet = wallet
            }
        }
        return foundWallet
    }
    
    //get wallet from Seed Phrase
    func getWallet(seedPhrase: [String]) -> Wallet {
        let wallets = loadWallet()
        var foundWallet = Wallet()
        for wallet in wallets {
            if seedPhrase == wallet.seedPhrase {
                foundWallet = wallet
            }
        }
        return foundWallet
    }
    



}
