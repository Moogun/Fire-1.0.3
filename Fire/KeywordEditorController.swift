//
//  KeywordViewController.swift
//  Fire
//
//  Created by Moogun Jung on 4/3/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class KeywordEditorController: UICollectionViewController {
    
    var keyword: Keyword_Model? {
        didSet {
         
        }
    }
    
    let cellId = "cellId"
    let noteCellId = "noteCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        
        self.collectionView?.register(KeywordEditorViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.register(KeywordEditorNoteCell.self, forCellWithReuseIdentifier: noteCellId)
        
    }
    
}

// image

extension KeywordEditorController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 1 {
            return 2
        }
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: noteCellId, for: indexPath) as! KeywordEditorNoteCell
            cell.backgroundColor = .white
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! KeywordEditorViewCell
        cell.keyword = keyword 
        cell.backgroundColor = .yellow
        return cell
    }
    
}

extension KeywordEditorController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section  == 1 {
            return CGSize(width: collectionView.frame.width, height: 60)
        }

        return CGSize(width: collectionView.frame.width, height: 400)
    }
}
