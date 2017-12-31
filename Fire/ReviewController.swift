//
//  ReviewController.swift
//  Fire
//
//  Created by Moogun Jung on 8/12/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class ReviewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var courseInfo: InfoModel?
    let cellId = "cellId"
    
    //MARK:- life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Review"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- data source, delegate
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReviewCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        //return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = ReviewCell(frame: frame)
        //dummyCell.question = questions[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    //MARK:- inputView
    
    let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "How was this course?"
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return textField
    }()
    
    let submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.lightGray, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.isEnabled = false
        submitButton.backgroundColor = .white
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return submitButton
    }()
    
    let ratingView: CosmosView = {
        let cosmos = CosmosView()
        cosmos.rating = 0
        cosmos.settings.starSize = 13 + 17
        cosmos.settings.starMargin = 4
        cosmos.settings.fillMode = .half
        cosmos.settings.filledImage = #imageLiteral(resourceName: "star")
        cosmos.settings.emptyImage = #imageLiteral(resourceName: "starBlank")
        return cosmos
    }()
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 90)
        
        containerView.addSubview(self.ratingView)
        self.ratingView.anchor(top: containerView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.ratingView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.addSubview(self.submitButton)
        self.submitButton.anchor(top: self.ratingView.bottomAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        containerView.addSubview(self.textField)
        self.textField.anchor(top: self.ratingView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: self.submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        
        containerView.addSubview(seperatorView)
        seperatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK:- Actions
    
    @objc func validateForm() {
        
        guard let text = textField.text else { return }

        if !text.isEmpty, text.count > 0 {
            self.submitButton.setTitleColor(.blue, for: .normal)
            self.submitButton.isEnabled = true
        } else {
            self.submitButton.setTitleColor(.lightGray, for: .normal)
            self.submitButton.isEnabled = false
        }
    }
    
    @objc func handleSubmit() {
        
        print(textField.text ?? "", self.courseInfo!.id)
        
        guard let courseId = self.courseInfo?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let value = ["question": textField.text ?? "", "createdAt": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        Database.database().reference().child("questions").child(courseId).childByAutoId().updateChildValues(value) { (err, ref) in
            
            self.textField.text = ""
            self.submitButton.isEnabled = false
            self.submitButton.setTitleColor(.lightGray, for: .normal)
            
            if err != nil {
                print("Failed to add new question into the node", err as Any)
            }
            print("Successful")
        }
    }
    
    //MARK:- network
    
}



