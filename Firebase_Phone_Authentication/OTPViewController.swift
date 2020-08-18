//
//  ViewController.swift
//  OTPDemo
//
//  Created by Danish Khan on 25/05/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import UIKit
import OTPFieldView
import FirebaseAuth

class OTPViewController: UIViewController {
    
    @IBOutlet var otpTextFieldView: OTPFieldView!
    
    @IBOutlet weak var otpLabel: UILabel!
    var otpNumber:String!
    var userNameOrPhoneNumber:String? = nil
    var userId:Int?
    var otpHasEntered:Bool = false
    var enteredOtp:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpLabel.text = "OTP sent to: "+otpNumber
        setupOtpView()
    }
    
    func setupOtpView(){
        self.otpTextFieldView.fieldsCount = 6
        self.otpTextFieldView.fieldBorderWidth = 2
        self.otpTextFieldView.defaultBorderColor = UIColor.darkGray
        self.otpTextFieldView.filledBorderColor = UIColor.darkGray
        self.otpTextFieldView.cursorColor = UIColor.darkGray
        self.otpTextFieldView.displayType = .square
        self.otpTextFieldView.fieldSize = 45
        self.otpTextFieldView.separatorSpace = 5
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
    }
    
    @IBAction private func backButtonTapped(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func otpButtonTapped(_ sender: UIButton) {
        if otpHasEntered{
           let verificationId = UserDefaults.standard.getVerificationID()
            let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: enteredOtp!)
            Auth.auth().signIn(with: credentials) { (result, error) in
                if error == nil{
                    //AlertUtility.showAlert(self, title: "Success", message: "Verify")
                    self.showSuccessView()
                }else{
                    AlertUtility.showAlert(self, title: "Error", message: error?.localizedDescription)
                }
            }
        }else{
            AlertUtility.showAlert(self, title: "Alert", message: "Please enter the otp")
        }
    }
    
    private func showSuccessView() {
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let successViewController = storyBoard.instantiateViewController(withIdentifier:"SuccessViewController") as? SuccessViewController else { return }
            successViewController.modalPresentationStyle = .fullScreen
            self.present(successViewController, animated: true, completion: nil)
            
        }
        
    }
    
    
}

extension OTPViewController: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        otpHasEntered = hasEntered
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        enteredOtp = otpString
        print("OTPString: \(otpString)")
    }
}



