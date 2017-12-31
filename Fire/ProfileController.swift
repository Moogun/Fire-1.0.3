//asf
//  ProfileController.swift
//  Fire
//
//  Created by Moogun Jung on 10/8/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProfileHeaderDelegate {
    
    var user: UserModel? {
        didSet {
            
        }
    }
    
	let cv : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let cellId = "cellId"
    let headerId = "headerId"
    let defaultHeaderId = "defaultHeaderId"
    
    
    let profileSection = ["Basic", "Private Info"]
    
    let profileItems = [
        ["Name", "Username"],
        ["Email", "Phone", "Password"]
    ]

    var placeholders = [
        ["Name", "Username"],
        ["Email","Phone","Password"]
    ]
    
    //MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.view.addSubview(cv)
        cv.anchor(top: self.topLayoutGuide.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        cv.dataSource = self
        cv.delegate = self
        
        self.cv.alwaysBounceVertical = true
        self.cv.keyboardDismissMode = .interactive
        
        self.cv.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        self.cv.register(DefaultHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: defaultHeaderId)
        self.cv.register(ProfileCell.self, forCellWithReuseIdentifier: cellId)
        
        // this one is not working
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save))
    }
    
    @objc func save() {
        print("save")
    }
}


//MARK:- data source, delegate method
extension ProfileController {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return profileSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = indexPath.section
        
        switch section {
            case 0:
               let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ProfileHeader
                   header.user = self.user
                   header.delegate = self
                return header
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: defaultHeaderId, for: indexPath) as! DefaultHeader
                    header.user = self.user
                return header
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.view.frame.width, height: 150) //104 + 50
        } else {
            return CGSize(width: self.view.frame.width, height: 50) //104 + 50
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileItems[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileCell
        cell.titleLabel.text = profileItems[indexPath.section][indexPath.item]
        cell.textField.placeholder = placeholders[indexPath.section][indexPath.item]
        cell.textField.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellIndex = collectionView.indexPathsForSelectedItems
        print(cellIndex as Any)
     
    }
    
    
}

extension ProfileController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.answers[textField.tag] = textField.text
//        print(answers)
//
//        if answers[textField.tag] == words[textField.tag], !(answers[textField.tag]?.isEmpty)! {
//
//            let markContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 10 + 15, height: 15))
//            let markView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
//
//            markView.image = #imageLiteral(resourceName: "correct")
//            markContainerView.addSubview(markView)
//
//            textField.rightViewMode = .unlessEditing
//            textField.rightView = markContainerView
//
//        } else {
//
//            textField.clearButtonMode = UITextFieldViewMode.whileEditing
//
//            let markContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 10 + 15, height: 15))
//            let markView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
//
//            markView.image = #imageLiteral(resourceName: "incorrect")
//            markContainerView.addSubview(markView)
//
//            textField.rightViewMode = .unlessEditing
//            textField.rightView = markContainerView
//
//        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
}


//MARK:- Firebase
extension ProfileController {
    
    func handleProfile() {
        print("handle")
    }
    
    func uploadProfilePicture(selectedImage: UIImage) {
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).png")
       
        if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.1) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let ref = Database.database().reference().child("users/\(uid)")
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let value = ["profileImageUrl": profileImageUrl]
                    ref.updateChildValues(value, withCompletionBlock: { (error, ref) in
                        
                        if error != nil {
                            print(error as Any)
                            return
                        }
                    })
                }
              
                //put data
            })
        }
    }
    
    func saveProfileChange() {
        print(1234)
    }
    
}
