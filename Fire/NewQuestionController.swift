//
//  AskController.swift
//  Fire
//
//  Created by Moogun Jung on 9/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class NewQuestionController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var chapter: ChapterModel?
    
    var isImageSelected = false
    
    var selectedImage: UIImage? {
        didSet {
            //print("chosen from the photo selector:",selectedImage)
            self.imageView.image = selectedImage
        }
    }
    
    let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.progress = 0.3
        return pv
    }()

    //MARK:- Image
    
    lazy var photoLibraryImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "photo80")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPhotoLibrary)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var cameraImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "camera80")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentCamera)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "bitmap60")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    
    //MARK:- Details
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.text = Text.newQuestion
        tv.textColor = UIColor.lightGray
        return tv
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Text.newQuestion
            textView.textColor = UIColor.lightGray
        }
    }
    
    //MARK:- layout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(addButtonDidTap))

        textView.delegate = self
        textView.becomeFirstResponder()
        
        setupImageAndTextViews()
        
        self.view.addSubview(self.progressView)
        self.progressView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50)
        
    }
    
    fileprivate func setupImageAndTextViews() {
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300) //150 with a titleView

        //MARK: ImageView + camera + photo
        
        let view1 = UIView()
        view1.backgroundColor = .white
        view1.layer.cornerRadius = 4
        
        let view2 = UIView()
        view2.backgroundColor = .white
        view2.layer.cornerRadius = 4
        
        containerView.addSubview(view1)
        view1.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
            view1.addSubview(cameraImageView)
            cameraImageView.anchor(top: view1.topAnchor, left: view1.leftAnchor, bottom: view1.bottomAnchor, right: view1.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
        containerView.addSubview(view2)
        view2.anchor(top: view1.bottomAnchor, left: view1.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 50, height: 50)
        
            view2.addSubview(photoLibraryImageView)
            photoLibraryImageView.anchor(top: view2.topAnchor, left: view2.leftAnchor, bottom: view2.bottomAnchor, right: view2.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
        
        containerView.addSubview(imageView)
        imageView.anchor(top: view1.topAnchor, left: view1.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 108, height: 108)
        
        containerView.addSubview(textView)
        textView.anchor(top: view2.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    
    //MARK:- Methods - select image

    @objc func presentPhotoLibrary() {
        
        let layout = UICollectionViewFlowLayout()
        let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
        photoSelectorController.delegate = self
        let navController = UINavigationController(rootViewController: photoSelectorController)
        
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func presentCamera() {
        
        if #available(iOS 10.0, *) {
            let cameraController = CameraController()
            cameraController.delegate = self
            present(cameraController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            alertCameraNotAvailable()
        }
        
    }
    
    func alertCameraNotAvailable() {
        
        DispatchQueue.main.async {
            
            let savedLabel = UILabel()
            savedLabel.text = Text.saved
            savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
            savedLabel.textColor = .white
            savedLabel.numberOfLines = 0
            savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
            savedLabel.textAlignment = .center
            
            savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            savedLabel.center = self.view.center
            
            self.view.addSubview(savedLabel)
            
            savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0 )
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }, completion: { (completed) in
                
                UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    savedLabel.alpha = 0
                    
                }, completion: { (_) in
                    
                    savedLabel.removeFromSuperview()
                    
                })
            })
        }
    }
    
    //MARK:- Methods Upload a question
    
    @objc func addButtonDidTap() {
        if isImageSelected {
            addWithImage()
        } else {
            addWithoutImage()
        }
    }
    
    func addWithImage() {
        
        guard let image = self.imageView.image else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let chapterId = self.chapter?.id else { return }
        guard let text = textView.text, text.count > 0 else { return }
        
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("questions").child(filename)
        let uploadTask = ref.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image:", err)
                return
            }
            
            //file upload done and continue to upload it to the question node
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print("Successfully uploaded post image:", imageUrl)
            
            //
            let ref = Database.database().reference()
            let newQuestionKey = ref.child("questions").childByAutoId().key
            
            //question value for updating in question list
            let questionValue: [String: Any] = ["text": text, "questionImageUrl":imageUrl, "uid": uid, "createdAt": Date().timeIntervalSince1970, "chapterId": chapterId, "answerCount": 0, "followCount": 0]
            
            let questionUpdates: [String: Any] = ["/questions/\(newQuestionKey)": questionValue,
                                                  "/chapters/\(chapterId)/questions/\(newQuestionKey)":1,
//                                                  "/users/\(uid)/questions/\(newQuestionKey)":1]
                                    "/users/\(uid)/questionHasFollowed/\(newQuestionKey)":1] // Nov 24
            
            ref.updateChildValues(questionUpdates, withCompletionBlock: { (err, ref) in
                print("successfully added to question node")
                self.textView.text = ""
                
                let newQuestionObject = ["newQuestionKey": newQuestionKey, "chapterId": chapterId]
                NotificationCenter.default.post(name: .newQuestion, object: newQuestionObject)
                self.navigationController?.popViewController(animated: true)
            })
        }
        
//        uploadTask.resume()
//        uploadTask.observe(FIRStorageTaskStatus.progress) { (snapshot) in
//            print("unitCount:", snapshot.progress!.completedUnitCount, "total", snapshot.progress!.completedUnitCount)
//            
//            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//                / Double(snapshot.progress!.totalUnitCount)
//            print("percent", percentComplete)
//            
//            self.progressView.progress = Float(percentComplete)
//        }
        
        uploadTask.observe(.progress) { (snapshot) in
            //print("total:", snapshot.progress?.totalUnitCount)
            guard let total = snapshot.progress?.totalUnitCount else { return }
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
                print(completedUnitCount / total * 100)
            }
            
        }
        
    }
    
    /*
     1. add a question to question node and chapter question node
     2. listen to the change in chapter question node
     3. take the question and add it to question list
     3. udpate 질문 답변 info 
     */
    
    func addWithoutImage() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let chapterId = self.chapter?.id else { return }
        guard let text = textView.text, text.count > 0 else { return }
        
        let ref = Database.database().reference()
        let newQuestionKey = ref.child("questions").childByAutoId().key
        
        let questionValue: [String: Any] = ["text": text, "uid": uid, "createdAt": Date().timeIntervalSince1970, "chapterId": chapterId, "answerCount": 0, "followCount": 0]
        let questionUpdates: [String: Any] = ["/questions/\(newQuestionKey)": questionValue,
                                              "/chapters/\(chapterId)/questions/\(newQuestionKey)":1,
                                              "/users/\(uid)/questionHasFollowed/\(newQuestionKey)":1] // Nov 24 
        
        ref.updateChildValues(questionUpdates, withCompletionBlock: { (err, ref) in
            print("successfully added to question node without an image")
            self.textView.text = ""
            
            let newQuestionObject = ["newQuestionKey": newQuestionKey, "chapterId": chapterId]
            NotificationCenter.default.post(name: .newQuestion, object: newQuestionObject)
            self.navigationController?.popViewController(animated: true)
        })
    }

    
}

