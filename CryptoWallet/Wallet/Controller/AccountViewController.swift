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
    var ethBalance: Double = 100
    var usdcBalance: Double = 100
    var apeBalance: Double = 100
    var wallet = Wallet()
    var wallets: [Wallet] = []
    var loader = WalletLoader()//load wallet toolkits
    var timer: Timer?
    //Token default price
    var ethPrice: Double = 2000
    var usdcPrice: Double = 1
    var apePrice: Double = 2000

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pull down
        selectTypePullDown.showsMenuAsPrimaryAction = true
        // Do any additional setup after loading the view.
        selectTypePullDown.setTitle("Create a new wallet", for: .normal)
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
        wallets = loader.loadWallet()
        if address == "" {
            wallet = wallets[0]
            address = wallet.address
        }
        
        wallet = loader.getWallet(walletAddress: address)
        
        
        //load balance
        walletAddressLabel.text = wallet.address
        walletNameLabel.text = wallet.walletName
        updateBalance()
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    
    //fectch ETH data from API services
        func fetchEthData() {
            let url = URL(string: "https://api.blockchain.com/v3/exchange/tickers/ETH-USD")
            let defaultSession = URLSession(configuration: .default)
            let dataTask = defaultSession.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
                if(error != nil)
                {
                    print(error!)
                    return
                }
                
                do{
                    let decoder = try JSONDecoder().decode(Price.self, from: data!)
                    
                    DispatchQueue.main.async
                    { [self] in
                    ethPrice = currency * decoder.lastTradePrice
                    eth24H = currency * decoder.price24H
                    ethPriceLabel.text = loader.currencyFormatter(price: ethPrice, symbol: currencySymbol)
                    ethPercent.text = decoder.getPercent() + "%"
                        if decoder.lastTradePrice > decoder.price24H {
                            ethPercent.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                            ethPriceLabel.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                        }

                        if decoder.lastTradePrice < decoder.price24H {
                            ethPercent.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                            ethPriceLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
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
    //fectch USDC data from API services
        func fetchUsdcData() {
            let url = URL(string: "https://api.blockchain.com/v3/exchange/tickers/USDC-USD")
            let defaultSession = URLSession(configuration: .default)
            let dataTask = defaultSession.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
                if(error != nil)
                {
                    print(error!)
                    return
                }
                
                do{
                    let decoder = try JSONDecoder().decode(Price.self, from: data!)
                    
                    DispatchQueue.main.async
                    { [self] in
                        usdcPrice = currency * decoder.lastTradePrice
                        usdc24H = currency * decoder.price24H
                        usdcPriceLabel.text = loader.currencyFormatter(price: usdcPrice, symbol: currencySymbol)
                        usdcPercent.text = decoder.getPercent() + "%"
                        if decoder.lastTradePrice > decoder.price24H {
                            usdcPercent.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                            usdcPriceLabel.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                        }

                        if decoder.lastTradePrice < decoder.price24H {
                            usdcPercent.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                            usdcPriceLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
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
    
    //fectch APE data from API services
        func fetchApeData() {
            let url = URL(string: "https://api.blockchain.com/v3/exchange/tickers/APE-USD")
            let defaultSession = URLSession(configuration: .default)
            let dataTask = defaultSession.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
                if(error != nil)
                {
                    print(error!)
                    return
                }
                
                do{
                    let decoder = try JSONDecoder().decode(Price.self, from: data!)
                    
                    DispatchQueue.main.async
                    { [self] in
                        apePrice = currency * decoder.lastTradePrice
                        ape24H = currency * decoder.price24H
                        apePriceLabel.text = loader.currencyFormatter(price: apePrice, symbol: currencySymbol)
                        apePercent.text = decoder.getPercent() + "%"
                        if decoder.lastTradePrice > decoder.price24H {
                            apePercent.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                            apePriceLabel.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                        }

                        if decoder.lastTradePrice < decoder.price24H {
                            apePercent.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                            apePriceLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
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
    
    func fetchData() {
        self.fetchEthData()
        self.fetchUsdcData()
        self.fetchApeData()
        self.updatePortfolio()
    }

}
