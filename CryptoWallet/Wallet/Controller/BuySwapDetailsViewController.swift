//
//  BuySwapDetailsViewController.swift
//  Wallet
//
//  Created by Zhe Xu on 2022/5/16.
//

import UIKit

class BuySwapDetailsViewController: UIViewController {
    var address: String = ""
    @IBOutlet weak var detailsTableView: UITableView!
    var detailsDict:[String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "backAccount"{
            let toView = segue.destination as! AccountViewController
            toView.address = address
   
            
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
extension BuySwapDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsDict.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell=tableView.dequeueReusableCell(withIdentifier: "detailsT", for: indexPath)
        
        let itmeName = Array(detailsDict.keys)
        let itmeValue = Array(detailsDict.values)
        cell.textLabel?.text = itmeName[indexPath.row]
        cell.detailTextLabel?.text = itmeValue[indexPath.row]
        return cell


    
    }

    

}
