//
//  BookList.swift
//  Fire
//
//  Created by Moogun Jung on 12/17/16.
//  Copyright © 2016 Moogun. All rights reserved.
//

import UIKit
import Firebase

//MARK:- COURSE
struct CourseModel {
    
    let id: String
    var info: InfoModel?
    var about: [AboutModel]?
    
    var announcement: Dictionary<String, Any>?
    var chapters: Dictionary<String, Any>?
    
    //var chapters: [ChapterModel]?
    var attendee: Dictionary<String, Any>?
    var reviews: Dictionary<String, Any>?
    
    init(id: String) {
        self.id = id
    }
    
}


//MARK:- Information

struct InfoModel {
    let id: String
    
    let title: String
    let courseDescription: String
    let courseImageUrl: String
    
    let instructor: String
    let instructorId: String

    var offline: Bool
    
    let period: String
    let language: String
    
    var attendeeCount: Int
    
    var reviews: Int
    var rating: Double
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.title = dictionary["title"] as? String ?? ""
        self.courseDescription = dictionary["courseDescription"] as? String ?? ""
        self.courseImageUrl = dictionary["courseImageUrl"] as? String ?? ""
        
        self.instructor = dictionary["instructor"] as? String ?? ""
        self.instructorId = dictionary["instructorId"] as? String ?? ""
        
        self.offline = dictionary["offline"] as? Bool ?? false
        
        self.period = dictionary["period"] as? String ?? ""
        self.language = dictionary["language"] as? String ?? ""
        
        self.attendeeCount = dictionary["attendeeCount"] as? Int ?? 0
        
        self.reviews = dictionary["reviews"] as? Int ?? 0
        self.rating = dictionary["rating"] as? Double ?? 0
    }
}

//MARK:- InstructorModel

struct InstructorModel {
    
    let id: String
    let name: String
    let profileImageUrl: String
    let courseArray: Dictionary<String, Any>
    let experience: String
    
    init(id: String, dictionary: [String: Any], courseArray: Dictionary<String, Any>) {
        self.id = id
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.courseArray = dictionary["courses"] as? Dictionary<String, Any> ?? [:]
        
        self.experience = dictionary["experience"] as? String ?? ""
    }
    
}

//MARK:- AttendeeModel

struct AttendeeModel {
    
    let attendeeArray: Dictionary<String, Any>
    init(dictionary: [String: Any]) {
        self.attendeeArray = dictionary
    }
    
}


//MARK:- AboutModel

struct AboutModel {
    
    let id: String
    let title: String
    let details: String
    let aboutImageUrl: String
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.title = dictionary["title"] as? String ?? ""
        self.details = dictionary["details"] as? String  ?? ""
        self.aboutImageUrl = dictionary["aboutImageUrl"] as? String ?? ""
    }
}

//MARK:- AnnouncementModel

struct AnnouncementModel {
    
    let id: String
    let title: String
    let details: String
    let imageUrl: String
    let createdAt: Date
    
    let user: UserModel
    
    init(id: String, dictionary: [String: Any], user: UserModel) {
        self.id = id
        self.title = dictionary["title"] as? String ?? ""
        self.details = dictionary["details"] as? String  ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["createdAt"] as? Double ?? 0
        self.createdAt = Date(timeIntervalSince1970: secondsFrom1970)
        self.user = user
        
    }
}


//MARK:- ChapterModel

struct ChapterModel {
    
    // Sep 8
    let id: String
    let title: String
    let chapterDescription: String
    let chapterImageUrl: String
    
    var questions: Dictionary<String, Any>
    
    var keywords: Dictionary<String, Any>
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.title = dictionary["title"] as? String ?? ""
        self.chapterDescription = dictionary["chapterDescription"] as? String ?? ""
        self.chapterImageUrl = dictionary["chapterImageUrl"] as? String ?? ""
        self.questions = dictionary["questions"] as? Dictionary<String, Any> ?? [:]
        
        self.keywords = dictionary["keywords"] as? Dictionary<String, Any> ?? [:]
    }
}


//MARK:- Fetching data

extension Database {
    
