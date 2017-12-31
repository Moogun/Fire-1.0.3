//
//  PreviewController.swift
//  Fire
//
//  Created by Moogun Jung on 7/23/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

enum CoursePreviewMode {
    case chapters // 목차
    case announcement // 공지
    case qna // 질문-답변
    case reviews //후기
}

var chapterCache = [String: ChapterModel]()

class PreviewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PreviewHeaderDelegate, AnnouncementCellDelegate {
    
    //MARK:- Properties
    var courseInfo: InfoModel? {
        didSet {
        }
    }
    
    var course: CourseModel? {
        didSet {
            //print(course?.info?.instructor ?? "")
            //print(course?.attendee as Any)
        }
    }
    
    let headerId = "headerId"
    
    let aboutCellId = "aboutCellId"
    let announcementCellId = "announcementCellId"
    let cellId = "cellId" // chapter
    let qnaCategoryCellId = "qnaCategoryCellId"
    let moreCellId = "moreCellId"
    
    var chapters = [ChapterModel]()
    
    
    //MARK:- PROTOCOL METHODS 
    
    var coursePreviewMode: CoursePreviewMode = .chapters {
        didSet {
            
            switch self.coursePreviewMode {
            case .announcement:
                collectionView?.reloadData()
                
            case .chapters:
                collectionView?.reloadData()
            
            case .qna:
                collectionView?.reloadData()
            case .reviews:
                collectionView?.reloadData()
            }
        }
    }
    
    func didChangeToAnnouncement() {
        self.coursePreviewMode = .announcement
    }
    
    func didChangeToChapters() {
        self.coursePreviewMode = .chapters
    }

    func didChangeToQna() {
        self.coursePreviewMode = .qna
    }
    
    func didChangeToReviews() {
        self.coursePreviewMode = .reviews
    }
    // --------- --------- --------- Annoucnement Delegate
    
    func deleteAnnouncementButtonDidTap(for cell: AnnouncementCell) {
       
        let title = Text.wantToDelete
        let message = Text.toBeDeletedPermanantly
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: Text.okay, style: .destructive, handler: { (_) in
            self.deleteAnnouncement(cell: cell)
        })
        let cancel = UIAlertAction(title: Text.no, style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteAnnouncement(cell: AnnouncementCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        let announcement = ann[indexPath.item]
        
        guard let courseId = courseInfo?.id else { return }
        let annId = announcement.id
        
        let ref = Database.database().reference()
        ref.child("announcement").child(annId).removeValue()
        ref.child("courses").child(courseId).child("announcement").child(annId).removeValue()
        
        self.ann.remove(at: indexPath.item)
        self.collectionView?.reloadData()
    }
    
    //MARK:- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.isScrollEnabled = true
        
        collectionView?.register(PreviewHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.register(AboutCell.self, forCellWithReuseIdentifier: aboutCellId)
        collectionView?.register(AnnouncementCell.self, forCellWithReuseIdentifier: announcementCellId)
        collectionView?.register(CurriculumCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(QnaCategoryCell.self, forCellWithReuseIdentifier: qnaCategoryCellId)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuestionInfo), name: .newQuestion, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuestionInfo), name: .deleteQuestion, object: nil)
    
        //self.fetchChapters()
        self.paginateChapters()
        self.fetchAnnouncement()
    
