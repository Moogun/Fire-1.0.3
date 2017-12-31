//
//  CustomTabBarController.swift
//  Fire
//
//  Created by Moogun Jung on 12/20/16.
//  Copyright © 2016 Moogun. All rights reserved.
//

import UIKit


// Featured - Search - Course - MyQuestion - Profile Controllers

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let featuredLayout = UICollectionViewFlowLayout()
        let featuredController = FeaturedController(collectionViewLayout: featuredLayout)
        let navFeaturedController = UINavigationController(rootViewController: featuredController)
        navFeaturedController.tabBarItem.title = "Featured"
        navFeaturedController.tabBarItem.image = #imageLiteral(resourceName: "featured")
        
        // View controller
        let courseController = CourseController()
        let navCourseController = UINavigationController(rootViewController: courseController)
        navCourseController.tabBarItem.title = "수업"
        navCourseController.tabBarItem.image = #imageLiteral(resourceName: "courseList")
        
        
        //* when search becomes meaningful
         
        let searchController = CourseSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let navSearchController = UINavigationController(rootViewController: searchController)
        navSearchController.tabBarItem.title = "검색"
        navSearchController.tabBarItem.image = #imageLiteral(resourceName: "search")
        
         //*/
        
        let fifthController = QuestionListController(collectionViewLayout: UICollectionViewFlowLayout())
        let navQuestionListController = UINavigationController(rootViewController: fifthController)
//        navQuestionListController.tabBarItem.badgeValue = ""
        navQuestionListController.tabBarItem.title = "내 질문"
        navQuestionListController.tabBarItem.image = #imageLiteral(resourceName: "bookmark")
        
        let accountLayout = UICollectionViewFlowLayout()
        let accountController = AccountController(collectionViewLayout: accountLayout)
        let navAccountController = UINavigationController(rootViewController: accountController)
        navAccountController.tabBarItem.title = "정보"
        navAccountController.tabBarItem.image = #imageLiteral(resourceName: "user")
        
        viewControllers = [navSearchController, navCourseController, navQuestionListController, navAccountController]
        
    }
}
