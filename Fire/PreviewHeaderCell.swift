//
//  PreviewHeaderCell.swift
//  Fire
//
//  Created by Moogun Jung on 4/27/17.
//  Copyright © 2017 Moogun. All rights reserved.
//


import UIKit 
import Firebase

protocol PreviewHeaderDelegate {
    func didChangeToChapters()
    func didChangeToAnnouncement()
    func didChangeToQna()
    func didChangeToReviews()
    
    func didTapInstructor()
    func didTapMoreOptions()
}

class PreviewHeaderCell: BaseCell {
   
    //MARK:- Properties
    
    var delegate: PreviewHeaderDelegate?
    
    var courseInfo: InfoModel? {
        didSet {
            self.courseImageView.image = #imageLiteral(resourceName: "chapter")
            if let courseImageUrl = courseInfo?.courseImageUrl, !courseImageUrl.isEmpty {
                courseImageView.loadImage(urlString: courseImageUrl)
            }
            self.titleLabel.text = courseInfo?.title
            self.instructorLabel.text = courseInfo?.instructor
            
            self.setUpCourseStatus()
        }
    }
    
    //var courseRemoved: (() -> Void)?
    
    //MARK:- Top section
    
    let courseImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "chapter")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    lazy var instructorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        //label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInst)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    @objc func handleInst() {
        delegate?.didTapInstructor()
    }
    
    //MARK:- Add course section
    lazy var addCourseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleAddCourse), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    
    @objc func handleAddCourse() {
        
        guard let courseId = self.courseInfo?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference()
        
        let valueUpdates: [String: Any] = ["followingCourses/\(uid)/\(courseId)":1, "courses/\(courseId)/attendee/\(uid)":1]
        ref.updateChildValues(valueUpdates, withCompletionBlock: { (err, ref) in
            NotificationCenter.default.post(name: .updateLibrary, object: nil)
            self.setupAddedButton()
        })
        
        ref.child("courses").child(courseId).child("info").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            
            if var info = currentData.value as? [String : AnyObject] {

                var attendeeCount = info["attendeeCount"] as? Int ?? 0
                //print(attendeeCount)
                attendeeCount += 1
                //print(attendeeCount)
                info["attendeeCount"] = attendeeCount as AnyObject?
                //print(info["attendeeCount"] )
                
                currentData.value = info
                
                //print("transactional data",TransactionResult.success(withValue: currentData))
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    fileprivate func setupAddButton() {
        self.addCourseButton.setTitle("Add", for: .normal)
        self.addCourseButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.addCourseButton.setTitleColor(.white, for: .normal)
        self.addCourseButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func setupAddedButton() {
        self.addCourseButton.setTitle("Added", for: .normal)
        self.addCourseButton.backgroundColor = UIColor.white
        self.addCourseButton.setTitleColor(UIColor.rgb(red: 17, green: 154, blue: 237), for: .normal)
        self.addCourseButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.addCourseButton.isEnabled = false
    }
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        button.setTitle("•••", for: .normal)
        return button
    }()
    
    @objc func handleMore() {
        delegate?.didTapMoreOptions()
    }

    //MARK:- Middle section
    
    lazy var announcementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공지사항", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .left
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(announcementButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    lazy var chapterButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.setTitle("커리큘럼", for: .normal)
        button.titleLabel?.font = Text.previewMenuFont
        button.addTarget(self, action: #selector(chapterButtonDidTap), for: .touchUpInside)
        return button
    }()

    lazy var qnaButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("질문답변", for: .normal)
        button.titleLabel?.font = Text.previewMenuFont
        button.contentHorizontalAlignment = .left
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(qnaButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    lazy var reviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("후기", for: .normal)
        button.titleLabel?.font = Text.previewMenuFont
        button.contentHorizontalAlignment = .left
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(reviewButtonDidTap), for: .touchUpInside)
        return button
    }()
  
    func setUpCourseStatus() {
        
        guard let courseId = self.courseInfo?.id else { return }
        print(courseId)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference()
        ref.child("followingCourses").child(uid).child(courseId).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value)
            if let isAdded = snapshot.value as? Int, isAdded == 1 {
                //print("added already")
            } else {
                self.setupAddButton()
            }
            
        }) { (error) in
            print (error)
        }
    }
    
    
    //MARK: Mode
    
    var previewButtonMode: CoursePreviewMode = .chapters {
        didSet {
            
            switch self.previewButtonMode {
                
            case .chapters:
                
                chapterButton.tintColor = self.tintColor
                announcementButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                qnaButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                reviewButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                
            case .announcement:
                
                chapterButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                announcementButton.tintColor = self.tintColor
                qnaButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                reviewButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                
            case .qna:
                
                chapterButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                announcementButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                qnaButton.tintColor = self.tintColor
                reviewButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                
            case .reviews:
                
                chapterButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                announcementButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                qnaButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
                reviewButton.tintColor = self.tintColor
                
            }
        }
    }
    
    @objc func announcementButtonDidTap() {
        previewButtonMode = .announcement
        delegate?.didChangeToAnnouncement()
    }
    
    @objc func chapterButtonDidTap() {
        previewButtonMode = .chapters
        delegate?.didChangeToChapters()
    }
    
    @objc func qnaButtonDidTap() {
        previewButtonMode = .qna
        delegate?.didChangeToQna()
    }
    
    @objc func reviewButtonDidTap() {
        previewButtonMode = .reviews
        delegate?.didChangeToReviews()
    }
    
  
    // MARK:- Layouts
    
    override func setupViews() {
        
        addSubview(courseImageView)
        courseImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: courseImageView.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: courseImageView.rightAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        addSubview(instructorLabel)
        instructorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        instructorLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true
        
        addSubview(addCourseButton)
        addCourseButton.anchor(top: nil, left: courseImageView.rightAnchor, bottom: courseImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
        
        addSubview(moreButton)
        moreButton.anchor(top: nil, left: nil, bottom: courseImageView.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 50, height: moreButton.frame.height)
        
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.white
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        let stackView = UIStackView(arrangedSubviews: [announcementButton, chapterButton, qnaButton]) //, reviewButton
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: self.courseImageView.bottomAnchor, left: courseImageView.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
}
