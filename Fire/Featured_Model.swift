//
//  Featured_Model.swift
//  Fire
//
//  Created by Moogun Jung on 8/10/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

struct Featured_Model {
    
    var banners: Category_Model?
    var courseCategories: [Category_Model]?
}

struct Category_Model {
    
    let title: String
    var courses: [CourseModel]?
    
    init(title: String) {
        self.title = title
    }
}

extension Database {
    
    static func category(completion: @escaping (Category_Model) -> ()) {
        
        Database.database().reference().child("featured").child("categories").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let categoryDict = snapshot.value as? [String: Any] else { return }
    
            categoryDict.forEach({ (key, value) in
            
                var category = Category_Model(title: key)

                // Nov 29
//                var courses = [CourseModel]()
//                for courseDict in value as! [String: Any] {
////                    let course = CourseModel(id: courseDict.key, dictionary: courseDict.value as! [String : Any])
////                    courses.append(course)
//                }
//                category.courses = courses
            
                DispatchQueue.main.async(execute: {
                    completion(category)
                })
            
            })
            
        })
    }
    
    static func featured(completion: @escaping (Featured_Model) -> ()) {
        Database.database().reference().child("featured").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let featuredDict = snapshot.value as? [String: Any] else { return }
            
            //output data default set
            var featured = Featured_Model()
            
            //iterating two keys: banners, categories 
            
            featuredDict.forEach({ (key, value) in
                
                if key == "banners" {
                    
                    var bannerCategory = Category_Model(title: key)
                    var courses = [CourseModel]()
                    
//                    for featuredDict in value as! [String: Any] {
//                        let course = CourseModel(id: featuredDict.key, dictionary: featuredDict.value as! [String : Any])
//                        courses.append(course)
//                    }
//                    
                    bannerCategory.courses = courses
                    featured.banners = bannerCategory
                    
                } else {
                    
                    //key == categories
                    var categories = [Category_Model]()
                    
                    for categoryDict in value as! [String: Any] {
                        //key == best, hot, new
                        var category = Category_Model(title: categoryDict.key)
                        var courses = [CourseModel]()
                        
                        guard let courseDict = categoryDict.value as? [String: Any] else { return }
                        
                        for course in courseDict {
//                            let course = CourseModel(id: course.key, dictionary: course.value as! [String : Any])
//                            courses.append(course)
                        }
                        
                        category.courses = courses
                        categories.append(category)
                    }
                
                    featured.courseCategories = categories
                }
                
                DispatchQueue.main.async(execute: {
                    completion(featured)
                })
                
            })
        })
    }
    
}


