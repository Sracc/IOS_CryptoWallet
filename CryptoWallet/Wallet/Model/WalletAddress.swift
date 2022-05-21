//
//  WalletAddress.swift
//  Wallet
//
//  Created by Kin Kwan Chang on 5/5/22.
//

import Foundation

struct Wallet: Codable, Equatable {
    var address: String
    var ethBalance: Double
    var usdcBalance: Double
    var apeBalance: Double
    
    var walletName: String
    var privateKey: String
    var seedPhrase: [String]
    
    enum  CodingKeys : String, CodingKey
    {
        case address, ethBalance, usdcBalance, apeBalance, walletName, privateKey, seedPhrase
    }
    
    init(){
        ethBalance = 0
        usdcBalance = 0
        apeBalance = 0
        address = ""
        
        walletName = ""
        privateKey = ""
        seedPhrase = []
    }
    
    //init with address
    init(address:String){
        ethBalance = 0
        usdcBalance = 0
        apeBalance = 0
        self.address = address
        
        walletName = ""
        privateKey = ""
        seedPhrase = []
    }
    
    //init with balance
    init(address:String,ethBalance:Double,usdcBalance:Double,wethBalance:Double){
        self.ethBalance = ethBalance
        self.usdcBalance = usdcBalance
        self.apeBalance = wethBalance
        self.address = address
        
        walletName = ""
        privateKey = ""
        seedPhrase = []
    }
    
    //init from seedphrase
    init(seedPhrase: [String]) {
        self.seedPhrase = seedPhrase
        address = ""
        walletName = ""
        privateKey = ""
        
        ethBalance = 0
        usdcBalance = 0
        apeBalance = 0
    }
    
    
    
    //decode
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        address = try values.decode(String.self, forKey: .address)
        ethBalance = try values.decode(Double.self, forKey: .ethBalance)
        usdcBalance = try values.decode(Double.self, forKey: .usdcBalance)
        apeBalance = try values.decode(Double.self, forKey: .apeBalance)
        
        walletName = try values.decode(String.self, forKey: .walletName)
        privateKey = try values.decode(String.self, forKey: .privateKey)
        seedPhrase = try values.decode([String].self, forKey: .seedPhrase)
    }
    
    //encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(ethBalance, forKey: .ethBalance)
        try container.encode(usdcBalance, forKey: .usdcBalance)
        try container.encode(apeBalance, forKey: .apeBalance)
        
        try container.encode(walletName, forKey: .walletName)
        try container.encode(privateKey, forKey: .privateKey)
        try container.encode(seedPhrase, forKey: .seedPhrase)
    }
    
}
