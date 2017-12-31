//
//  QnaController.swift
//  Fire
//
//  Created by Moogun Jung on 8/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class QuestionListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, QuestionListCellDelegate, QnaDetailControllerDelegate {
    
    var chapter: ChapterModel?
    var questions = [QuestionModel]()
    let cellId = "cellId"
    
    //MARK:- life cycle
    
    let noItemLabel: UILabel = {
        let label = UILabel()
        label.text = "질문하세요."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(QuestionListCell.self, forCellWithReuseIdentifier: cellId)

        if chapter?.id == nil {
            
            navigationItem.title = "내 질문"
            fetchMyQuestions()
            
        } else {
            
            navigationItem.title = "Q&A"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ask"), style: .plain, target: self, action: #selector(presentNewQuestionController))
            
            fetchAllQuestions()
            noItem()
            
        }
 
        
        //MARK: Notification List
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewQuestion), name: .newQuestion, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteQuestion), name: .deleteQuestion, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuestion), name: .newAnswer, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if chapter?.id == nil {
            print("my questions")
        } else {
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if chapter?.id == nil {
            print("my questions")
        } else {
            tabBarController?.tabBar.isHidden = false
        }
    }
    
    func noItem() {
        UIView.animate(withDuration: 0.0) {
            self.view.addSubview(self.noItemLabel)
            self.noItemLabel.center = self.view.center
        }
    }
    
    @objc func updateQuestions() {
        self.refreshQuestions()
    }
    
    func refreshQuestions() {
        self.questions.removeAll()
        self.fetchQuestions()
        self.collectionView?.reloadData()
    }

    func fetchAllQuestions() {
        self.fetchQuestions()
    }

    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    //MARK:- data source, delegate 
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! QuestionListCell
        cell.question = questions[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = QuestionListCell(frame: frame)
        dummyCell.question = questions[indexPath.item]
        dummyCell.layoutIfNeeded()

        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)

        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height) //height
        
//        let cellHeight = (view.frame.height - 50) / 7
//        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentQuestionDetailController(indexPath: indexPath)
    }
    
    //MARK:- Methods
    
    /*
        - get uid
     1. get question array from chapter - get question array from user - question node
     2. iterate question array - same
     3. fetch at question node - same
     4. get dictionary and hold it as a question dict - same
     5. get uid from the question dict - same
     6. fetch user info and add it to question model  - same
     7. check whether the question has followed - same
     7. check whether the question has liked  - same
     8. append the question to question array - same
     9. sort the question - same
     10. reload - same
     */
    
    func fetchMyQuestions() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let chapterId = ""
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            print("usermodel:", user)
            
            let questions = user.questionHasFollowed
            print("qqq", questions)
            questions.forEach { (key, value) in
                //print("q list key:", key, "value:", value)
                
                guard value as! Int == 1 else { return }
                print("key", key)
                
                let ref = Database.database().reference().child("questions").child(key) //Nov 24 was questions
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    //print(snapshot)
                    
                    guard let questionDict = snapshot.value as? [String: Any] else { return }
                    guard let questionerUid = questionDict["uid"] as? String else { return }
                        
                    Database.fetchUserWithUID(uid: questionerUid, completion: { (UserModel) in
                        print("snapthot", snapshot.key)
                        var question = QuestionModel(chapterId: chapterId, id: snapshot.key, user: UserModel, dictionary: questionDict)
                        //print(UserModel.questionHasLiked, UserModel.questionHasFollowed)
                        Database.database().reference().child("questionHasFollowed").child(uid).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let value = snapshot.value as? Int, value == 1 {
                                question.hasFollowed = true
                            } else {
                                question.hasFollowed = false
                            }
                            
                            Database.database().reference().child("questionHasLiked").child(uid).child(snapshot.key).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                                
                                if let value = snapshot.value as? Int, value == 1 {
                                    question.hasLiked = true
                                } else {
                                    question.hasLiked = false
                                }
                                
                                self.questions.append(question)
                                self.questions.sort(by: { (p1, p2) -> Bool in
                                    p1.createdAt.compare(p2.createdAt) == .orderedDescending
                                })
                                
                                self.collectionView?.reloadData()
                                
                            })
                        })
                    })
                    
