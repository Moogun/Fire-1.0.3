//
//  Keyword+CoreDataProperties.swift
//  
//
//  Created by Moogun Jung on 11/20/17.
//
//

import Foundation
import CoreData


extension Keyword {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Keyword> {
        return NSFetchRequest<Keyword>(entityName: "Keyword")
    }

    @NSManaged public var id: String?
    @NSManaged public var language: String?
    @NSManaged public var chapterId: String?
    @NSManaged public var keyword: String?
    @NSManaged public var pronunciation: String?
    @NSManaged public var meaning_1: String?
    @NSManaged public var eg_1: String?
    @NSManaged public var egMeaning_1: String?
    @NSManaged public var egPronun_1: String?
    @NSManaged public var meaning_2: String?
    @NSManaged public var eg_2: String?
    @NSManaged public var egMeaning_2: String?
    @NSManaged public var egPronun_2: String?
    @NSManaged public var keywordImageUrl: String?
    @NSManaged public var note: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var hasChecked: Bool
    @NSManaged public var noteAdded: Bool

}
