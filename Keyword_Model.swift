//
//  KeywordModel.swift
//  Fire
//
//  Created by Moogun Jung on 1/14/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

struct KeywordModel {
    
    let id: String
    
    let language: String
    let chapterId: String
    
    let keyword: String
    let pronunciation: String?
    
    let meaning_1: String?
    let eg_1: String?
    let egMeaning_1: String?
    let egPronun_1: String?
    
    let meaning_2: String?
    let eg_2: String?
    let egMeaning_2: String?
    let egPronun_2: String?
    
    let keywordImageUrl: String?
    var note: String? = nil 
    var createdAt: Double = 11.00
    
//    var hasChecked: Bool = false
    var hasChecked: Bool
    var noteAdded: Bool = false
    
    init(id: String, dictionary: [String: Any]) {
        
        self.id = id
        self.language = dictionary["language"] as? String ?? ""
        self.chapterId = dictionary["chapterId"] as? String ?? ""
        self.keyword = dictionary["keyword"] as? String ?? ""
        self.pronunciation = dictionary["pronunciation"] as? String
        
        self.meaning_1 = dictionary["meaning_1"] as? String
        self.eg_1 = dictionary["eg_1"] as? String
        self.egMeaning_1 = dictionary["egMeaning_1"] as? String
        self.egPronun_1 = dictionary["egPronun_1"] as? String
        
        self.meaning_2 = dictionary["meaning_2"] as? String
        self.eg_2 = dictionary["eg_2"] as? String
        self.egMeaning_2 = dictionary["egMeaning_2"] as? String
        self.egPronun_2 = dictionary["egPronun_2"] as? String
        
        self.keywordImageUrl = dictionary["keywordImageUrl"] as? String
        
        self.hasChecked = dictionary["hasChecked"] as? Bool ?? false
        
    }
    
    static func fetch(completion: @escaping (KeywordModel) ->()) {
        Database.database().reference().child("keywords").observe(.value, with: { (snapshot) in
            
            guard let keywordDicts = snapshot.value as? [String: Any] else { return }
            
            keywordDicts.forEach({ (key, value) in
                
                guard let keywordDictionary = value as? [String: Any] else { return }
                
                let keyword = KeywordModel(id: key, dictionary: keywordDictionary)
                
                completion(keyword)
            })
            
        }) { (err) in
            print(err)
        }
    }
    
    static func fetchKeywordsWithId(chapterId: String, completion: @escaping (KeywordModel) -> ()) {
        
        Database.database().reference().child("keywords").child(chapterId).observe(.value, with: { (snapshot) in
            
            guard let keywordDicts = snapshot.value as? [String: Any] else { return }
            
            keywordDicts.forEach({ (key, value) in
                guard let keywordDictionary = value as? [String: Any] else { return }

                var keyword = KeywordModel(id: key, dictionary: keywordDictionary)
                
                guard let uid = Auth.auth().currentUser?.uid else { return }

                Database.database().reference().child("marks").child(key).child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    
//                    if let value = snapshot.value as? Int, value == 1 {
//                        keyword.hasChecked = true
//                    } else {
//                        keyword.hasChecked = false
//                    }
                
                    completion(keyword)
                })
            
            })
            
            }) { (err) in
                print(err)
            }
    }
    
}

struct Note_Model {
    let text: String
    let createdAt: Date
    
    init(dictionary : [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        let secondsFrom1970 = dictionary["createdAt"] as? Double ?? 0
        self.createdAt = Date(timeIntervalSince1970: secondsFrom1970)
    }
}


