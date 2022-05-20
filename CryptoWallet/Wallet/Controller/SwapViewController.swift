//
//  SwapViewController.swift
//  Wallet
//
//  Created by Zhe Xu on 2022/5/16.
//

import UIKit

class SwapViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
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
    var firstPickerValue:Int = 0
    var secondPickerValue:Int = 0
    var pickerData: [[String]] = [[String]]()
    var combinnSwapType = ""
    var detailsDict:[String:String] = [:]
    var newAddAmount : Double = 0
    
    @IBOutlet weak var accountText: UITextField!
    @IBOutlet weak var accountStepper: UIStepper!
    @IBOutlet weak var swapPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        accountText.text = String(0)
        //picker value
        pickerData = [["ETH", "USDC", "APE"],
        ["to"],["ETH", "USDC", "APE"]]
        accountText.delegate = self
        swapPickerView.delegate = self
        swapPickerView.dataSource = self
        // Do any additional setup after loading the view.
        
        //load wallet from UserDefault
        wallet = loader.getWallet(walletAddress: address)
        wallets = loader.loadWallet()
        

        accountStepper.minimumValue = 0
        
        
        accountStepper.maximumValue = ethBalance

        accountStepper.stepValue = 1

        accountStepper.autorepeat = true

        accountStepper.wraps = false
        
        
    }
    
    //Restrict users from inputing non-numeric content in text file
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == accountText {
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
       
    
    //Swap button
    @IBAction func completeSwap(_ sender: UIButton) {
        //check the currency whether is the same
        if pickerData[0][firstPickerValue] != pickerData[2][secondPickerValue]{
            if Double(accountText.text!)! <= accountStepper.maximumValue || Double(accountText.text!)!==0{
                
                
            
            
            
            //cobmine the swap currency type, and update, Stepper max number
        switch combinnSwapType {
        case "ETHUSDC":
            wallet.ethBalance = ethBalance - Double(accountText.text!)!
            //Used in the Details page to show how much currency was successfully swaped
            newAddAmount = Double(accountText.text!)!*ethPrice/usdcPrice
            wallet.usdcBalance = usdcBalance + newAddAmount
            loader.updateBalance(wallet: wallet)
            self.performSegue(withIdentifier: "completeSwap", sender: self);
        case "ETHAPE":
            wallet.ethBalance = ethBalance - Double(accountText.text!)!
            newAddAmount = Double(accountText.text!)!*ethPrice/apePrice
            wallet.apeBalance = apeBalance + newAddAmount
            loader.updateBalance(wallet: wallet)
            self.performSegue(withIdentifier: "completeSwap", sender: self);
        case "USDCAPE":
            wallet.usdcBalance = usdcBalance - Double(accountText.text!)!
            newAddAmount = Double(accountText.text!)!*usdcPrice/apePrice
            wallet.apeBalance = apeBalance + newAddAmount
            loader.updateBalance(wallet: wallet)
            self.performSegue(withIdentifier: "completeSwap", sender: self);
        case "USDCETH":
            wallet.usdcBalance = usdcBalance - Double(accountText.text!)!
            newAddAmount = Double(accountText.text!)!*usdcPrice/ethPrice
            wallet.ethBalance = ethBalance + newAddAmount
            loader.updateBalance(wallet: wallet)
            self.performSegue(withIdentifier: "completeSwap", sender: self);
        case "APEETH":
            wallet.apeBalance = apeBalance - Double(accountText.text!)!
            newAddAmount = Double(accountText.text!)!*apePrice/ethPrice
            wallet.ethBalance = ethBalance + newAddAmount
            loader.updateBalance(wallet: wallet)
            self.performSegue(withIdentifier: "completeSwap", sender: self);
        case "APEUSDC":
            wallet.apeBalance = apeBalance - Double(accountText.text!)!
            newAddAmount = Double(accountText.text!)!*apePrice/usdcPrice
            wallet.usdcBalance = usdcBalance + newAddAmount
            loader.updateBalance(wallet: wallet)
            self.performSegue(withIdentifier: "completeSwap", sender: self);
        default :break
            
        }
            }else{
                //Alert the user if the currency is the same
                createAlert(title: "ERROR", message: "Lack of currency balance or amount is 0")
            }
        }else{
            //Alert the user if the currency is the same
            createAlert(title: "ERROR", message: "Same currency cannot be swap")
            
            
        }
        
        
        
    }
    //Transfer the dictionary for the Details Page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        detailsDict = [pickerData[0][firstPickerValue]:pickerData[2][secondPickerValue],"-"+String(Double(accountText.text!)!):"+"+String(newAddAmount)]
            if segue.identifier == "completeSwap"{
            let toView = segue.destination as! BuySwapDetailsViewController
            toView.address = address
            toView.detailsDict = detailsDict
        }
    }
    
    
    //make the text file display one-third of the total balence
    @IBAction func thirdAction(_ sender: UIButton) {
        accountText.text=""
        accountText.text = String(accountStepper.maximumValue/3)
        accountStepper.value = Double(accountText.text!)!
    }
    //make the text file display half of the total balence
    @IBAction func halfAction(_ sender: UIButton) {
        accountText.text=""
        accountText.text = String(accountStepper.maximumValue/2)
        accountStepper.value = Double(accountText.text!)!
    }
    //make the text file display  total balence
    @IBAction func allAction(_ sender: UIButton) {
        accountText.text=""
        accountText.text = String(accountStepper.maximumValue)
        accountStepper.value = Double(accountText.text!)!
    }
    //stepperFun, add or sub
    @IBAction func stepperAction(_ sender: UIStepper) {
        accountText.text = Int(sender.value).description
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(component == 0){
            return pickerData[component][row]
                }
                else if (component == 1){
                    return pickerData[component][row]
                }else{
                    
                    return pickerData[component][row]
                    
                }
            
            
        
        
       
    }
    //Change the maximum amount of convertible currency in the text box as the user chooses
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        firstPickerValue = pickerView.selectedRow(inComponent: 0)
        secondPickerValue = pickerView.selectedRow(inComponent: 2)
        
        combinnSwapType = pickerData[0][firstPickerValue] + pickerData[2][secondPickerValue]
        switch pickerData[0][firstPickerValue]{
        case "ETH":
            accountStepper.maximumValue = ethBalance
        case "USDC":
            accountStepper.maximumValue = usdcBalance
        case "APE":
            accountStepper.maximumValue = apeBalance
        default:break
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
    


}
