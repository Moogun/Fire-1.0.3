//
//  SearchController.swift
//  Fire
//
//  Created by Moogun Jung on 3/14/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

//MARK:- Controller
class CourseSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter course Name"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    let cellId = "cellId"
    
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.register(CourseSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        setupSearchBarLayout()
        
        self.fetchCourseInfo()
    }
    
    func setupSearchBarLayout() {
        
//        navigationController?.navigationBar.addSubview(searchBar)
//        let navBar = navigationController?.navigationBar
//        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
//
//        searchBar.isHidden = true
        navigationItem.title = "수업 목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "새로고침", style: UIBarButtonItemStyle.plain, target: self, action: #selector(refresh))
    }
    
    //Nov 8temp refresh
    @objc func refresh() {
        courseInfo.removeAll()
        fetchCourseInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    //MARK:- COURSE INFO FETCHING
    
    var courseInfo = [InfoModel]()
    var filteredCourseInfo = [InfoModel]()
    
    fileprivate func fetchCourseInfo() {
        Database.searchCourse { (CourseInfoModel) in
            self.courseInfo.append(CourseInfoModel)
            self.filteredCourseInfo = self.courseInfo
            self.collectionView?.reloadData()
        }
    }

    
    //MARK:- CELL
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredCourseInfo.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CourseSearchCell
        cell.courseInfo = self.filteredCourseInfo[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 76)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let courseInfo = filteredCourseInfo[indexPath.item]
        let preview = PreviewController(collectionViewLayout: UICollectionViewFlowLayout())
        preview.courseInfo = courseInfo
        navigationController?.pushViewController(preview, animated: true)
        
    }
    
    //MARK:- SearchBar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredCourseInfo = courseInfo
        } else {
            filteredCourseInfo = self.courseInfo.filter({ (info) -> Bool in
                return (info.title.lowercased().contains(searchText.lowercased()))
            })
        }
        self.collectionView?.reloadData()
    }
    
}


extension Database {
    
    static func searchCourse( completion: @escaping (InfoModel) -> () ) {
        let ref = Database.database().reference()
        ref.child("allCategory").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
            guard let allCourseDict = snapshot.value as? [String : Any] else { return }
            allCourseDict.forEach({ (key, value) in
                ref.child("courses").child(key).child("info").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    let courseInfoItem = InfoModel(id: key, dictionary: snapshot.value as! [String : Any])
                    DispatchQueue.main.async {
                        completion(courseInfoItem)
                    }
                })
            })
            
        }
    }
    
}


