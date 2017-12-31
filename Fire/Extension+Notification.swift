//
//  Extension+Notification.swift
//  Fire
//
//  Created by Moogun Jung on 6/28/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    static let updateLibrary = NSNotification.Name(rawValue: "updateLibrary")
    static let updateKeyword = NSNotification.Name(rawValue: "updateKeyword")
    
    static let newQuestion = NSNotification.Name(rawValue: "newQuestion")
    static let deleteQuestion = NSNotification.Name(rawValue: "deleteQuestion")
    
    static let newAnswer = NSNotification.Name(rawValue: "newAnswer")
    static let deleteAnswer = NSNotification.Name(rawValue: "deleteAnswer")
    
    static let imageSaved = NSNotification.Name(rawValue: "imageSaved")
    
    static let profileUpdated = NSNotification.Name(rawValue: "profileUpdated")
    
    static let noCourseYet = NSNotification.Name(rawValue: "noCourseYet")
}