//                    Database.fetchUserWithUID(uid: uid, completion: { (UserModel) in
//                        var question = QuestionModel(chapterId: chapterId, id: snapshot.key, user: UserModel, dictionary: questionDict)
//
//                        Database.database().reference().child("questionHasFollowed").child(uid).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                            if let value = snapshot.value as? Int, value == 1 {
//                                question.hasFollowed = true
//                            } else {
//                                question.hasFollowed = false
//                            }
//
//                            self.questions.append(question)
//                            self.questions.sort(by: { (p1, p2) -> Bool in
//                                p1.createdAt.compare(p2.createdAt) == .orderedDescending
//                            })
//
//                            self.collectionView?.reloadData()
//                        })
//
//                    })
                    
                }) { (err) in
                    print(err, "error occured")
                }
            }

            
        }
    }
    
    func fetchQuestions() {
    
        /*
        1. get question array from chapter
        2. iterate question array
         3. fetch question node
         4. get dictionary and hold it as a question dict
         5. get uid from the question dict
         6. fetch user info and add it to question model
         7. check whether the question has followed
         7. check whether the question has liked
         8. append the question to question array
         9. sort the question
         10. reload
         */
        guard let chapterId = chapter?.id else { return }
        guard let questions = chapter?.questions else { return }
        print("number of questions:", questions.count)
        
        questions.forEach { (key, value) in
            //print("q list key:", key, "value:", value)
            
            let ref = Database.database().reference().child("questions").child(key)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let questionDict = snapshot.value as? [String: Any] else { return }
                guard let questionerUid = questionDict["uid"] as? String else { return } // this uid is for the questioner, not the current user
                
                    Database.fetchUserWithUID(uid: questionerUid, completion: { (UserModel) in
                        
                        var question = QuestionModel(chapterId: chapterId, id: snapshot.key, user: UserModel, dictionary: questionDict)
                        print("followed:", UserModel.questionHasFollowed, "liked",UserModel.questionHasLiked)
                        
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        
                        Database.database().reference().child("questionHasFollowed").child(uid).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                            //print("snapshot:", snapshot.key, "value:", snapshot.value) // returns nil
                            if let value = snapshot.value as? Int, value == 1 {
                               question.hasFollowed = true
                            } else {
                                question.hasFollowed = false
                            }
                            
                            Database.database().reference().child("questionHasLiked").child(uid).child(snapshot.key).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                                
                                if let value = snapshot.value as? Int, value == 1 {
                                    question.hasLiked = true
                                } else {
                                    question.hasLiked = false
                                }
                                
                                self.questions.append(question)
                                self.questions.sort(by: { (p1, p2) -> Bool in
                                    p1.createdAt.compare(p2.createdAt) == .orderedDescending
                                })
                                
                                self.collectionView?.reloadData()
                                
                            })
                        })
                    })
                
            }) { (err) in
                print(err, "error occured")
            }
        }
    }
 

    func getQuestion() {
        
    }
    
