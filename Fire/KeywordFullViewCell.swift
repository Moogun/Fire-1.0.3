//
//  KeywordFullViewCell.swift
//  CollectionViewTest
//
//  Created by Moogun Jung on 2/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class KeywordFullViewCell: BaseCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: KeywordFullViewCellDelegate?

    var keyword: KeywordModel? {
        didSet {
            self.keywordLayout()
            
            keywordImageView.image = nil
            guard let keywordImageUrl = self.keyword?.keywordImageUrl else { return }
            keywordImageView.loadImage(urlString: keywordImageUrl)

            markButton.setImage(keyword?.hasMarked == false ? #imageLiteral(resourceName: "mark").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "marked").withRenderingMode(.alwaysOriginal), for: .normal)

        }
    }
    
    //MARK:- Keyword Layouts
    
    func keywordLayout() {
        
        if let title = self.keyword {
            self.titleLayout(keyword: title)
        }
        if let meaning = self.keyword {
            self.meaningsLayout(keyword: meaning)
        }
        
    }
    
    func titleLayout(keyword: KeywordModel) {
        
        if let title = self.keyword?.keyword, let meaning_1 = self.keyword?.meaning_1 {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.defaultTabInterval = 5

            //MEANING
            let titleText = NSMutableAttributedString(string: meaning_1, attributes: [NSAttributedStringKey.font: FontAttributes.titleFont, NSAttributedStringKey.foregroundColor: FontAttributes.titleMeaningColor])
            
            //WORD
            titleText.append(NSAttributedString(string: "  " + title, attributes:  [NSAttributedStringKey.foregroundColor: FontAttributes.titleWordColor]))
            
            if let pronun = self.keyword?.pronunciation {
                
                titleText.append(NSAttributedString(string: "  " + "\(pronun)", attributes: [NSAttributedStringKey.font: FontAttributes.pronunciationFont, NSAttributedStringKey.foregroundColor: FontAttributes.pronunciationColor]))
                
                titleText.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSMakeRange(0, titleText.length))
                
                self.titleLabel.attributedText = titleText
                
            }
            
            self.titleLabel.attributedText = titleText
            
        }
    }
    
    func meaningsLayout(keyword: KeywordModel) {
        
        let cnParagraphStyle : NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.headIndent = 12 // 3 spaces equal to indent 12
            return paragraphStyle
        }()
        
        
        //english para
        let engParagraphStyle : NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4 // was 1, temporarily changed to 4 becasue hsk 1-4 keywords don't have language properties yet Nov 2
            paragraphStyle.headIndent = 12
            //paragraphStyle.defaultTabInterval = 8
            return paragraphStyle
        }()

        
        //what? paragraph height width 2 blank lines
        let paragraphStyleBlankLine = NSMutableParagraphStyle()
        paragraphStyleBlankLine.lineSpacing = 4
        paragraphStyleBlankLine.lineHeightMultiple = 0.1
        
        //
        let paragraphHeightAfterEgPronun = NSMutableAttributedString(string: "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)])
        paragraphHeightAfterEgPronun.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyleBlankLine], range: NSMakeRange(0, paragraphHeightAfterEgPronun.length))
        
        
        if let eg_Meaning_1 = self.keyword?.egMeaning_1 {
            
            //MARK: 1st batch
            
            let eg_Text_1 = NSMutableAttributedString(string: "\u{2022} \(eg_Meaning_1)", attributes: [NSAttributedStringKey.font: FontAttributes.keywordFont]) // was 15
            
                if let eg_1 = self.keyword?.eg_1 {
                    
                    // 3 spaces in the string
                    eg_Text_1.append((NSAttributedString(string: "\n   \(eg_1)", attributes: [NSAttributedStringKey.font: FontAttributes.keywordFont])))
                    
                }
            
                    // 1 space in the string
                if let eg_Pronun_1 = self.keyword?.egPronun_1 {
                    eg_Text_1.append((NSAttributedString(string: " [\(eg_Pronun_1)]", attributes: [NSAttributedStringKey.font: FontAttributes.pronunciationFont, NSAttributedStringKey.foregroundColor: FontAttributes.pronunciationColor])))
                }

            
            //MARK: 2nd batch
            
//            if let meaning_2 = self.keyword?.meaning_2 {
//                eg_Text_1.append(NSMutableAttributedString(string: "\n\n\u{2022} \(meaning_2)", attributes: [NSAttributedStringKey.font: FontAttributes.keywordFont]))
//            }
//
//            if let eg_2 = self.keyword?.eg_2 {
//                // 3 spaces in the string
//                eg_Text_1.append((NSAttributedString(string: "\n   \(eg_2)", attributes: [NSAttributedStringKey.font: FontAttributes.keywordFont])))
//            }
//
//                // 1 space in the string
//            if let eg_Pronun_2 = self.keyword?.egPronun_2 {
//                eg_Text_1.append((NSAttributedString(string: " [\(eg_Pronun_2)]", attributes: [NSAttributedStringKey.font: FontAttributes.pronunciationFont, NSAttributedStringKey.foregroundColor: FontAttributes.pronunciationColor])))
//            }
//
//            if let eg_Meaning_2 = self.keyword?.egMeaning_2 {
//                eg_Text_1.append((NSAttributedString(string: " : \n   \(eg_Meaning_2)", attributes: [NSAttributedStringKey.font: FontAttributes.keywordFont])))
//            }

            if self.keyword?.language == "cn" {

                eg_Text_1.addAttributes([NSAttributedStringKey.paragraphStyle : cnParagraphStyle], range: NSMakeRange(0, eg_Text_1.length))
                self.meaningTextView.attributedText = eg_Text_1

            } else {

                eg_Text_1.addAttributes([NSAttributedStringKey.paragraphStyle : engParagraphStyle], range: NSMakeRange(0, eg_Text_1.length))
                self.meaningTextView.attributedText = eg_Text_1

            }
            
            self.meaningTextView.attributedText = eg_Text_1
        }
        
    }


    //MARK:- UI Objects
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        label.textColor = .darkGray
        label.sizeToFit()
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    // MARK: textView
    
    let meaningTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8 + 20)
        return textView
    }()
    
    let keywordImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let imageAddedByLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "added By hello kitty"
        label.sizeToFit()
        return label
    }()

    let aiv: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    lazy var markButton: UIButton = {
        let button = UIButton(type: .system)
        button.sizeThatFits(CGSize(width: 20, height: 20))
        button.setImage(#imageLiteral(resourceName: "mark").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(markButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    lazy var wordPictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Followed").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(wordPictureButtonDidTap), for: .touchUpInside)
        return button
    }()
    

    //MARK:- METHODS
    
    @objc func markButtonDidTap() {
        print("testing")
        //delegate?.handleMarkButtonDidTap(for: self)
    }
    
    @objc func wordPictureButtonDidTap() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.delegate?.showImagePicker(imagePicker: picker)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.keywordImageView.image = selectedImage
            uploadKeywordPicture(selectedImage: self.keywordImageView.image!)
            self.delegate?.updateKeyword()
        }
        
        // call a method to reload a cell, not entire chapter, and remove keywords array if necessary 
        
        
        self.delegate?.dismissImagePickerView()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.dismissImagePickerView()
    }
    
    func uploadKeywordPicture(selectedImage: UIImage) {
        let imageName = NSUUID().uuidString
        guard let keywordId = keyword?.id else { return }
        guard let chapterId = keyword?.chapterId else { return }
        
        let storageRef = Storage.storage().reference().child("wordImages").child(keywordId).child("\(imageName).png")
        
        if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.1) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                
                //guard let uid = Auth.auth().currentUser?.uid else { return }

                let ref = Database.database().reference().child("keywords").child(chapterId).child(keywordId)
                
                if let keywordImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let value = ["keywordImageUrl": keywordImageUrl]
                    ref.updateChildValues(value, withCompletionBlock: { (error, ref) in
                        
                        if error != nil {
                            print(error as Any)
                            return
                        }
                     
                        self.delegate?.updateKeyword()
                        
                    })
                    
                }
            })
        }
    }

    let containerView = UIView()
    
    //MARK:- View Objects Layouts
    var keywordImageViewHeightAnchor: NSLayoutConstraint?
    var noteTextViewHeightAnchor: NSLayoutConstraint?
    
    override func setupViews() {

        addSubview(indexLabel)
        indexLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        self.addSubview(self.titleLabel)
        titleLabel.anchor(top: indexLabel.topAnchor, left: indexLabel.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        
        self.addSubview(self.meaningTextView)
        meaningTextView.backgroundColor = UIColor(r: 240, g: 240, b: 240, a: 1)
        meaningTextView.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 4, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

//        self.addSubview(self.keywordImageView)
//        keywordImageView.topAnchor.constraint(equalTo: meaningTextView.bottomAnchor, constant: 0).isActive = true
//        keywordImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: cellDimension.leftMargin).isActive = true
//        keywordImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: cellDimension.rightMargin).isActive = true //
//        
//        keywordImageViewHeightAnchor = keywordImageView.heightAnchor.constraint(equalToConstant: 20)
//        keywordImageViewHeightAnchor?.isActive = true
//        
//        keywordImageView.addSubview(aiv)
//        aiv.centerXAnchor.constraint(equalTo: self.keywordImageView.centerXAnchor).isActive = true
//        aiv.centerYAnchor.constraint(equalTo: self.keywordImageView.centerYAnchor).isActive = true

        //MARK: Bottom Buttons
        //setupBottomButtons()
    }
    
    fileprivate func setupBottomButtons() {
        
        let buttonStackView = UIStackView(arrangedSubviews: [])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fill
        buttonStackView.spacing = 20
        buttonStackView.backgroundColor = .blue
        
        self.addSubview(buttonStackView)
        buttonStackView.anchor(top: meaningTextView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 4, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 20)
        
    }
    
}

