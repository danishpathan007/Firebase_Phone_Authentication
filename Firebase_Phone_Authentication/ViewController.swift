//
//  ViewController.swift
//  FirebasePhoneAuth
//
//  Created by Danish Khan on 14/08/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FlagPhoneNumber
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var phoneTextField: FPNTextField!
    
    
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    var hasEnterNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.setFlag(key: .IN)
        // By default, the picker view is showed but you can display the countries with a list view controller:
        phoneTextField.displayMode = .list // .picker by default
        
        listController.setup(repository: phoneTextField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneTextField.setFlag(countryCode: country.code)
        }
        
    }
    
    
    @IBAction private func loginButtonAction(_ sender: UIButton) {
        
        guard hasEnterNumber != nil, hasEnterNumber != "" else { return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(hasEnterNumber!, uiDelegate: nil) { (verificationId, error) in
            if error == nil {
                guard verificationId != nil else {return}
                UserDefaults.standard.setVerificationID(value: verificationId!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.showOTPView()
                })
            }else{
                print("Unable to get verification from firebase \(error?.localizedDescription)")
            }
        }
        
    }
    
    
    
    private func showOTPView() {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let otpViewController = storyBoard.instantiateViewController(withIdentifier:"OTPViewController") as? OTPViewController else { return }
            otpViewController.otpNumber = self.hasEnterNumber!
            self.present(otpViewController, animated: true, completion: nil)
            
        }
        
    }
    
    
    private func checkNumberLength(textField: FPNTextField) {
        if textField.selectedCountry?.code.rawValue == "IN" {
            if (textField.text!.count == 11){
                phoneTextField.borderWidth = 0.5
                phoneTextField.cornerRadius = 0.4
                phoneTextField.borderColor = .lightGray
            }else{
                phoneTextField.cornerRadius = 0.4
                phoneTextField.borderWidth = 0.5
                phoneTextField.borderColor = .red
            }
        }
    }
    
}


extension ViewController: FPNTextFieldDelegate{
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            // Do something...
            hasEnterNumber = textField.getFormattedPhoneNumber(format: .E164)// Output "+33600000001"
            //checkNumberLength(textField: textField)
            //  textField.getFormattedPhoneNumber(format: .International)  // Output "+33 6 00 00 00 01"
            //  textField.getFormattedPhoneNumber(format: .National)       // Output "06 00 00 00 01"
            //  textField.getFormattedPhoneNumber(format: .RFC3966)        // Output "tel:+33-6-00-00-00-01"
            //  textField.getRawPhoneNumber()                               // Output "600000001"
            
        } else {
            //checkNumberLength(textField: textField)
        }
    }
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        
        listController.title = "Countries"
        
        self.present(navigationViewController, animated: true, completion: nil)
    }
}
