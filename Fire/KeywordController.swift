//
//  KeywordController.swift
//  CollectionViewTest
//
//  Created by Moogun Jung on 1/30/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class KeywordController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, KeywordCellDelegate {
    
    // MARK: - Properties
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var chapterId: String?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let cellId = "cellId"
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor.rgb(red: 247, green: 154, blue: 27)
        return pc
    }()
    
    var chapter: ChapterModel? {
        didSet {
            
            if let count = chapter?.keywords.count {
                if count % 10 == 0 {
                    pageControl.numberOfPages = count / 10
                } else {
                    pageControl.numberOfPages = count / 10 + 1
                }
            }
        }
    }
    
    //var currentKeyword: Keyword? // core data keyword
    
    var keywords = [KeywordModel]()
    
    //MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //collectionView.backgroundColor = .orange
        
        self.collectionView.isScrollEnabled = true
        self.collectionView.allowsSelection = true
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: cellId)
        
     
        view.addSubview(collectionView)
        collectionView.anchor(top: self.topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(pageControl)
        pageControl.anchor(top: collectionView.bottomAnchor, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        self.setupNavBar()
        self.fetchAllKeyword()
        
    }
    
    func setupNavBar() {
        //self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationItem.title = self.chapter?.title //Nov 15; was chapter title
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        //print(pageNumber)
        pageControl.currentPage = pageNumber
    }
    
    // fetching and refreshing pattern
    
    func updateKeyword() {
        self.refreshKeyword()
    }
    
    func refreshKeyword() {
        self.keywords.removeAll()
        self.fetchAllKeyword()
        self.collectionView.reloadData()
    }
    
    func fetchAllKeyword() {
        self.fetchKeyword()
    }
    
    //MARK:- CELL
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! KeywordCell
        cell.delegate = self
        
        let attributedText = NSMutableAttributedString(string: "\(indexPath.item + 1)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        cell.indexLabel.attributedText = attributedText
        cell.keyword = keywords[indexPath.item]
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        //cell.backgroundColor = .yellow
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = (collectionView.frame.height) / 10 // Nov 21 -view.frame.height - 50 shows 8 cells in 7 and 9 cells in 7 & minimum line spacing shows not 0 so changed it to collectionview.frame.height
        return CGSize(width: view.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func checkedKeyword(for cell: KeywordCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var keyword = self.keywords[indexPath.item]
        let keywordId = keyword.id
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Keyword> = Keyword.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", keywordId)
        
        do {
            let results = try managedContext.fetch(request)
            var currentKeyword = results.first
            
            keyword.hasChecked = !keyword.hasChecked
            currentKeyword?.setValue(keyword.hasChecked, forKey: "hasChecked")
  
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    
        //keyword.hasChecked = !keyword.hasChecked
        self.keywords[indexPath.item] = keyword
        self.collectionView.reloadItems(at: [indexPath])
    }
}


//MARK:- Network, Navigation
//var keywordCache = [String: KeywordModel]()

extension KeywordController {
    
    func fetchKeyword() {
        
        guard let keywords = chapter?.keywords else { return }
        
        keywords.forEach { (key, value) in
            //print("q list key:", key, "value:", value)
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let keywordKey = key
            let fetch : NSFetchRequest<Keyword> = Keyword.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %@", keywordKey)
            
            do {
                // check if keyword was already saved in core data
                let count = try managedContext.count(for: fetch)

                if count > 0 {
                    //print("fetch:", count)
                    
                    // fetch keyword and convert it to keyword model and append it to the array
                    
                        let request: NSFetchRequest<Keyword> = Keyword.fetchRequest()
                        let keywordKey = key
                        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Keyword.id), keywordKey])
                
                        do {
                            let results = try managedContext.fetch(request)
                            //print("results", results)
                            
//                            var abc = results.first
//                            print("check core data before fethcing db:",abc?.value(forKey: "keyword"), abc?.value(forKey: "hasChecked"), abc?.value(forKey: "eg_1"))
                            
                            populate(keyword: results.first!)
                
                        } catch let error as NSError {
                            print("Could not fetch \(error), \(error.userInfo)")
                        }
                    
                    return
                }
            } catch let error as NSError {
                print("Fatal Error: \(error.localizedDescription)")
            }
            
            //No previously opened keyword
            
            let ref = Database.database().reference().child("keywords").child(key)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let keywordDict = snapshot.value as? [String: Any] else { return }
                let keyword = KeywordModel(id: snapshot.key, dictionary: keywordDict)
                
                //SAVING DATA INTO CORE DATA
                    let entity = NSEntityDescription.entity(forEntityName: "Keyword", in: managedContext)!
                    let word = Keyword(entity: entity,insertInto: managedContext)
                
                        word.id = keyword.id
                
                        word.language = keyword.language
                        word.chapterId = keyword.chapterId
                
                        word.keyword = keyword.keyword
                        word.pronunciation = keyword.pronunciation
                
                        word.meaning_1 = keyword.meaning_1
                        word.eg_1 = keyword.eg_1
                        word.egMeaning_1 = keyword.egMeaning_1
                        word.egPronun_1 = keyword.egPronun_1

                        word.meaning_2 = keyword.meaning_2
                        word.eg_2 = keyword.eg_2
                        word.egMeaning_2 = keyword.egMeaning_2
                        word.egPronun_2 = keyword.egPronun_2
                
                        word.keywordImageUrl = keyword.keywordImageUrl
                        word.note = keyword.note
                        //word.createdAt = keyword.createdAt
//                        print("fetching from db", keyword.hasChecked)
                        word.hasChecked = keyword.hasChecked
//                        print("after fethcing from db", word.hasChecked)
                        word.noteAdded = keyword.noteAdded
                
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                
                //POPULATING DATA INTO KEYWORDS ARRAY
                self.keywords.append(keyword)
                self.keywords.sort(by: { (p1, p2) -> Bool in
                    return p1.id.compare(p2.id) == .orderedAscending
                })
    
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
                
            }) { (err) in
                print(err, "error occured")
            }
        }
    }
    
    func populate(keyword: Keyword) {
        
        guard let keywordId = keyword.id else { return }
        //print("populate:", keywordId, keyword.keyword, keyword.hasChecked, keyword.eg_1, keyword.eg_2)
        
        var dict: [String: Any] = ["language": keyword.language ?? "",
                                   "chapterId": keyword.chapterId ?? "",
                                   "keyword": keyword.keyword ?? "",
                                   
                                   "meaning_1": keyword.meaning_1 ?? "",
                                   "eg_1": keyword.eg_1 ?? "",
                                   "egMeaning_1": keyword.egMeaning_1 ?? "",
                                   "egPronun-1": keyword.egPronun_1 ?? "",
                                   
                                   "hasChecked": keyword.hasChecked
//                                "hasChecked": true
//                                   "pronunciation": keyword.pronunciation ?? "",
//                                   "meaning_2": keyword.meaning_2 ?? "",
//                                   "eg_2": keyword.eg_2 ?? "",
//                                   "egMeaning_2": keyword.egMeaning_2 ?? "",
//                                   "egPronun_2": keyword.egPronun_2 ?? "",
                                   ]
//        print("dict", dict["keyword"], dict["hasChecked"])
        
        if let pronunciation = keyword.pronunciation {
            dict["pronunciation"] = pronunciation
        }
        
        if let meaning_2 = keyword.meaning_2 {
            dict["meaning_2"] = meaning_2
        }
        
        if let eg_2 = keyword.eg_2 {
            dict["eg_2"] = eg_2
        }
        
        if let egMeaning_2 = keyword.egMeaning_2 {
            dict["egMeaning_2"] = egMeaning_2
        }
        
        if let egPronun_2 = keyword.egPronun_2 {
            dict["egPronun_2"] = egPronun_2
        }
        
//        print("before populating", dict["keyword"], dict["hasChecked"], dict["eg_1"], dict["eg_2"])
        let word = KeywordModel(id: keywordId, dictionary: dict)
//        print("after populating", word.keyword, word.hasChecked, word.eg_1)
        
        self.keywords.append(word)
        
        self.keywords.sort(by: { (p1, p2) -> Bool in
            return p1.id.compare(p2.id) == .orderedAscending
        })
        
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }

}

// CORE OBJECT DELETION METHOD
/*
 let managedContext = appDelegate.persistentContainer.viewContext
 
 let request: NSFetchRequest<Keyword> = Keyword.fetchRequest()
 //
 //        do {
 //
 let results = try? managedContext.fetch(request)
 //print("results:",results)
 
 for obj in results! {
 print("obj", obj)
 managedContext.delete(obj)
 }
 
 do {
 try managedContext.save() // <- remember to put this :)
 } catch {
 // Do something... fatalerror
 }
 */
