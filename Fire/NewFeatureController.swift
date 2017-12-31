//
//  NewFeatureController.swift
//  Fire
//
//  Created by Moogun Jung on 10/28/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class NewFeatureController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = "추가 예정 기능 목록"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 13)
        //textView.textAlignment = .justified
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular), NSAttributedStringKey.paragraphStyle : paragraphStyle]
        
        
        let list = " \u{2022} 내 질문에 대한 답변 알림, \n \u{2022} 질문 답변에 대한 재 댓글, \n \u{2022} 수업 후기 작성 기능 \n \u{2022} 다른 사람 질문 저장 후 나중에 확인하기,  \n \u{2022} 수업 자료 (PDF, 사진) 등 공유 기능,  \n \u{2022} 실시간 채팅 기능 등 "
        
        textView.attributedText = NSMutableAttributedString(string: list, attributes: attributes)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(detailTextView)
        
        titleLabel.anchor(top: self.topLayoutGuide.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        detailTextView.anchor(top: titleLabel.bottomAnchor, left: self.titleLabel.leftAnchor, bottom: nil, right: self.titleLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
    }
    
}
