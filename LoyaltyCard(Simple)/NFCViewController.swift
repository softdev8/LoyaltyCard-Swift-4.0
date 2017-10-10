//
//  NFCViewController.swift
//  LoyaltyCard(Simple)
//
//  Created by admin on 13/09/2017.
//

import UIKit

class NFCViewController: UIViewController {
    let helper = NFCHelper()
    var payloadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let button = UIButton(type: .system)
        button.setTitle("Read NFC", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 28.0)
        button.addTarget(self, action: #selector(didTapReadNFC), for: .touchUpInside)
        button.frame = CGRect(x: 60, y: 200, width: self.view.bounds.width - 120, height: 80)
        self.view.addSubview(button)
        
        payloadLabel = UILabel(frame: button.frame.offsetBy(dx: 0, dy: 300))
        payloadLabel.numberOfLines = 10
        payloadLabel.text = "Scan an NFC Tag"
        self.view.addSubview(payloadLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onNFCResult(success: Bool, msg: String) {
        DispatchQueue.main.async {
            self.payloadLabel.text = "\(self.payloadLabel.text!)\n\(msg)"
        }
    }
    
    @objc func didTapReadNFC() {
        print("didTapReadNFC")
        self.payloadLabel.text = ""
        helper.onNFCResult = onNFCResult(success:msg:)
        helper.restartSession()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
