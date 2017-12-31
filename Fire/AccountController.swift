//
//  AccountController.swift
//  Fire
//
//  Created by Moogun Jung on 1/1/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class AccountController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AccountHeaderDelegate {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var user: UserModel?
    
    var settings = ["추가 예정 기능", "앱 오류 신고", "건의 사항", "문의","로그아웃"]
    
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor(r: 249, g: 249, b: 249, a: 1)
        self.collectionView?.keyboardDismissMode = .interactive
        self.collectionView?.register(AccountHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(AccountCell.self, forCellWithReuseIdentifier: cellId)
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: .profileUpdated, object: nil)
        self.fetchUser()
    }
    
    func viewWillDisappear(animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- HEADER
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AccountHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 94) //64
    }
    
    //MARK:- Cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AccountCell
        cell.titleLabel.text = self.settings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if indexPath.item == 0 {
            newFeatureDidTap()
        } else if indexPath.item == 1 {
            reportDidTap(titleMessage: "앱 오류 신고")
        } else if indexPath.item == 2 {
            reportDidTap(titleMessage: "건의사항")
        } else if indexPath.item == 3 {
            reportDidTap(titleMessage: "문의")
        } else if indexPath.item == 4 {
            logoutButtonDidTap()
        }
    }
    
    
    //MARK:- Methods
    
    @objc func updateProfile() {
        self.fetchUser()
    }

    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (UserModel) in
            self.user = UserModel
            
            guard let questions = self.user?.questions else { return }
            print("questions in account", questions)
            self.collectionView?.reloadData()
        }
    }
    
    func handleProfile() {

        let editProfileController = EditProfileController()
        editProfileController.user = user
        
        let navController = UINavigationController(rootViewController: editProfileController)
        present(navController, animated: true, completion: nil)
        
    }
    
    func newFeatureDidTap() {
        let newFeatureController = NewFeatureController()
        navigationController?.pushViewController(newFeatureController, animated: true)
    }
    
    func reportDidTap(titleMessage: String) {
        let feedback = FeedbackController()
        feedback.titleLabel.text = titleMessage
        let navController = UINavigationController(rootViewController: FeedbackController())
        present(navController, animated: true, completion: nil)
    }
    
    func  logoutButtonDidTap() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "Logout?", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                print("signed out")
                
                let loginController = LoginController()
                self.navigationController?.present(loginController, animated: true, completion: nil)
                
            } catch let logoutError {
                print(logoutError)
            }
            
        })
    
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(logout)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }

}

