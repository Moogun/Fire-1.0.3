//
//  NewAnnouncement.swift
//  Fire
//
//  Created by Moogun Jung on 11/15/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class NewAnnouncementController: UIViewController, UITextViewDelegate {
    
    //MARK:- Properties
    var courseInfo: InfoModel? {
        didSet {
        }
    }
    
    //MARK:- Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        //label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = "새 공지사항을 작성해주세요"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    
    let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let announcementTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textContainerInset = UIEdgeInsetsMake(8, 12, 8, 12)
        return tv
    }()
    
    lazy var saveAnnouncementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveAnnouncementButtonDidTap), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    //MARK:- LIFE CYCLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 242)
        
        navigationItem.title = "새 공지"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveAnnouncementButtonDidTap))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.setupTextViews()
        
        announcementTextView.delegate = self
        announcementTextView.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        containerViewBottomConstraint?.constant = -keyboardFrame!.height
    }
    
    //MARK:- LAYOUTS
    
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    func setupTextViews() {
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingBottom: 0, paddingRight: -10, width: 0, height: 0)
        
        view.addSubview(subTitleLabel)
        subTitleLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(containerView)
        containerView.anchor(top: subTitleLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        containerViewBottomConstraint?.isActive = true
        
        containerView.addSubview(announcementTextView)
        announcementTextView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0) // left 8
        
    }
    
    //MARK:- METHODS
    
    var isTextViewUpdated: Bool = false
    
    // to save
    
    func textViewDidChange(_ textView: UITextView) {
        print("plain:",textView.text)
        
        if !textView.text.isEmpty {
            isTextViewUpdated = true
            print("is not empty:", textView)
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            isTextViewUpdated = false
            print("is empty:",textView.text)
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    // need to fix announcement fethcing logic
    // 1. keep created at and title
    // 2. when fetching announcement, get instructor id, announcement list in the course,
    // 3. fetch user info and add to announcemnt obj
    
    @objc func saveAnnouncementButtonDidTap() {
        guard let courseId = courseInfo?.id else { return         }
        guard let announcement = announcementTextView.text, announcement.count > 0 else { return }
        
        let newKey = Database.database().reference().childByAutoId().key
        let ref = Database.database().reference()
        
        let value = ["title": announcement, "createdAt": Date().timeIntervalSince1970] as [String: Any]
        let childUpdates = ["/announcement/\(newKey)": value,
                            "/courses/\(courseId)/announcement/\(newKey)": 1] as [String : Any]
        
        ref.updateChildValues(childUpdates) { (err, ref) in
            if err != nil {
                print(err as Any)
                return
            }
            
            print("successfully saved to announcement")
            self.alertView1(message: Text.saved)
            //do something to dismiss view controller
        }
    }
    
    @objc func dismissController() {
        if isTextViewUpdated {
            alertDiscard()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func alertDiscard() {
        
        let alertController = UIAlertController(title: "저장하지 않은 데이터", message: "변경한 내용을 저장하지 않고 종료하시겠습니까?", preferredStyle: .alert)
        
        let no = UIAlertAction(title: "No", style: .cancel, handler: { (_) in
        })
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(no)
        alertController.addAction(yes)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func cancelButtonDidTap() {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
}
