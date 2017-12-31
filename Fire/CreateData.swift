//
//  CreateData.swift
//  Fire
//
//  Created by Moogun Jung on 4/16/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class CreateData {

    func createCourse() {
        
        let ref = Database.database().reference()
        let childRef = ref.child("courses").childByAutoId()
        let childInstRef = ref.child("instructors").childByAutoId()
        
        let courseKey = childRef.key
        let instructorKey = childInstRef.key
        
        let value = ["title": "해커스 토익 보카", "instructor": "David Cho", "courseDescription": "토익 800점 어휘"]
        let instructorValue = ["name": "james"]
        ref.child("courses").child("\(courseKey)").setValue(value)
        ref.child("instructors").child(instructorKey).setValue(instructorValue)
        
    }
    
    
    class func createChapter() {
        
        for _ in 1...5 {
            let ref = Database.database().reference()
            let childRef = ref.child("chapters").childByAutoId()
            let chapterKey = childRef.key
            
            let value = ["title": "abc", "chapterDescription": "700"]
            //let value1 = ["\(chapterKey)": 1]
            
            ref.child("chapters").child(chapterKey).updateChildValues(value)
            //ref.child("keywords").child(chapterKey).updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>)
        }
    }
    
    class func createKeyword() {
        
        for _ in 1...28 {
            
            let ref = Database.database().reference()
            let childRef = ref.child("keywords").childByAutoId()
            let keywordKey = childRef.key
            let _ = ["chapterId": "-KfRv3VNZ855SgKPDsFy",
                         "keyword": "你过得怎么样?",
                         "pronunciation": "[Nǐguò de zěnme yàng]",
                         "meaning_1": "어떻게 지내셨어요?",
                         "eg_1": "你最近过得怎么样",
                         "egMeaning_1": "그동안 어떻게 지내셨어요?",
                         "egPronun_1": "Nǐ zuìjìnguò de zěnme yàng",
                         "language": "cn"]
            let value1 = ["\(keywordKey)": 1]
            
            ref.child("keywords").child("test").updateChildValues(value1)
            
        }
        
    }
    
}