    static func fetchFollowingCourseInfo (completion: @escaping (InfoModel) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        
        ref.child("followingCourses").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print("snapshot value:", snapshot.value)
            
            guard snapshot.exists() else {
                NotificationCenter.default.post(name: .noCourseYet, object: nil)
                return }
            
            guard let followingDicts = snapshot.value as? [String: Any] else { return }
            print("following dicts:", followingDicts)
            
            followingDicts.forEach({ (key, value) in
                print(key, value)
                
                ref.child("courses").child(key).child("info").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    
                    guard let info = snapshot.value as? [String: Any] else { return }
                
                    let courseInfoItem = InfoModel(id: key, dictionary: info)
                    DispatchQueue.main.async {
                        completion(courseInfoItem)
                    }
                })
            })
            
        }) { (err) in
            print(err)
        }
    }
    
    static func fetchFollowingCourses(completion: @escaping (CourseModel) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        
        ref.child("followingCourses").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard snapshot.exists() else {
                NotificationCenter.default.post(name: .noCourseYet, object: nil)
                return }
            
            guard let followingDicts = snapshot.value as? [String: Any] else { return }
            print("following dicts:", followingDicts)
            
            followingDicts.forEach({ (key, value) in
                Database.fetchCourseWithId(courseId: key, completion: { (CourseModel) in
                    DispatchQueue.main.async(execute: {
                        completion(CourseModel)
                    })
                })
            })
            
        }) { (err) in
            print(err)
        }
    }
    
    static func fetchCourseWithId(courseId: String, completion: @escaping (CourseModel) -> ()) {
        Database.database().reference().child("courses").child(courseId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var course = CourseModel(id: courseId)
            guard let courseDict = snapshot.value as? [String: Any] else { return }
            
            courseDict.forEach({ (key, value) in

                if key == "chapters" {
                    course.chapters = value as? Dictionary<String, Any> ?? [:]
                    
                    } else if key == "info" {
                        //3. basicInfo
//                        guard let infoDicts = value as? [String : Any] else { return }
//                    let info = InfoModel(id: dictionary: infoDicts)
//                        course.info = info
                    
                    } else if key == "announcement" {
                    
                        course.announcement = value as? Dictionary<String, Any> ?? [:]
                    
                    } else if key == "about" {
                    
                        guard let aboutDicts = value as? [String:Any] else { return }
                    
                        var abouts = [AboutModel]()
                    
                        aboutDicts.forEach({ (key, value) in
                            guard let aboutDict = value as? [String: Any] else { return }
                            let about = AboutModel(id: key, dictionary: aboutDict)
                            abouts.sort(by: { (p1, p2) -> Bool in
                                p1.id.compare(p2.id) == .orderedDescending
                            })
                            abouts.append(about)
                        })
                    
                        course.about = abouts
             
                    } else if key == "attendee" {
                    
                        course.attendee = value as? Dictionary<String, Any> ?? [:]
                    
                    }
            })

            completion(course)

        }) { (err) in
            print(err)
        }
    }
    
    
    static func fetchChaptersWithId(id: String, completion: @escaping (ChapterModel) -> ()) {
        Database.database().reference().child("chapters").child(id).observeSingleEvent(of: .value
            , with: { (snapshot) in
                
                guard let chapterDict = snapshot.value as? [String: Any] else { return }
                let chapter = ChapterModel(id: id, dictionary: chapterDict)
                completion(chapter)
                
        }) { (err) in
            print("Failed to fetch chapters:", err)
        }
    }
    
    static func fetchAnnWithId(instructorId: String, id: String, completion: @escaping (AnnouncementModel) -> ()) {
        
        Database.fetchUserWithUID(uid: instructorId) { (UserModel) in

            let user = UserModel
            print("user", user)
            Database.database().reference().child("announcement").child(id).observeSingleEvent(of: .value
                , with: { (snapshot) in
                    //print("snapshot key, value:", snapshot.key, snapshot.value)
                    guard let annDict = snapshot.value as? [String: Any] else { return }
                    let ann = AnnouncementModel(id: id, dictionary: annDict, user: user)
                    
                    completion(ann)
                    
            }) { (err) in
                print("Failed to fetch chapters:", err)
            }

        }
        
    }
    
}
