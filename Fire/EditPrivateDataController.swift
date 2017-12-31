//
//  EditPrivateDataController.swift
//  Fire
//
//  Created by Moogun Jung on 10/29/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class EditPrivateDataController: UIViewController {
    
    var user: UserModel? {
        didSet {
            emailTextField.text = user?.email
        }
    }
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "Email"
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.leftViewMode = .always
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        //tf.addTarget(self, action: #selector(signInAgain), for: .editingChanged)
        tf.tag = 0
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveNewEmailAddress))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //--------------------------------- EMAIL FIELD ---------------------------------
        
        view.addSubview(emailTextField)
        emailTextField.backgroundColor = UIColor(r: 249, g: 249, b: 249, a: 1)
        
        emailTextField.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 98, height: emailTextField.frame.height))
        emailPaddingView.addSubview(emailLabel)
        emailLabel.anchor(top: nil, left: emailPaddingView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emailLabel.centerYAnchor.constraint(equalTo: emailPaddingView.centerYAnchor).isActive = true
        
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = .always
        
        //METHOD
        signInAgain()
        
    }
    
    //MARK:- METHODS
    
    @objc func signInAgain() {
        
        //let title = "이메일 계정 변경"
        let alertController = UIAlertController(title: nil, message: "이메일 주소를 변경하기 위해서는 로그인 해야합니다..", preferredStyle: .alert)
        
        // text
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "비밀번호를 입력하세요"
        }
        
        // cancel option
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alertController.textFields?[0].text = nil
        })
        
        // ok option to send the email
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak alertController] (_) in
            guard let email = self.user?.email else { return }
            guard let password = alertController?.textFields?[0].text else { return }
            
            self.reAuthenticateUser(email: email, password: password)
        })
        
        alertController.addAction(cancel)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func reAuthenticateUser(email: String, password: String) {
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                print(error as Any)
                self.alert(title: "Error", message: "Error occured re-authentificating", actionTitle: "test00")
            } else {
                print("User re-authenticated")
            }
        }
    }
    
    
    var isTextViewUpdated: Bool = false
    
    // to save
    
    @objc func textViewDidChange(_ textView: UITextView) {
        
        if !textView.text.isEmpty {
            isTextViewUpdated = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            isTextViewUpdated = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func saveNewEmailAddress() {
        
       guard let email = emailTextField.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
       Auth.auth().currentUser?.updateEmail(to: email) { (err) in
            
            if err != nil {
                guard let errorDescription = err?.localizedDescription else { return }
                self.alert(title: "Error", message: errorDescription, actionTitle: "test")
                return
            }
        
            let newEmail = ["email": email]
            Database.database().reference().child("users").child(uid).updateChildValues(newEmail)
            self.verifyEmailAddress()
        }
    }
    
    func verifyEmailAddress() {
        
        Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
            
            if err != nil {
                guard let errorDescription = err?.localizedDescription else { return }
                self.alert(title: "Error", message: errorDescription, actionTitle: "test")
                return
            }
            
            self.alert(title: "Email Verification", message: "Please verify the email", actionTitle: "test00")
            NotificationCenter.default.post(name: .profileUpdated, object: nil)

        })
    }
    
    // error message alert
    func alert(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            print("verification")
        }))
        present(alertController, animated: true, completion: nil)
    }

}
