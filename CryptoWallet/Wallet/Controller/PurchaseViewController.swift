//
//  PurchaseViewController.swift
//  Wallet
//
//  Created by Zhe Xu on 2022/5/16.
//

import UIKit

class PurchaseViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    var address: String = ""
    var ethBalance: Double = 0
    var usdcBalance: Double = 0
    var apeBalance: Double = 0
    var wallet = Wallet()
    var wallets: [Wallet] = []
    var loader = WalletLoader()
    var ethPrice : Double = 0
    var usdcPrice : Double = 0
    var apePrice : Double = 0
    var userCurrency:Double = 0
    var pickerValue:Int = 0
    var symbol = UserDefaults.standard.string(forKey: "CurrencySymbol")
    
    var visuallCurrencySelected : String = "ETH"
    var numOfcurrency : Int = 0
    var pickerData:[String] = ["ETH", "USDC", "APE"]
    var detailsDict:[String:String] = [:]
    @IBOutlet weak var typeCurrencyPicker: UIPickerView!
    @IBOutlet weak var numCurrencyText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        numCurrencyText.text=String(0)
        numCurrencyText.delegate = self
        typeCurrencyPicker.delegate = self
        typeCurrencyPicker.dataSource = self
        
        
        // Do any additional setup after loading the view.
        
        //load wallet from UserDefault
        wallet = loader.getWallet(walletAddress: address)
        wallets = loader.loadWallet()
        
    }
    
    //Restrict users from inputing non-numeric content in text file
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == numCurrencyText {
                let onlyNumers = CharacterSet(charactersIn:"0123456789")
                let characterSet = CharacterSet(charactersIn: string)
                //string contains 0123456789.
                if onlyNumers.isSuperset(of: characterSet)==true{
                    return true
                }else{
                    //check string whether exist .
                    if string == "." {
                        if textField.text!.contains(".")==true{
                            return false
                        }else{
                            return true
                        }
                    }
                    return false
            }
                }
            return true
          }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToDetailsPage"{
            let toView = segue.destination as! BuySwapDetailsViewController
            toView.address = address
                toView.detailsDict = detailsDict
   
            
        }
    }
    @IBAction func buyButton(_ sender: UIButton) {
        if Double(numCurrencyText.text!)!>0{
        var cost :Double = 0
        //Based on the user's choice, calculate the price required to purchase the currency and send it to the Details page
        switch pickerData[pickerValue]{
        case "ETH":
            wallet.ethBalance = ethBalance + Double(numCurrencyText.text!)!
            cost = (Double(numCurrencyText.text!)! * ethPrice)
            loader.updateBalance(wallet: wallet)
        case "USDC":
            wallet.usdcBalance = usdcBalance + Double(numCurrencyText.text!)!
            cost = (Double(numCurrencyText.text!)! * usdcPrice)
            loader.updateBalance(wallet: wallet)
        case "APE":
            
            wallet.apeBalance = apeBalance + Double(numCurrencyText.text!)!
            cost = (Double(numCurrencyText.text!)! * apePrice)
            loader.updateBalance(wallet: wallet)
        default:break

        }
            detailsDict = ["CurrencyType":pickerData[pickerValue],"CurrencyAmount":numCurrencyText.text!,"Cost":            loader.currencyFormatter(price: cost, symbol: symbol ?? "$")]
        }else{
            createAlert(title: "ERROR", message: "Amount is 0")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerValue = pickerView.selectedRow(inComponent: 0)
          
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // Create alert for display
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // Add action for user dismiss the alert by click "OK"
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion:nil)}))
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}
