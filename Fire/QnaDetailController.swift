//
//  QnaDetailController.swift
//  Fire
//
//  Created by Moogun Jung on 9/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

protocol QnaDetailControllerDelegate {
    func saveFollowedQuestion(questionId: String, questionHasFollowed: Bool)
    func saveLikedQuestion(questionId: String, questionHasLiked: Bool)
}

class QnaDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout, QnaDetailCellDelegate, QnaDetailHeaderDelegate {
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var question: QuestionModel?
    var answers = [AnswerModel]()
    
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(QnaDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(QnaDetailCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavBar()
        
        setupKeyboardObservers()
        fetchAnswers()
        
    }
    
    func setupNavBar() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if uid == self.question?.uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonDidTap))
        } 
    }
    
    //MARK:- HEADER: QESTION
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! QnaDetailHeader
        header.question = self.question
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell =  QnaDetailHeader(frame: frame)
        dummyCell.question = self.question
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max (50, estimatedSize.height)
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    //MARK:- CELL ANSWER
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! QnaDetailCell
        cell.answer = answers[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell =  QnaDetailCell(frame: frame)
        dummyCell.answer = self.answers[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max (50, estimatedSize.height)
        
        return CGSize(width: self.view.frame.width, height: height)
        
//        return CGSize(width: self.view.frame.width, height: 100)
    }
    
    //MARK:- INPUT VIEW
    
        let textField : UITextField = {
            let textField = UITextField()
            textField.placeholder = "Write your response"
            textField.addTarget(self, action: #selector(validateForm), for: .editingChanged)
            return textField
        }()
    
        let submitButton: UIButton = {
            let submitButton = UIButton(type: .system)
            submitButton.setTitle("Submit", for: .normal)
            submitButton.setTitleColor(.lightGray, for: .normal)
            submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            submitButton.isEnabled = false
            submitButton.addTarget(self, action: #selector(submitAnswerButtonDidTap), for: .touchUpInside)
            return submitButton
        }()
    
    
        lazy var containerView: UIView = {
            let containerView = UIView()
            containerView.backgroundColor = .white
            containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    
            containerView.addSubview(self.submitButton)
            self.submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
    
            containerView.addSubview(self.textField)
            self.textField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: self.submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    
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

    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        //
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if answers.count > 0 {
            let indexPath = IndexPath(item: answers.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }

    
    //MARK:- METHODS FOR EVERYONE
    
    func fetchAnswers() {
        
        guard let questionId = self.question?.id else { return }
        Database.database().reference().child("answers").child(questionId).observe( DataEventType.childAdded, with: { (snapshot) in
            
            guard let answerDict = snapshot.value as? [String:Any] else { return }
            guard let uid = answerDict["uid"] as? String else { return }
            
            Database.fetchUserWithUID(uid: uid, completion: { (UserModel) in
                let answer = AnswerModel(id: snapshot.key, user: UserModel, dictionary: answerDict)
                self.answers.append(answer)
                self.collectionView?.reloadData()
                
                let indexPath = IndexPath(item: self.answers.count - 1, section: 0)
                //self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            })
            
        }) { (err) in
            print(err)
        }
    }
    
    //MARK:- QUESTION METHODS
    
    @objc func deleteButtonDidTap() {
        let title = Text.wantToDelete
        let message = Text.toBeDeletedPermanantly
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: Text.okay, style: .destructive, handler: { (_) in
            self.deleteQuestion()
        })
        let cancel = UIAlertAction(title: Text.no, style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteQuestion() {
        
        guard let chapterId = self.question?.chapterId else { return }
        guard let questionId = self.question?.id else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference()
        ref.child("chapters").child(chapterId).child("questions").child(questionId).removeValue()
        ref.child("questions").child(questionId).removeValue()
        ref.child("users").child(uid).child("questions").child(questionId).removeValue()
        
        let object = ["questionId": questionId, "chapterId": chapterId]
        
        NotificationCenter.default.post(name: .deleteQuestion, object: object)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func followQuestion() {
        
        guard let questionId = question?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let questionerId = question?.uid else { return }
        
        if questionerId == uid {
            questionAlertView(message: Text.myQuestion)
        } else {
        
            let ref = Database.database().reference()
            let childUpdates = ["/users/\(uid)/questionHasFollowed/\(questionId)": question?.hasFollowed == true ? 0 : 1,
                                "/questionHasFollowed/\(uid)/\(questionId)": question?.hasFollowed == true ? 0 : 1]
            
            ref.updateChildValues(childUpdates) { (err, _) in
                if let err = err {
                    print("Failed to like question:", err)
                    return
                }
                self.question?.hasFollowed = !(self.question?.hasFollowed)!
                self.questionAlertView(message: self.question?.hasFollowed == true ? Text.bookmark : Text.bookmarkCancel)
                
                //notify q list
                self.updateFollowedQuestion(questionId: questionId, questionHasFollowed: (self.question?.hasFollowed)!)
                self.collectionView?.reloadData()
            }
            
        }
    }
    
    func likeQuestion() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let questionId = question?.id else { return }
        
        let ref = Database.database().reference()
        let childUpdates = ["/users/\(uid)/questionHasLiked/\(questionId)": self.question?.hasLiked == true ? 0 : 1,
                            "/questionHasLiked/\(uid)/\(questionId)": self.question?.hasLiked == true ? 0 : 1]
        
        ref.updateChildValues(childUpdates) { (err, _) in
            if let err = err { print("Failed to like question:", err)
                return }
            
            // like count
            ref.child("questions").child(questionId).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in

                var hasLiked = self.question?.hasLiked

                if var question = currentData.value as? [String : AnyObject] {
                    var likeCount = question["likeCount"] as? Int ?? 0

                    if hasLiked == true {
                        likeCount -= 1
                        self.question?.likeCount -= 1

                    } else {
                        likeCount += 1
                        self.question?.likeCount += 1
                    }

                    question["likeCount"] = likeCount as AnyObject?

                    currentData.value = question
                    
                    DispatchQueue.main.async { // Correct
                        self.question?.hasLiked = !(self.question?.hasLiked)!
                        
                        self.updateLikedQuestion(questionId: questionId, questionHasLiked: (self.question?.hasLiked)!)
                        self.collectionView?.reloadData()
                    }
                    
                    return TransactionResult.success(withValue: currentData)
                }

                return TransactionResult.success(withValue: currentData)

            }) { (error, committed, snapshot) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }

        }
    }
    
    var delegate: QuestionListController?
    
    func updateLikedQuestion(questionId: String, questionHasLiked: Bool) {
        delegate?.saveLikedQuestion(questionId: questionId, questionHasLiked: questionHasLiked)
    }
    
    func updateFollowedQuestion(questionId: String, questionHasFollowed: Bool) {
        delegate?.saveFollowedQuestion(questionId: questionId, questionHasFollowed: questionHasFollowed)
    }

    //MARK:- ADD A NEW ANSWER
    
    @objc func validateForm() {
        
        guard let text = textField.text else { return }
        
        if !text.isEmpty, text.count > 0 {
            self.submitButton.setTitleColor(FontAttributes.accessaryButtonColor, for: .normal)
            self.submitButton.isEnabled = true
        } else {
            self.submitButton.setTitleColor(.lightGray, for: .normal)
            self.submitButton.isEnabled = false
        }
        
    }
    
    @objc func submitAnswerButtonDidTap() {
        
        guard let questionId = self.question?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference()
        let newAnswerkey = ref.child("answers").child(questionId).childByAutoId().key
        
        let answerValue = ["questionId": questionId, "text": textField.text ?? "", "createdAt": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        
        let answerUpdates: [String:Any] = ["/answers/\(questionId)/\(newAnswerkey)": answerValue,
                                           "/questions/\(questionId)/answers/\(newAnswerkey)": 1]
        
        ref.updateChildValues(answerUpdates) { (err, ref) in
            
            self.textField.text = ""
            self.submitButton.isEnabled = false
            self.submitButton.setTitleColor(.lightGray, for: .normal)
            
            if err != nil {
                print("Failed to add new question into the node")
            }
            print("Successful")
          
            let answerObject = ["newAnswerkey": newAnswerkey, "questionId": questionId]
            NotificationCenter.default.post(name: .newAnswer, object: answerObject)
        }
        
    }
    
    
     //MARK:- DELETE AN ANSWER
    
    func deleteAnswerButtonDidTap(for cell: QnaDetailCell) {
        
        let title = "삭제하시겠습니까?"
        let message = "삭제한 뒤에는 복구할 수 없습니다."
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .destructive, handler: { (_) in
            self.deleteAnswer(cell: cell)
        })
        let cancel = UIAlertAction(title: "아니오", style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)

    }
    
    func deleteAnswer(cell: QnaDetailCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        let answer = answers[indexPath.item]
        
        let questionId = answer.questionId
        let answerId = answer.id
        
        let ref = Database.database().reference()
        ref.child("answers").child(questionId).child(answerId).removeValue()
        ref.child("questions").child(questionId).child("answers").child(answerId).removeValue()
        
        self.answers.remove(at: indexPath.item)
        self.collectionView?.reloadData()
    }
}
