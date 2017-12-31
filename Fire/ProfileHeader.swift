//
//  ProfileHeader.swift
//  Fire
//
//  Created by Moogun Jung on 10/9/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate {
    func handleProfile()
}

class ProfileHeader: BaseCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: UserModel? {
        didSet {
            
            if let profileImageUrl = user?.profileImageUrl, !profileImageUrl.isEmpty {
                self.profileImageView.loadImage(urlString: profileImageUrl)
            }
        }
    }
    
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
    
    var delegate: ProfileController?

    func didChangePhoto() {
        delegate?.handleProfile()
    }

    
    //MARK:- ProfileImage Picking
    //1
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.showImagePicker(imagePicker: picker)
    }

    //2
    func dismissImagePickerView() {
        delegate?.dismiss(animated: true, completion: nil)
    }

    func showImagePicker(imagePicker: UIImagePickerController) {
        delegate?.present(imagePicker, animated: true, completion: nil)
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
            //uploadProfilePicture(selectedImage: self.profileImageView.image!)
        }
        
        self.dismissImagePickerView()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismissImagePickerView()
    }

    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10 + 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 90, height: 90)
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(changePhotoButton)
        changePhotoButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        changePhotoButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        let seperatorView = UIView()
        self.addSubview(seperatorView)
        
//        seperatorView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
//        seperatorView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
//        
    }
}


//MARK:- Defualt Header

class DefaultHeader: BaseCell {
    
    var user: UserModel?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "Private Data"
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        //backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        let seperatorView = UIView()
        self.addSubview(seperatorView)
        
        seperatorView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        seperatorView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
}