        setupNavBar()
    }
    
    func setupNavBar() {
       
        guard let uid = Auth.auth().currentUser?.uid else { return }
    
        if courseInfo?.instructorId == uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Text.newAnnouncement, style: UIBarButtonItemStyle.plain, target: self, action: #selector(newAnnouncement))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    @objc func newAnnouncement() {

        let newAnnouncement = NewAnnouncementController()
        newAnnouncement.courseInfo = courseInfo
        let navController = UINavigationController(rootViewController: newAnnouncement)
        present(navController, animated: true, completion: nil)
        
    }
    
    
    func updateChapters() {
        self.refreshChapters()
    }
    
    func refreshChapters() {
        self.chapters.removeAll()
        // this could be deleted Nov 26 
        self.fetchChapters()
        self.collectionView?.reloadData()
    }

    
    //MARK:- HEADER
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PreviewHeaderCell
        header.courseInfo = courseInfo
        header.delegate = self
    
        return header
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 186) // 202 = 16
        // Nov 10 course image view 120 * 120 top left padding 16,
        //was 222 + 10 when the courseimageview was 150 * 150
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //MARK:- CELL
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch coursePreviewMode {
            
        case .announcement:
            return ann.count
            
        case .chapters:
            inputAccessoryView?.isHidden = true
            return chapters.count
            
        case .qna:
            inputAccessoryView?.isHidden = true
            return chapters.count
            
        case .reviews:
            return 0
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch coursePreviewMode {
            
        case .announcement:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: announcementCellId, for: indexPath) as! AnnouncementCell
            cell.announcement = ann[indexPath.item]
            cell.delegate = self
            return cell
            
        case .chapters:
            
            if indexPath.item == self.chapters.count - 1 && isFinishedPaging == false {
                print("paginate", "isFinishedPaging", isFinishedPaging)
                paginateChapters()
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CurriculumCell
            cell.numberLabel.text = "\(indexPath.item + 1)"
            cell.chapter = chapters[indexPath.item]
            return cell
            
        case .qna:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: qnaCategoryCellId, for: indexPath) as! QnaCategoryCell
            cell.numberLabel.text = "\(indexPath.item + 1)"
            cell.chapter = chapters[indexPath.item]
            return cell
            
        case .reviews:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: moreCellId, for: indexPath)
            cell.backgroundColor = .blue
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch coursePreviewMode {
            case .announcement:

                let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
                let dummyCell = AnnouncementCell(frame: frame)
                dummyCell.announcement = ann[indexPath.item]
                //dummyCell.question = questions[indexPath.item]
                dummyCell.layoutIfNeeded()
                
                let targetSize = CGSize(width: view.frame.width, height: 1000)
                let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
                
                let height = max(40 + 8 + 8, estimatedSize.height)
                return CGSize(width: view.frame.width, height: height)
                
                //return CGSize(width: view.frame.width, height: 80)
            
            case .chapters:
            
                return CGSize(width: view.frame.width, height: 60)
            
            case .reviews:
                return CGSize(width: view.frame.width, height: 40)
            
            case .qna:
                return CGSize(width: view.frame.width, height: 40)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            switch coursePreviewMode {
                case .announcement:
                    print("announcement")

                case .chapters:
                     //print(12313)
                    let chapter = chapters[indexPath.item]
                    didTapChapter(chapter: chapter)
                
                case .qna:
                    let chapter = chapters[indexPath.item]
                    checkIfUserEnrolled(chapter: chapter)
//                    guard let uid = Auth.auth().currentUser?.uid else { return }
//
//                    if course?.attendee?.index(forKey: uid) != nil {
//                        let chapter = chapters[indexPath.item]
//                        didTapQna(chapter: chapter)
//                    } else {
//                        alertView1(message: "Please add this course to view")
//                    }

                case .reviews:
                    print(1)
        }
    }
    
    func checkIfUserEnrolled(chapter: ChapterModel) {
      
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let courseId = courseInfo?.id else { return }
        Database.database().reference().child("courses").child(courseId).child("attendee").child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
            if snapshot.exists(){
                self.hasEnrolled = true
                self.didTapQna(chapter: chapter)
                
            } else {
                self.hasEnrolled = false
                 self.alertView1(message: "Please add this course to view")
            }
        }
    }
    
    //MARK:- NETWORK
    var isFinishedPaging = false
    var startIndex = 0
    let perFetching = 5
    
    func paginateChapters() {
        
        guard let courseId = self.courseInfo?.id else { return }
        Database.database().reference().child("courses").child(courseId).child("chapters").observeSingleEvent(of: .value) { (snapshot) in
            
            let allObj = snapshot.children.allObjects as? [DataSnapshot]
            guard let count = allObj?.count else { return }
            //print("start index initial", self.startIndex)
           
            // 1. check whether startIndex + perFethcing is larger than allObj.count, if yes, set isFinishPaging to true and stop fethcing
            if (self.startIndex + self.perFetching) - count > 0 {
                
                let remainder = count - self.startIndex
                let endIndex = self.startIndex + remainder
                let lastChapters = allObj?[self.startIndex ..< endIndex]
                
                lastChapters?.forEach({ (snapshot) in
                    Database.fetchChaptersWithId(id: snapshot.key, completion: { (ChapterModel) in
                        
                        self.chapters.append(ChapterModel)
                        self.chapters.sort(by: { (p1, p2) -> Bool in
                            p1.title.compare(p2.title) == .orderedAscending
                        })
                        self.collectionView?.reloadData()
                    })
                })
                self.isFinishedPaging = true
            }
            
            if !self.isFinishedPaging {

                //2. fetching chapters
                //print("start index 2", self.startIndex, self.isFinishedPaging)
                let every5 = allObj?[self.startIndex ..< self.startIndex + self.perFetching]
                
                self.startIndex += self.perFetching
                //print("start index 3", self.startIndex)
                every5?.forEach({ (snapshot) in
                    //print("every 5 of each", snapshot.key, snapshot.value)
                    if let cachedChapterModel = chapterCache[snapshot.key] {
                        self.chapters.append(cachedChapterModel)
                        self.chapters.sort(by: { (p1, p2) -> Bool in
                            p1.title.compare(p2.title) == .orderedAscending
                        })
                        self.collectionView?.reloadData()
                        return
                    }
                    
                    
                    Database.fetchChaptersWithId(id: snapshot.key, completion: { (ChapterModel) in
                        chapterCache[snapshot.key] = ChapterModel
                        
                        self.chapters.append(ChapterModel)
                        self.chapters.sort(by: { (p1, p2) -> Bool in
                            p1.title.compare(p2.title) == .orderedAscending
                        })
                        self.collectionView?.reloadData()
                    })
                })

            }
            
            
        }
    }

    
    func fetchChapters() {
        
        guard let courseId = self.courseInfo?.id else { return }
        
        Database.database().reference().child("courses").child(courseId).child("chapters").observeSingleEvent(of: DataEventType.value) { (snapshot) in

            guard let chapterDict = snapshot.value as? [String: Any] else { return }
            chapterDict.forEach({ (key, value) in

                if let cachedChapterModel = chapterCache[key] {
                    self.chapters.append(cachedChapterModel)
                    self.chapters.sort(by: { (p1, p2) -> Bool in
                        p1.title.compare(p2.title) == .orderedAscending
                    })
                    self.collectionView?.reloadData()
                    return
                }

                Database.fetchChaptersWithId(id: key, completion: { (ChapterModel) in

                    chapterCache[key] = ChapterModel

                    self.chapters.append(ChapterModel)
                    self.chapters.sort(by: { (p1, p2) -> Bool in
                        p1.title.compare(p2.title) == .orderedAscending
                    })

                    self.collectionView?.reloadData()
                })

            })

        }
        
    }
          
    
    @objc func updateQuestionInfo(_ notification: Notification) {
        
        guard let myDict = notification.object as? [String: Any] else { return }
        guard let chapterId = myDict["chapterId"] as? String else { return }
        
        Database.fetchChaptersWithId(id: chapterId, completion: { (ChapterModel) in
            
            if let i = self.chapters.index(where: { $0.id == chapterId}) {
                self.chapters.remove(at: i)
                
                self.chapters.append(ChapterModel)
                self.chapters.sort(by: { (p1, p2) -> Bool in
                    p1.title.compare(p2.title) == .orderedAscending
                })
                self.collectionView?.reloadData()
            }
        })
    }
    
    var ann = [AnnouncementModel]()
    
    func fetchAnnouncement() {

        guard let courseId = self.courseInfo?.id else { return }
        guard let instructorId = self.courseInfo?.instructorId else { return }
        Database.database().reference().child("courses").child(courseId).child("announcement").observe(DataEventType.childAdded, with: { (snapshot) in
            
            //print("announcement:",snapshot.key, snapshot.value)
            
                Database.fetchAnnWithId(instructorId: instructorId, id: snapshot.key, completion: { (AnnouncementModel) in
                    //print(AnnouncementModel)

                    self.ann.append(AnnouncementModel)
                    self.ann.sort(by: { (p1, p2) -> Bool in
                        p1.id.compare(p2.id) == .orderedAscending
                    })
                    self.collectionView?.reloadData()
                })
//            })
            
        }) { (err) in
            print(err)
        }
        
    }
    
    //MARK:- MORE OPTIONS

    var hasEnrolled: Bool = false
    
    func didTapMoreOptions() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let courseId = courseInfo?.id else { return }
        Database.database().reference().child("courses").child(courseId).child("attendee").child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
            if snapshot.exists(){
                self.hasEnrolled = true
                print(self.hasEnrolled)
                self.moreForMyCourse()
            } else {
                self.hasEnrolled = false
                print(self.hasEnrolled)
                self.moreOptions()
            }
        }
        
    }
    
    func moreOptions() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "공유하기", style: .default, handler: { (_) in
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func moreForMyCourse() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "공유하기", style: .default, handler: { (_) in
            
            let text = ["http://www.toomtoome.com"]
                let activityVC = UIActivityViewController(activityItems: text, applicationActivities: [])
                activityVC.popoverPresentationController?.sourceView = self.collectionView
                self.present(activityVC, animated: true, completion: nil)
            
            }
        ))
        
        alertController.addAction(UIAlertAction(title: "수업을 삭제하시겠습니까?", style: .destructive, handler: { (_) in
            
                guard let courseId = self.courseInfo?.id else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
            
                let ref = Database.database().reference()
                ref.child("followingCourses").child(uid).child(courseId).removeValue(completionBlock: { (err, ref) in
                    if err != nil {
                        print("err removing a course:", err as Any, "reference:", ref)
                    }
                    
                })
            
                ref.child("courses").child(courseId).child("attendee").child(uid).removeValue(completionBlock: { (err, ref) in
                    if err != nil {
                        print("err removing a course:", err as Any, "reference:", ref)
                    }
                })
            
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .updateLibrary, object: nil)
            
            }
            
        ))
        
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
        )
        
        present(alertController, animated: true, completion: nil)
        
    }
 
    //MARK: NAVIGATING TO ANOTHER VIEW CONTROLLERS
    
    func didTapChapter(chapter: ChapterModel) {
        let keywordController = KeywordController()
        keywordController.chapter = chapter
        
        let navController = UINavigationController(rootViewController: keywordController)
        present(navController, animated: true, completion: nil)
        
    }
    
    func didTapQna(chapter: ChapterModel) {
        let layoutCourseAbout = UICollectionViewFlowLayout()
        let questionListController = QuestionListController(collectionViewLayout: layoutCourseAbout)
        questionListController.chapter = chapter
        
        let questionNavController = UINavigationController(rootViewController: questionListController)
        present(questionNavController, animated: true, completion: nil)
        
    }
    
    func didTapInstructor() {
        let layoutInstructor = UICollectionViewFlowLayout()
        let instructorController = InstructorController(collectionViewLayout: layoutInstructor)
        instructorController.course = self.course
        present(instructorController, animated: true, completion: nil)
    }

}


