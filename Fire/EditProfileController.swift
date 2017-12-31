//
//  EditProfileController.swift
//  Fire
//
//  Created by Moogun Jung on 10/27/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "chapter")
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    lazy var changePhotoButton: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Change Photo", for: .normal)
        btn.addTarget(self, action: #selector(handleSelectProfileImageView), for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    //MARK:- PROFILE IMAGE PICKING
    //1
    lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()

    @objc func handleSelectProfileImageView() {
        self.showImagePicker(imagePicker: picker)
    }

    //2
    func dismissImagePickerView() {
        dismiss(animated: true, completion: nil)
    }

    func showImagePicker(imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true, completion: nil)
    }

    //3
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }

        if let selectedImage = selectedImageFromPicker {
            self.profileImageView.image = selectedImage
            isProfileImageUpdated = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        self.dismissImagePickerView()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismissImagePickerView()
    }

    //MARK:- INPUT FIEDLS PROPERTIES
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "Name"
        return label
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.leftViewMode = .always
        tf.keyboardType = .alphabet
        tf.returnKeyType = .next
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.tag = 1
        return tf
    }()
    
    var privateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "Private Information"
        return label
    }()
    
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
        
        //tf.addTarget(self, action: #selector(emailTFDidTap), for: .touchUpInside)
        tf.tag = 0
        return tf
    }()
    
    var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "Phone"
        return label
    }()
    
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.leftViewMode = .always
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        //tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        tf.tag = 0
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.leftViewMode = .always
        tf.borderStyle = .none
        tf.backgroundColor = UIColor(r: 232, g: 236, b: 241, a: 1)
        tf.keyboardType = .default
        tf.returnKeyType = .done
        tf.tag = 2
        //tf.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return tf
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: UIScreen.main.bounds)
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    let contentView : UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    //MARK:- USER DATA
    
    var user: UserModel? {
        didSet {
       
            if let profileImageUrl = user?.profileImageUrl, !profileImageUrl.isEmpty {
                self.profileImageView.loadImage(urlString: profileImageUrl)
            }
            
            usernameTextField.text = user?.name
            emailTextField.text = user?.email
            
        }
    }
    
    
    // user array? dictionary?
    // text field delegate
    // checking if any data were edited
    // canceling
    // alert are you sure you want to cancel? No yes 
    
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissEditProfileController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveData))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: self.view.frame.height)
        
        contentView.addSubview(profileImageView)
        profileImageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10 + 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 90, height: 90)
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        contentView.addSubview(changePhotoButton)
        changePhotoButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        changePhotoButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        
        //MARK:- IINPUT FIELDS LAYOUT
        //--------------------------------- NAME FIELD ---------------------------------
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 98, height: usernameTextField.frame.height))
        namePaddingView.addSubview(nameLabel)
        
        nameLabel.anchor(top: nil, left: namePaddingView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        nameLabel.centerYAnchor.constraint(equalTo: namePaddingView.centerYAnchor).isActive = true

        usernameTextField.leftView = namePaddingView
        usernameTextField.leftViewMode = .always
        
        let seperatorView = UIView()
        usernameTextField.addSubview(seperatorView)
        seperatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        if let leftPadding = usernameTextField.leftView?.frame.width {
            seperatorView.anchor(top: nil, left: usernameTextField.leftAnchor, bottom: usernameTextField.bottomAnchor, right: usernameTextField.rightAnchor, paddingTop: 0, paddingLeft: leftPadding, paddingBottom: 0, paddingRight: 10, width: 0, height: 0.5)
        }
        
        
        //--------------------------------- PRIVATE DATA ---------------------------------
        let privatePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 98, height: usernameTextField.frame.height))
        privatePaddingView.addSubview(privateLabel)
        privateLabel.anchor(top: nil, left: privatePaddingView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        privateLabel.centerYAnchor.constraint(equalTo: privatePaddingView.centerYAnchor).isActive = true
        
        
        //--------------------------------- EMAIL FIELD ---------------------------------
        emailTextField.delegate = self
        
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 98, height: emailTextField.frame.height))
        emailPaddingView.addSubview(emailLabel)
        emailLabel.anchor(top: nil, left: emailPaddingView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emailLabel.centerYAnchor.constraint(equalTo: emailPaddingView.centerYAnchor).isActive = true

        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = .always

        let seperatorView2 = UIView()
        emailTextField.addSubview(seperatorView2)
        seperatorView2.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)

        if let leftPadding2 = usernameTextField.leftView?.frame.width {
            seperatorView2.anchor(top: nil, left: emailTextField.leftAnchor, bottom: emailTextField.bottomAnchor, right: emailTextField.rightAnchor, paddingTop: 0, paddingLeft: leftPadding2, paddingBottom: 0, paddingRight: 10, width: 0, height: 0.5)
        }
        
        
        //--------------------------------- PHONE FIELD ---------------------------------
        let phonePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 98, height: emailTextField.frame.height))
        phonePaddingView.addSubview(phoneLabel)
        phoneLabel.anchor(top: nil, left: phonePaddingView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 14, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        phoneLabel.centerYAnchor.constraint(equalTo: phonePaddingView.centerYAnchor).isActive = true

        phoneTextField.leftView = phonePaddingView
        phoneTextField.leftViewMode = .always

        let seperatorView3 = UIView()
        phoneTextField.addSubview(seperatorView3)
        seperatorView3.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)

        if let leftPadding3 = usernameTextField.leftView?.frame.width {
            seperatorView3.anchor(top: nil, left: phoneTextField.leftAnchor, bottom: phoneTextField.bottomAnchor, right: phoneTextField.rightAnchor, paddingTop: 0, paddingLeft: leftPadding3, paddingBottom: 0, paddingRight: 10, width: 0, height: 0.5)
        }
        
        
        //--------------------------------- STACK VIEW FIELD ---------------------------------
        let profileStackView = UIStackView(arrangedSubviews: [usernameTextField, privatePaddingView, emailTextField, phoneTextField])
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        profileStackView.axis = .vertical
        profileStackView.distribution = .fillEqually
        profileStackView.spacing = 0
        
        contentView.addSubview(profileStackView)
        
        profileStackView.anchor(top: changePhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)
        
        let clearView = UIView()
        contentView.addSubview(clearView)
        clearView.backgroundColor = .white
        clearView.anchor(top: profileStackView.bottomAnchor, left: profileStackView.leftAnchor, bottom: contentView.bottomAnchor, right: profileStackView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }
    
    //MARK:- METHODS
    
    var isProfileUpdated: Bool = false
    var isProfileImageUpdated: Bool = false
    
    @objc func saveData() {
        
        if isProfileUpdated && !isProfileImageUpdated {
            saveProfileData()
        } else if !isProfileUpdated && isProfileImageUpdated {
            saveProfileImage()
        } else if isProfileUpdated && isProfileImageUpdated {
            saveUserProfile()
        }
    }
    
    func saveProfileData() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let ref = Database.database().reference().child("users").child(uid)
        let value: [String: Any] = ["username": username]
        
        
        ref.updateChildValues(value) { (err, ref) in
            if err != nil {
                print(err as Any)
            }
            print("successfully update profile")
            
            self.isProfileUpdated = false
            self.alertView1(message: Text.saved)
            
            NotificationCenter.default.post(name: .profileUpdated, object: nil)
    
        }

    }
    
    func saveProfileImage() {
        print("saving profile image")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let image = profileImageView.image else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }

        navigationItem.rightBarButtonItem?.isEnabled = false

        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("profile").child(filename)
        ref.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload profile image:", err)
                return
            }

            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print("Successfully uploaded profile image:", imageUrl)

            let ref = Database.database().reference().child("users").child(uid)
            let value: [String: Any] = ["profileImageUrl": imageUrl]
            
            ref.updateChildValues(value, withCompletionBlock: { (err, ref) in
                print("successfully updated to profile node")
                
                self.isProfileImageUpdated = false
                self.alertView1(message: Text.saved)
                
                NotificationCenter.default.post(name: .profileUpdated, object: nil)
            })
        }

        // let uploadTask = ref.putData...
        //uploadTask.observe(.progress) { (snapshot) in
        //            //print("total:", snapshot.progress?.totalUnitCount)
        //            guard let total = snapshot.progress?.totalUnitCount else { return }
        //            if let completedUnitCount = snapshot.progress?.completedUnitCount {
        //                self.navigationItem.title = String(completedUnitCount)
        //                print(completedUnitCount / total * 100)
        //            }
        //
        //        }
    }
    
    func saveUserProfile() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let image = profileImageView.image else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }

        navigationItem.rightBarButtonItem?.isEnabled = false

        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("profile").child(filename)
        ref.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload profile image:", err)
                return
            }

            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print("Successfully uploaded profile image:", imageUrl)

            let ref = Database.database().reference().child("users").child(uid)
            let value: [String: Any] = ["username": username, "profileImageUrl": imageUrl]

            ref.updateChildValues(value, withCompletionBlock: { (err, ref) in
                print("successfully updated to profile node")

                self.isProfileImageUpdated = false
                self.alertView1(message: Text.saved)

                NotificationCenter.default.post(name: .profileUpdated, object: nil)

            })
        }
    }
    
    
    
    @objc func dismissEditProfileController() {
        if isProfileUpdated || isProfileImageUpdated {
            alertDiscard()
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func alertDiscard() {
        
        let alertController = UIAlertController(title: "저장하지 않은 데이터", message: "변경한 내용을 저장하지 않고 종료하시겠습니까?", preferredStyle: .alert)
        
        let no = UIAlertAction(title: "No", style: .cancel, handler: { (_) in
        })
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(no)
        alertController.addAction(yes)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension EditProfileController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != user?.name {
            isProfileUpdated = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            isProfileUpdated = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            let editPrviateDataController = EditPrivateDataController()
            editPrviateDataController.user = self.user
            navigationController?.pushViewController(editPrviateDataController, animated: true)
        }
        return false
    }
    
}
