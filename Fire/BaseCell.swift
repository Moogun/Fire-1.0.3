//
//  LibraryCell.swift
//  Fire
//
//  Created by Moogun Jung on 12/29/16.
//  Copyright © 2016 Moogun. All rights reserved.
//

import UIKit

//BaseCell

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
