//
//  AccountViewController.swift
//  Wallet
//
//  Created by Kin Kwan Chang on 5/5/22.
//

import UIKit

class AccountViewController: UIViewController {
    
    var address: String = ""
    //default balance for wallet
    var ethBalance: Double = 0
    var usdcBalance: Double = 0
    var apeBalance: Double = 0
    var wallet = Wallet()
    var wallets: [Wallet] = []
    var loader = WalletLoader()//load wallet toolkits
    var timer: Timer?
    //Token default price
    var ethPrice: Double = 2000
    var usdcPrice: Double = 1
    var apePrice: Double = 8
    
    
    var currency: Double = 1 //default currency coefficient based on USD
    var currencySymbol: String = "$" //default currency symbol
    
    var eth24H: Double = 2000
    var usdc24H: Double = 1
    var ape24H: Double = 8
    
    
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var selectTypePullDown: UIButton!
    @IBOutlet weak var ethPercent: UILabel!
    @IBOutlet weak var usdcPercent: UILabel!
    @IBOutlet weak var apePercent: UILabel!
    @IBOutlet weak var ethBalLabel: UILabel!
    @IBOutlet weak var usdcBalLabel: UILabel!
    @IBOutlet weak var apeBalLabel: UILabel!
    @IBOutlet weak var usdcPriceLabel: UILabel!
    @IBOutlet weak var apePriceLabel: UILabel!
    @IBOutlet weak var ethPriceLabel: UILabel!
    @IBOutlet weak var portfolioValue: UILabel!
    @IBOutlet weak var walletAddressLabel: UILabel!
    // group labels
    var ethLabelList: [UILabel] = []
    var usdcLabelList: [UILabel] = []
    var apeLabelList: [UILabel] = []
    
    //token list
    enum Token: CaseIterable {
        case eth
        case usdc
        case ape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pull down menu to add wallet
        selectTypePullDown.showsMenuAsPrimaryAction = true
        // Do any additional setup after loading the view.
        selectTypePullDown.setTitle("", for: .normal)
        selectTypePullDown.menu = UIMenu(children: [
            UIAction(title: "Create a new wallet",  image: UIImage(systemName: "pencil"),handler: { action in
                self.selectTypePullDown.setTitle("Create a new wallet", for: .normal)
                self.performSegue(withIdentifier: "backToCreate", sender: self);
            }),
            UIAction(title: "Add a existing wallet", image: UIImage(systemName: "book"),handler: { action in
                self.selectTypePullDown.setTitle("Add a existing wallet", for: .normal)
                self.performSegue(withIdentifier: "backToExisting", sender: self);
            }),
            
        ])
        
        // Do any additional setup after loading the view.
        
        //group labels based on token type
        self.ethLabelList = [ethPriceLabel, ethPercent]
        self.usdcLabelList = [usdcPriceLabel, usdcPercent]
        self.apeLabelList = [apePriceLabel, apePercent]
        
        //if is first login, load default wallet
        wallets = loader.loadWallet()
        if address == "" {
            if wallets.count > 0 {
            wallet = wallets[0]
            address = wallet.address
            }
            else {
                print("Wallet not found, out of index")
                loader.deleteWallet(walletAddress: "")

                //Back to home
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                self.navigationController?.pushViewController(vc!, animated: false)
                vc!.navigationItem.setHidesBackButton(true, animated: true)
            }
        }
        
        //load wallet
        wallet = loader.getWallet(walletAddress: address)
        
        
        //load balance
        walletAddressLabel.text = wallet.address
        walletNameLabel.text = wallet.walletName
        updateBalance()
        //load currency
        currency = UserDefaults.standard.double(forKey: "Currency")
        currencySymbol = UserDefaults.standard.string(forKey: "CurrencySymbol") ?? "$"
        
        //fetch price data from API
        self.fetchData()
        
