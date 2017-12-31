//
//  FeaturedController.swift
//  Fire
//
//  Created by Moogun Jung on 6/6/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class FeaturedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var featuredCategory : Featured_Model?
    var courseCategories = [Category_Model]()

    
    //MARK:- life cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Featured"
        collectionView?.backgroundColor = .white
        
        collectionView?.register(FeaturedHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(FeaturedCell.self, forCellWithReuseIdentifier: cellId)
        
        Database.featured(completion: {(abc) -> () in
            self.featuredCategory = abc
            self.courseCategories = (self.featuredCategory?.courseCategories)!
            self.collectionView?.reloadData()
        })
    
//        Database.category(completion: { (Category_Model) -> () in
//            self.courseCategories.append(Category_Model)
//            self.collectionView?.reloadData()
//        })
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
    //MARK:- data source and delegate
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 200 + 30 + 100)
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! FeaturedHeaderCell
//        header.category = self.featuredCategory?.banners
//        return header
//    }

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 2
        return courseCategories.count
     
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeaturedCell
        cell.category = courseCategories[indexPath.item]
        return cell
        
        
//        let cell: CategoryCell
//        
//        if indexPath.item == 2 {
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! LargeCategoryCell
//        } else {
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
//        }
//        cell.appCategory = appCategories?[indexPath.item]
//        cell.featuredAppsController = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
        
//        if indexPath.item == 2 {
//            return CGSize(width: view.frame.width, height: 160)
//        }

    }
}


   
