//
//  CourseController.swift
//  Fire
//
//  Created by Moogun Jung on 12/12/16.
//  Copyright © 2016 Moogun. All rights reserved.
//

import UIKit
import Firebase

class CourseController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var courses = [CourseModel]()
    
    let cellId = "cellId"
    var courseWidth: CGFloat = 0
    var courseHeight: CGFloat = 0 
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    //REFRESH CONTROL
    let refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshLibrary), for: .valueChanged)
        rc.attributedTitle = NSAttributedString(string: "Loading ...")
        return rc
    }()
    
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //CreateData.createChapter()
        //CreateData.createKeyword()
        
        navigationItem.title = "수업"
        
        //MARK: COLLECTIONVIEW SETUP
        view.addSubview(collectionView)
        collectionView.anchor(top: self.topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.register(CourseCell.self, forCellWithReuseIdentifier: cellId)
        
        self.courseWidth = self.view.frame.width/2 - 30
        self.courseHeight = self.view.frame.width/2 + 20
    
        
        //iOS Version
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            print("lower than iOS 09")// Fallback on earlier versions
            collectionView.addSubview(refreshControl)
        }
        
        //initial refresh control
        //        refreshControl.layoutIfNeeded()
        //        refreshControl.beginRefreshing()
        
        // FETHCING AND UPDATING DATA
        self.fetchAllCourse()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLibrary), name: .updateLibrary, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noCourseYet), name: .noCourseYet, object: nil)
        
    }
    
    //MARK:- FETHCING AND UPDATING DATA
    
    @objc func updateLibrary() {
        self.refreshLibrary()
    }
    
    @objc func refreshLibrary() {
        //print("refreshing", courses.count)
        self.courseInfo.removeAll()
        self.fetchAllCourse()
        self.collectionView.reloadData()
    }
    
    func fetchAllCourse() {
        self.fetchFollowingCourses()
    }
    
    var courseInfo = [InfoModel]()
    
    func fetchFollowingCourses() {
        
        //Nov 8 fethcing only course info
        Database.fetchFollowingCourseInfo { (InfoModel) in
            print(InfoModel)

            if #available(iOS 10.0, *) {
                self.collectionView.refreshControl?.endRefreshing()
            } else {
                print("before ios 10")// Fallback on earlier versions
                self.refreshControl.endRefreshing()
            }

            self.courseInfo.append(InfoModel)
            self.collectionView.reloadData()
            
        }
        
        //before Nov 8, fethc all course info
//        Database.fetchFollowingCourses() { (CourseModel) -> () in
//
//            print(CourseModel)
//            if #available(iOS 10.0, *) {
//                self.collectionView.refreshControl?.endRefreshing()
//            } else {
//                print("before ios 10")// Fallback on earlier versions
//                self.refreshControl.endRefreshing()
//            }
//
//            self.courses.append(CourseModel)
//            self.collectionView.reloadData()
//        }
    }
    
    @objc func noCourseYet() {
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl?.endRefreshing()
            self.alertView1(message: "등록한 수업이 없습니다.")
        } else {
            print("before ios 10")// Fallback on earlier versions
            self.refreshControl.endRefreshing()
        }
    }
}

//MARK:- CELL

extension CourseController {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CourseCell
        cell.courseInfo = courseInfo[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.courseWidth, height: self.courseHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20 + 10, right: 20)
        //        return UIEdgeInsets(top: 17, left: 17, bottom: 10 + 7, right: 17)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Nov 8
        let courseInfoItem = courseInfo[indexPath.item]
        presentPreviewController(courseInfo: courseInfoItem)
        
        //before Nov 8
//        let course = self.courses[indexPath.item]
//        presentPreviewController(course: course)
    }
    
    
    //MARK:- NAVIGATION
    
    func presentPreviewController(courseInfo: InfoModel) {
        let layoutPreview = UICollectionViewFlowLayout()
        let previewController = PreviewController(collectionViewLayout: layoutPreview)
        previewController.courseInfo = courseInfo
        navigationController?.pushViewController(previewController, animated: true)
    }
    
}