        //timer to trigger API service
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
            timer in
            self.fetchData()
            self.currency = UserDefaults.standard.double(forKey: "Currency")
            self.currencySymbol = UserDefaults.standard.string(forKey: "CurrencySymbol") ?? "$"
        }
    }
    
    
    //update balance
    func updateBalance() {
        ethBalance = wallet.ethBalance
        usdcBalance = wallet.usdcBalance
        apeBalance = wallet.apeBalance
        
        ethBalLabel.text = "\(ethBalance)"
        usdcBalLabel.text = "\(usdcBalance)"
        apeBalLabel.text = "\(apeBalance)"
    }
    
    
    
    //send token
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "send"{
            let toView = segue.destination as! SendViewController
            toView.walletAddress = address
            toView.eBalance = ethBalance
            toView.uBalance = usdcBalance
            toView.aBalance = apeBalance
        } else if segue.identifier == "buyCurrency"{
            let toView = segue.destination as! PurchaseViewController
            toView.address = address
            toView.ethBalance = ethBalance
            toView.usdcBalance = usdcBalance
            toView.apeBalance = apeBalance
            toView.ethPrice = ethPrice
            toView.usdcPrice = usdcPrice
            toView.apePrice = apePrice
        }else if segue.identifier == "Swap"{
            let toView = segue.destination as! SwapViewController
            toView.address = address
            toView.ethBalance = ethBalance
            toView.usdcBalance = usdcBalance
            toView.apeBalance = apeBalance
            toView.ethPrice = ethPrice
            toView.usdcPrice = usdcPrice
            toView.apePrice = apePrice
        }
    }
    
    //fectch Price data from API services
    func fetchPriceData(token: Token) {
        var symbol: String = ""
        //select token
        switch token {
        case .eth:
            symbol = "ETH-USD"
        case .usdc:
            symbol = "USDC-USD"
        case .ape:
            symbol = "APE-USD"
        }
        
        //setup URLSession task
        let url = URL(string: "https://api.blockchain.com/v3/exchange/tickers/" + symbol)
        let defaultSession = URLSession(configuration: .default)
        let dataTask = defaultSession.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
            if(error != nil)
            {
                print(error!)
                return
            }
            
            do{
                let decoder = try JSONDecoder().decode(Price.self, from: data!)//decode API data
                
                DispatchQueue.main.async
                { [self] in
                    //update data
                    switch token {
                    case .eth:
                        //update price
                        ethPrice = currency * decoder.lastTradePrice
                        eth24H = currency * decoder.price24H
                        ethPriceLabel.text = loader.currencyFormatter(price: ethPrice, symbol: currencySymbol)
                        ethPercent.text = decoder.getPercent() + "%"
                        
                        //update text color
                        priceColor(lastPrice: decoder.lastTradePrice, price24H: decoder.price24H, labelList: self.ethLabelList)
                        
                        //update portfolio data
                        updatePortfolio()
                        
                    case .usdc:
                        //update price
                        usdcPrice = currency * decoder.lastTradePrice
                        usdc24H = currency * decoder.price24H
                        usdcPriceLabel.text = loader.currencyFormatter(price: usdcPrice, symbol: currencySymbol)
                        usdcPercent.text = decoder.getPercent() + "%"
                        
                        //update text color
                        priceColor(lastPrice: decoder.lastTradePrice, price24H: decoder.price24H, labelList: self.usdcLabelList)
                        
                        //update portfolio data
                        updatePortfolio()
                        
                    case .ape:
                        //update price
                        apePrice = currency * decoder.lastTradePrice
                        ape24H = currency * decoder.price24H
                        apePriceLabel.text = loader.currencyFormatter(price: apePrice, symbol: currencySymbol)
                        apePercent.text = decoder.getPercent() + "%"
                        
                        //update text color
                        priceColor(lastPrice: decoder.lastTradePrice, price24H: decoder.price24H, labelList: self.apeLabelList)
                        
                        //update portfolio data
                        updatePortfolio()
                    }
                }
            }
            catch{
                print(error)
                return
            }
        }
        dataTask.resume()
    }
    
    //update portfolio balance and total value
    func updatePortfolio()
    {
        DispatchQueue.main.async { [self] in
            let ethValue = wallet.ethBalance * ethPrice
            let usdcValue = wallet.usdcBalance * usdcPrice
            let apeValue = wallet.apeBalance * apePrice
            let totalValue = ethValue + usdcValue + apeValue
            
            let value24H = wallet.ethBalance * eth24H + wallet.usdcBalance * usdc24H + wallet.apeBalance * ape24H
            let valueChange = String(format: "%.2f", totalValue - value24H)
            let valuePercent = String(format: "%.2f", (totalValue - value24H)/value24H*100)
            let totalValueString = String(format: "%.2f", totalValue)
            
            portfolioValue.text = currencySymbol+"\(totalValueString)"+" ~ PnL:  "+currencySymbol+"\(valueChange)"+"/"+"\(valuePercent)"+"%"
            //set color
            if totalValue > value24H {
                portfolioValue.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            }
            if totalValue < value24H {
                portfolioValue.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            }
            
        }
    }
    
    //update price and portfolio
    func fetchData() {
        self.fetchPriceData(token: .eth)
        self.fetchPriceData(token: .usdc)
        self.fetchPriceData(token: .ape)
        self.updatePortfolio()
    }
    
    //update price label text color based on price change
    func priceColor(lastPrice: Double, price24H: Double, labelList: [UILabel]) {
        if lastPrice > price24H {
            labelList[0].textColor =  #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            labelList[1].textColor =  #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        }
        
        if lastPrice < price24H {
            labelList[0].textColor =  #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            labelList[1].textColor =  #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
    }
}
