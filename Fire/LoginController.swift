//
//  LoginController.swift
//  Fire
//
//  Created by Moogun Jung on 12/12/16.
//  Copyright © 2016 Moogun. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    
    //MARK:- View Objects
    
    fileprivate struct textFontSize {
        static let inputField: CGFloat = 15
    }
    
    //MARK:- Top section for Toomtoome name and greetings
    
    let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Group 38")
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    //MARK:- Middle section for Input fields
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: textFontSize.inputField)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.leftViewMode = .always
        //tf.backgroundColor = UIColor(r: 232, g: 236, b: 241, a: 1)
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return tf
    }()
    
    let emailIconView : UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        view.image = #imageLiteral(resourceName: "Page 1")
        return view
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password (6 more characters)"
        tf.font = UIFont.systemFont(ofSize: textFontSize.inputField)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.leftViewMode = .always
        tf.borderStyle = .roundedRect
        //tf.backgroundColor = UIColor(r: 232, g: 236, b: 241, a: 1)
        tf.keyboardType = .default
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return tf
    }()
    
    let passIconView : UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        view.image = #imageLiteral(resourceName: "pass")
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "login"), for: .normal)
        button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        button.sizeToFit()
        button.isEnabled = false
        return button
    }()
    
    //MARK:- Middle Section to reset password
    
    let loginDetailsLabel : UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 12)
        title.text = Text.forgotLogin
        title.textColor = .gray
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var getHelpSignIn: UIButton = {
        let button = UIButton ()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.helpLogin, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.sizeToFit()
        button.addTarget(self, action: #selector(handleHelpSignIn), for: .touchUpInside)
        return button
    }()
    
    
    //MARK:- Bottom Section to sign up
    
    let loginToSignUpSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signUpLabel : UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 12)
        title.text = Text.notSignUp
        title.textColor = UIColor.darkGray
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.signUp, for: .normal)
        button.setTitleColor(Text.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK:- Methods
    
    @objc func validateForm() {

        let emailEntered = self.emailTextField.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isEmailValid = email.evaluate(with: emailEntered)
        
        if isEmailValid && self.passwordTextField.text?.count ?? 0 >= 6 {
            self.loginButton.isEnabled = true
        } else {
            self.loginButton.isEnabled = false 
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        textField.resignFirstResponder()
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
    //MARK: wrong error message for not being authenticated account with an error " this account doesn't exist"
    @objc func loginButtonDidTap() {
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in

            if err != nil {
                guard let errorDescription = err?.localizedDescription else { return }
                self.alert(title: "Error", message: errorDescription, actionTitle: "test")
                return }
            AppDelegate.instance?.presentCustomTabBarController()
        })
    }
    
    // error message alert
    func alert(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            print("error")
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Reset password
        // 1. alert function
        // 2. call handleHelpSignin function
    
    @objc func handleHelpSignIn() {
        
        let title = "비밀번호를 잊으셨나요?"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
       
        // text
        alertController.addTextField { (textField) in
            textField.placeholder = "이메일 주소를 입력하세요"
        }
        
        // cancel option
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alertController.textFields?[0].text = nil
        })
        
        // ok option to send the email
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak alertController] (_) in
            
            guard let email = alertController?.textFields?[0].text else { return }
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (err) in
                
                if err != nil {
                    print("error sending a reset email:", err as Any)
                } else {
                  print("Password reset email sent successfully")
                }
            })
        })
        
        alertController.addAction(cancel)
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }

    @objc func handleSignUp() {
        
        let signUpController = SignUpController()
        self.present(signUpController, animated: false, completion: {
            print("complete")
        })
        
    }
    
    //MARK:- Layouts
    
    fileprivate struct textFieldDimension {
        static let margin: CGFloat = 10
        static let height: CGFloat = 40
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true

        self.hideKeyboardWhenTappedAround()
        
        // Top
        self.setupTopContainerView()
        
        // Middel input
        self.setupMiddleInputFields()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        //Bottom 
        self.setupBottomHelpLoginView()
        self.setupBottomSignUpView()
 
    }

    func setupTopContainerView() {
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func setupMiddleInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
            
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 30),
                                     stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
                                     stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor,constant: -80),
                                     stackView.heightAnchor.constraint(equalToConstant: 150)])
        
        self.setupInputFieldsIconViews()
        
    }
    
    func setupInputFieldsIconViews() {
        
        let emailIconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 10 + 15, height: 15))
        emailIconView.frame = CGRect(x: 10, y: 0, width: 15, height: 15)
        
        emailIconContainerView.addSubview(emailIconView)
        emailTextField.leftView = emailIconContainerView

        let passIconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 10 + 15, height: 15))
        passIconView.frame = CGRect(x: 10, y: 0, width: 15, height: 15)

        passIconContainerView.addSubview(passIconView)
        passwordTextField.leftView = passIconContainerView
        
    }
    
    func setupBottomHelpLoginView() {

        let helpLoginStackView = UIStackView(arrangedSubviews: [loginDetailsLabel, getHelpSignIn])
        
        helpLoginStackView.translatesAutoresizingMaskIntoConstraints = false
        helpLoginStackView.axis = .horizontal
        helpLoginStackView.distribution = .fillProportionally
        helpLoginStackView.spacing = 6
        
        view.addSubview(helpLoginStackView)
        
        NSLayoutConstraint.activate([
            helpLoginStackView.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: textFieldDimension.margin),
            helpLoginStackView.centerXAnchor.constraint(equalTo: self.loginButton.centerXAnchor, constant: 0),
            ])

    }
    
    func setupBottomSignUpView()  {
        
        let stackView = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
                                     stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0) ])
    }

}
