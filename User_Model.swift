//
//  UserModel.swift
//  Fire
//
//  Created by Moogun Jung on 1/1/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

struct UserModel {
    
    let uid: String
    let name: String
    let email: String
    let profileImageUrl: String
    
    let questions: Dictionary<String, Any>
    let questionHasLiked: Dictionary<String, Any>
    let questionHasFollowed: Dictionary<String, Any>
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
        self.questions = dictionary["questions"] as? Dictionary<String, Any> ?? [:]
        self.questionHasLiked = dictionary["questionHasLiked"] as? Dictionary<String, Any> ?? [:]
        self.questionHasFollowed = dictionary["questionHasFollowed"] as? Dictionary<String, Any> ?? [:]
    }
}

extension Database {
   
    static func fetchUserWithUID(uid: String, completion: @escaping (UserModel) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDict = snapshot.value as? [String: Any] else { return }
            let user = UserModel(uid: uid, dictionary: userDict)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
    
    //can't get the result out 
    static func checkIfUsernameExists(userName: String) -> Bool {
        
        var userNameExist = false
        
        let ref = Database.database().reference().child("users")
        let queryRef = ref.queryOrdered(byChild: "name").queryEqual(toValue: userName)
        queryRef.observeSingleEvent(of: .value) { (snapshot) in
            
            print("checking if username exists:", snapshot.exists())
            if snapshot.exists() {
                userNameExist = true
                print("username exists:", userNameExist, snapshot.value as Any)
            }
        }
      
        return userNameExist
    }
}

