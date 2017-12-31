//
//  SignUpController.swift
//  Fire
//
//  Created by Moogun Jung on 4/25/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import SafariServices

class SignUpController: UIViewController, UITextFieldDelegate {

    //MARK:- Top section for Toomtoome name and sign up 
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: UIScreen.main.bounds)
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Group 38")
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    //MARK:- Middle section for Input fields
    
    let emailIconView : UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        view.image = #imageLiteral(resourceName: "Page 1")
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.leftViewMode = .always
        //tf.backgroundColor = UIColor(r: 232, g: 236, b: 241, a: 1)
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        tf.tag = 0
        return tf
    }()
    
    let usernameIconView : UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        view.image = #imageLiteral(resourceName: "username")
        return view
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.leftViewMode = .always
        //tf.backgroundColor = UIColor(r: 232, g: 236, b: 241, a: 1)
        tf.keyboardType = .alphabet
        tf.returnKeyType = .next
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        tf.tag = 1
        return tf
    }()
    
    let passIconView : UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        view.image = #imageLiteral(resourceName: "pass")
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.leftViewMode = .always
        tf.borderStyle = .roundedRect
        //tf.backgroundColor = UIColor(r: 232, g: 236, b: 241, a: 1) // Nov 29 changed color
        tf.keyboardType = .default
        tf.returnKeyType = .done
        tf.tag = 2
        tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "signUp"), for: .normal)
        button.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        button.sizeToFit()
        button.isEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()

    //MARK:- Middle Section for temrs
    
    let termsLabel : UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 12)
        title.text = Text.agreement
        title.textColor = .gray
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var termsButton: UIButton = {
        let button = UIButton ()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.terms, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.sizeToFit()
        button.addTarget(self, action: #selector(handleTermsView), for: .touchUpInside)
        return button
    }()
    
    //MARK:- Bottom Section to login 
    
    let loginLabel : UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 12)
        title.text = Text.haveAnAccount
        title.textColor = .darkGray
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.login, for: .normal)
        button.setTitleColor(Text.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.sizeToFit()
        button.addTarget(self, action: #selector(presentloginController), for: .touchUpInside)
        return button
    }()

    let aiv: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .gray) 
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    //MARK:- methods
    
    @objc func validateForm() {
        
        let emailEntered = self.emailTextField.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isEmailValid = email.evaluate(with: emailEntered)
        
        if isEmailValid && self.passwordTextField.text?.count ?? 0 >= 6 && self.usernameTextField.text?.count ?? 0 >= 1 {
            self.signUpButton.isEnabled = true
        } else {
            self.signUpButton.isEnabled = false
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            print(nextField)
            nextField.becomeFirstResponder()
        } else {
            print("no next field")
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    /*
     need to fix the error handling in here,
     same for the login error
     */
    
    
    /*
     decide whether to add check same username check method before adding user data into database
     */
    
    @objc func signUpButtonDidTap() {
        
        guard let email = emailTextField.text, email.count > 0 else { print("Form is not valid")
            return }
        guard let userName = usernameTextField.text, userName.count > 0 else { print("Form is not valid")
            return }
        guard let password = passwordTextField.text, password.count > 0 else { print("Form is not valid")
            return}
        
    
        // 1. check user name
        // 2. if any duplicate found add suffixx
        // 3. else save it
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            
            self.aiv.startAnimating()
            
            // user account signing up at Auth
            if error != nil {
                print(error as Any)
                guard let errorDescription = error?.localizedDescription else { return }
                self.alert(title: "Error", message: errorDescription, actionTitle: "test")
                return
            }
            
            guard let uid = user?.uid else { return }
            
            // adding user info into db user node
            
            let userRef = Database.database().reference().child("users")
            let queryRef = userRef.queryOrdered(byChild: "username").queryEqual(toValue: userName)
            queryRef.observeSingleEvent(of: .value) { (snapshot) in

                print("checking if username exists:", snapshot.exists())

                if snapshot.exists() {
                    
                    var tempUserName = ""
                    print("uid:", uid)
                    let append = uid.suffix(3)
                    print("append:", append)
                    
                    tempUserName = userName + append
                    self.addUserToDatabase(uid: uid, email: email, userName: tempUserName)
                    
                } else {
                    self.addUserToDatabase(uid: uid, email: email, userName: userName)
                }
                
            }
        })
        
    }
    
    func addUserToDatabase(uid: String, email: String, userName: String) {
        
        let ref = Database.database().reference() //            (fromURL: "https://fire-5a33d.firebaseio.com/")
        let userReference = ref.child("users").child(uid)
        let values = ["email": email, "username": userName]
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err as Any)
                guard let errorDescription = err?.localizedDescription else { return }
                self.alert(title: "Error", message: errorDescription, actionTitle: "test")
                return
            }
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
                
                if err != nil {
                    guard let errorDescription = err?.localizedDescription else { return }
                    self.alert(title: "Error", message: errorDescription, actionTitle: "test")
                    return
                }
                
                self.alert(title: "Email Verification", message: "Please verify the email", actionTitle: "test00")
                
                AppDelegate.instance?.presentLoginController()
            })

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

    @objc func handleTermsView() {
        
        let url = URL(string: "http://www.toomtoome.com/terms")!
        let viewController = SFSafariViewController(url: url)
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @objc func presentloginController() {
        
        let loginController = LoginController()
        self.present(loginController, animated: false, completion: {
            print("complete")
        })
    
    }
    
    
    //MARK:- Layouts
    
    fileprivate struct textFieldDimension {
        static let margin: CGFloat = 10
        static let height: CGFloat = 40
    }
    
    //add fbloginbutton for fb signup 
    //let fbLoginButton = FBSDKLoginButton()
    
    let contentView : UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: self.view.frame.height)
        
        
        self.emailTextField.delegate = self
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        
        self.setupTopContainerView()
        self.setupMiddleInputFields()
        self.setupBottomTermsView()
        self.setupBottomSignInView()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupTopContainerView() {
        
        contentView.addSubview(imageView)
        imageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func setupMiddleInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 30),
                                     stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
                                     stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor,constant: -80),
                                     stackView.heightAnchor.constraint(equalToConstant: 200)])
        
        self.setupInputFieldsIconViews()
    }

    func setupInputFieldsIconViews() {
        
        let emailIconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 10 + 15, height: 15))
        emailIconView.frame = CGRect(x: 10, y: 0, width: 15, height: 15)
        
        emailIconContainerView.addSubview(emailIconView)
        emailTextField.leftView = emailIconContainerView
        
        let usernameIconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 10 + 15, height: 15))
        usernameIconView.frame = CGRect(x: 10, y: 0, width: 15, height: 15)
        
        usernameIconContainerView.addSubview(usernameIconView)
        usernameTextField.leftView = usernameIconContainerView
        
        
        let passIconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 10 + 15, height: 15))
        passIconView.frame = CGRect(x: 10, y: 0, width: 15, height: 15)
        
        passIconContainerView.addSubview(passIconView)
        passwordTextField.leftView = passIconContainerView
        
    }
    
    func setupBottomTermsView() {
        
        let termsStackView = UIStackView(arrangedSubviews: [termsLabel, termsButton])

        termsStackView.translatesAutoresizingMaskIntoConstraints = false
        termsStackView.axis = .horizontal
        termsStackView.distribution = .fillProportionally
        termsStackView.spacing = 6

        view.addSubview(termsStackView)

        NSLayoutConstraint.activate([
            termsStackView.topAnchor.constraint(equalTo: self.signUpButton.bottomAnchor, constant: textFieldDimension.margin),
            termsStackView.centerXAnchor.constraint(equalTo: self.signUpButton.centerXAnchor, constant: 0),
            ])
    
        //        view.addSubview(fbLoginButton)
        //        fbLoginButton.anchor(top: termsStackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 50)
        
        
    }
    
    func setupBottomSignInView()  {
        
        let stackView = UIStackView(arrangedSubviews: [loginLabel, loginButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
                                     stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0) ])
    }
     
}
