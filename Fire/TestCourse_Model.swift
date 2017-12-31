//
//  TestCourse_Model.swift
//  Fire
//
//  Created by Moogun Jung on 8/19/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

import Firebase
struct TestCourse_Model {
    
    let id: String
    var basicInfo: BasicInfo?
    var chapters: [TestChapter_Model] = []

    init(id: String) {
        self.id = id
    }
    
}
struct BasicInfo {
    
        let title: String
        let courseImageUrl: String
        let instructor: String
    
        let language: String
        let courseDescription: String
    
        let category: String
    
    init(dictionary: [String: Any]) {
        
        self.title = dictionary["title"] as? String ?? ""
        self.courseImageUrl = dictionary["courseImageUrl"] as? String ?? ""
        self.instructor = dictionary["instructor"] as? String ?? ""

        self.language = dictionary["language"] as? String ?? ""
        self.courseDescription = dictionary["courseDescription"] as? String ?? ""

        self.category = dictionary["category"] as? String ?? ""
    }

}

struct TestChapter_Model {
    
    let id: String
    let title: String
    let chapterDescription: String
    let chapterImageUrl: String
    
    var keywords : [Keyword_Model] = []
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.title = dictionary["title"] as? String ?? ""
        self.chapterDescription = dictionary["chapterDescription"] as? String ?? ""
        self.chapterImageUrl = dictionary["chapterImageUrl"] as? String ?? ""
    }
}

extension FIRDatabase {
    
    static func fetchTestCourse(completion: @escaping (TestCourse_Model) -> ()) {
        FIRDatabase.database().reference().child("testCourse").child("courseId0819").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let testDict = snapshot.value as? [String: Any] else { return }
            
            var course = TestCourse_Model(id: snapshot.key)
            
            testDict.forEach({ (key, value) in
                //print(key, value)
                
                if key == "basicInfo" {
                    let basicInfo = BasicInfo(dictionary: value as! [String : Any])
                    course.basicInfo = basicInfo
                    
                } else if key == "chapters" {
                    
                    var chapters = [TestChapter_Model]()
                    
                    let chapterDicts = value as! [String: Any]
                    
                    chapterDicts.forEach({ (key, value) in
                        
                        var chapter = TestChapter_Model(id: key, dictionary: value as! [String : Any])
                        
                        let chapterDict = value as! [String: Any]
                        
                        chapterDict.forEach({ (key, value) in
                            
                            var keywords = [Keyword_Model]()
                            
                            if key == "keywords" {
                                //print(value)
                                let keywordDict = value as! [String: Any]
                                keywordDict.forEach({ (key, value) in

                                    FIRDatabase.database().reference().child("keywords").child(key).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
  
                                        let keyword = Keyword_Model(id: snapshot.key, dictionary: snapshot.value as! [String : Any])
                                        keywords.append(keyword)
                                        
                                    })
                                })
                                
                                chapter.keywords = keywords
                            }
                        })

                        course.chapters.append(chapter)
                    })
                }
                completion(course)
            })

        })

    }
        
}
