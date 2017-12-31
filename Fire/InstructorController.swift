//
//  InstructorController.swift
//  Fire
//
//  Created by Moogun Jung on 9/7/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

enum InstructorCellMode {
    case profile
    case course
}

class InstructorController: UICollectionViewController, UICollectionViewDelegateFlowLayout, InstructorHeaderDelegate {
    
    var course: CourseModel? {
        didSet {
            print(course?.info?.instructorId as Any)
        }
    }
    var courses = [CourseModel]()
    var instructor : InstructorModel?
    
    var instructorCellMode: InstructorCellMode = .course {
        didSet {
            switch self.instructorCellMode {
                case .course:
                    collectionView?.reloadData()
                case .profile:
                    collectionView?.reloadData()
            }
        }
    }
    
    func didChangeToCourse() {
        self.instructorCellMode = .course
    }
    func didChangeToProfile() {
        self.instructorCellMode = .profile
    }
    
    let cellId = "cellId"
    let headerId = "headerId"
    let courseCellId = "courseCellId"
    
    let overLay = UIView()
    
    let aiv: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        //aiv.translatesAutoresizingMaskIntoConstraints = false
        // the above makes it disappear
        aiv.startAnimating()
        return aiv
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.alwaysBounceVertical = true
        
        collectionView?.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        
        self.collectionView?.register(InstructorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(InstructorProfileCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(InstructorCourseCell.self, forCellWithReuseIdentifier: courseCellId)
        self.fetchInstructor()

        //        let point = view.center
        //        let size = CGSize(width: 100, height: 100)
        //        overLay.frame = CGRect(origin: point, size: size)
        // not working
        
        overLay.frame = (collectionView?.frame)!
        overLay.backgroundColor = .black
        overLay.alpha = 0.5
        view.addSubview(overLay)

        aiv.center = overLay.center
        aiv.startAnimating()
        overLay.addSubview(aiv)
        
        loadingLabel.center = CGPoint(x: aiv.center.x, y: aiv.center.y + 30)
        overLay.addSubview(loadingLabel)
        
        
    }
    
    //MARK:- Header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! InstructorHeader
        header.delegate = self
        header.instructorLabel.text = course?.info?.instructor
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 300)
    }
    
    //MARK:- cells
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch instructorCellMode {
            case .course:
                return self.courses.count
            case .profile:
                return 1
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch instructorCellMode {
            case .course:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: courseCellId, for: indexPath) as! InstructorCourseCell
                cell.instructorLabel.text = course?.info?.instructor
                cell.course = self.courses[indexPath.item]
                return cell
            
            case .profile:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InstructorProfileCell
                cell.titleLabel.text = instructor?.experience
                return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch instructorCellMode {
            case .course:
                return CGSize(width: view.frame.width, height: 76) // was 100
            case .profile:
                return CGSize(width: view.frame.width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch instructorCellMode {
        case .course:
            
            let course = courses[indexPath.item]
            print(course)
            let preview = PreviewController(collectionViewLayout: UICollectionViewFlowLayout())
            preview.course = course
            
            // It's working to present view controller, but push view controller 
            //present(navigationController, animated: true, completion: nil)
            
            
        case .profile:
            print(indexPath)
            // do nothing
        }
    }
    
    //MARK:- Methods

    func fetchInstructor() {
        
        guard let instructorId = self.course?.info?.instructorId else { return }
        Database.database().reference().child("instructors").child(instructorId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let instructorDict = snapshot.value as? [String: Any] else { return }
            guard let courseArray = instructorDict["courses"] as? [String: Any] else { return }
            
            let instructor = InstructorModel(id: instructorId, dictionary: instructorDict, courseArray: courseArray)
            self.instructor = instructor
            
            instructor.courseArray.forEach({ (key, value) in
                print("key:", key, "value:", value)
                Database.fetchCourseWithId(courseId: key, completion: { (CourseModel) in
                    self.courses.append(CourseModel)
                    
                    self.aiv.stopAnimating()
                    self.overLay.removeFromSuperview()
                    
                    self.collectionView?.reloadData()
                })
            })
        })
    }
    

}


