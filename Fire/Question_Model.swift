//
//  Question_Model.swift
//  Fire
//
//  Created by Moogun Jung on 8/6/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

struct QuestionModel {
   
    let chapterId: String
    let id: String
    
    let user: UserModel?
    
    let text: String
    let uid: String
    let createdAt: Date
    let questionImageUrl: String
    
    let answers: Dictionary<String, Any>
    
    var hasFollowed: Bool = false
    var hasLiked: Bool = false

    var answerCount: Int
    var followCount: Int
    var likeCount: Int
    
    var unreadAnswer: Int
    
    init(chapterId: String, id: String, user: UserModel, dictionary: [String: Any]) {
        
        self.chapterId = chapterId
        self.id = id
        
        self.user = user
        
        self.uid = dictionary["uid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["createdAt"] as? Double ?? 0
        self.createdAt = Date(timeIntervalSince1970: secondsFrom1970)
        
        self.questionImageUrl = dictionary["questionImageUrl"] as? String ?? ""
        
        self.answers = dictionary["answers"] as? Dictionary<String, Any> ?? [:]
        
        self.answerCount = dictionary["answerCount"] as? Int ?? 0
        self.followCount = dictionary["followCount"] as? Int ?? 0
        self.likeCount = dictionary["likeCount"] as? Int ?? 0
        self.unreadAnswer = dictionary["unreadAnswer"] as? Int ?? 0
    }
}

struct AnswerModel {
    
    let id: String
    let questionId: String
    let user: UserModel?
    
    let text: String
    let uid: String
    let createdAt: Date
    let answerImageUrl: String
    
    init(id: String, user: UserModel, dictionary: [String: Any]) {
        
        self.id = id
        self.questionId = dictionary["questionId"] as? String ?? ""
        
        self.user = user
        
        self.uid = dictionary["uid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["createdAt"] as? Double ?? 0
        self.createdAt = Date(timeIntervalSince1970: secondsFrom1970)
        
        self.answerImageUrl = dictionary["answerImageUrl"] as? String ?? ""
        
    }
}