//    func item() {
//        UIView.animate(withDuration: 0.0) {
//            self.noItemLabel.removeFromSuperview()
//        }
//    }
//
    
    @objc func addNewQuestion(_ notification: Notification) {
        
        guard let newQuestion = notification.object as? [String: Any] else { return }
        
        if let questionKey = newQuestion["newQuestionKey"] as? String, let chapterId = newQuestion["chapterId"] as? String {
            
            let ref = Database.database().reference().child("questions").child(questionKey)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                guard let questionDict = snapshot.value as? [String: Any] else { return }
                guard let uid = questionDict["uid"] as? String else { return }
                print("uid:", uid)
                
                Database.fetchUserWithUID(uid: uid, completion: { (UserModel) in
                    let question = QuestionModel(chapterId: chapterId, id: snapshot.key, user: UserModel, dictionary: questionDict)
                    self.questions.append(question)
                    self.questions.sort(by: { (p1, p2) -> Bool in
                        p1.createdAt.compare(p2.createdAt) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                })
                
            }) { (err) in
                print(err, "error occured")
            }
        }
    }
    
    @objc func deleteQuestion(notification: Notification) {

        guard let questionToBeDeleted = notification.object as? [String: Any] else { return }
        guard let questionId = questionToBeDeleted["questionId"] as? String else { return }
        
        if let i = questions.index(where: { $0.id == questionId }) {
            print(i)
            self.questions.remove(at: i)
            self.collectionView?.reloadData()
        }
    }
    
    @objc func updateQuestion(notification: Notification) {
        
        guard let newAnswer = notification.object as? [String: Any] else { return }
        print("new answer",newAnswer)
        
        if let  answerKey = newAnswer["newAnswerkey"] as? String, let questionId = newAnswer["questionId"] as? String {
            print("answer key:", answerKey, "question Id:", questionId)

        }
    }
    
    //LIKE & FOLLOW
    
    func likeQuestion(for cell: QuestionListCell) {
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var question = self.questions[indexPath.item]
        
        let questionId = question.id
        let questionerId = question.uid
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //if questionerId == uid {
          //  questionAlertView(message: Text.myQuestion)
        //} else {
            
            let values = [questionId: question.hasLiked == true ? 0 : 1]
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("questionHasLiked").updateChildValues(values) { (err, _) in
                                                    //was questions
                if let err = err {
                    print("Failed to follow question:", err)
                    return
                }

                print(question.hasLiked, "Successfully toggling the question.")
                question.hasLiked = !question.hasLiked

                self.questions[indexPath.item] = question
                self.collectionView?.reloadItems(at: [indexPath])
            }

            ref.child("questionHasLiked").child(uid).updateChildValues(values, withCompletionBlock: { (err, _) in
                if let err = err {
                    print("Failed to follow question:", err)
                    return
                }

                print(question.hasFollowed, "Successfully adding this to questionHasFollowed node.")
            })
       // }
    }
    
    func saveLikedQuestion(questionId: String, questionHasLiked: Bool) {
        
        if let i = questions.index(where: { $0.id == questionId }) {
            
            let indexPath = IndexPath(item: i, section: 0)
            
            var question = self.questions[i]
            question.hasLiked = questionHasLiked
            
            self.questions[indexPath.item] = question
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
    
    
    func followQuestion(for cell: QuestionListCell) {
    
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        var question = self.questions[indexPath.item]
        
        let questionId = question.id
        let questionerId = question.uid
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if questionerId == uid {
            questionAlertView(message: Text.myQuestion)
        } else {
            let values = [questionId: question.hasFollowed == true ? 0 : 1]
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("questionHasFollowed").updateChildValues(values) { (err, _) in
                
                if let err = err {
                    print("Failed to follow question:", err)
                    return
                }
                
                print(question.hasFollowed, "Successfully toggling the question.")
                question.hasFollowed = !question.hasFollowed
                
                self.questions[indexPath.item] = question
                self.collectionView?.reloadItems(at: [indexPath])
            }
            
            ref.child("questionHasFollowed").child(uid).updateChildValues(values, withCompletionBlock: { (err, _) in
                if let err = err {
                    print("Failed to follow question:", err)
                    return
                }
                
                print(question.hasFollowed, "Successfully adding this to questionHasFollowed node.")
            })
        }
    }
    
    func saveFollowedQuestion(questionId: String, questionHasFollowed: Bool){
        print(questionId, questionHasFollowed)
       
        if let i = questions.index(where: { $0.id == questionId }) {
            
            let indexPath = IndexPath(item: i, section: 0)
            
            var question = self.questions[i]
            question.hasFollowed = questionHasFollowed
            
            self.questions[indexPath.item] = question
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
    
 
 
    //MARK:- NAVIGATION
    
    func presentQuestionDetailController(indexPath: IndexPath) {
        print("from didselect:", indexPath)
        let question = questions[indexPath.item]
        let qnaDetailController = QnaDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        qnaDetailController.question = question
        qnaDetailController.delegate = self
        navigationController?.pushViewController(qnaDetailController, animated: true)
    }
  
    
    @objc func presentNewQuestionController() {
        let newQuestionController = NewQuestionController()
        newQuestionController.chapter = self.chapter
        navigationController?.pushViewController(newQuestionController, animated: true)
    }
    


}




