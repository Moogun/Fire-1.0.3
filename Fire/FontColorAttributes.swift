//
//  FontColorAttributes.swift
//  Fire
//
//  Created by Moogun Jung on 9/11/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

struct Text {
    
    static let mainColor = UIColor.init(r: 31, g: 75, b: 765, a: 1)
    
    static let previewMenuFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
    static let like = "좋아요"
    static let likeCount = "명이 좋아합니다."
    static let more = "더보기"
    
    static let wantToDelete = "삭제하시겠습니까?"
    static let toBeDeletedPermanantly =  "삭제한 뒤에는 복구할 수 없습니다."
    static let okay = "네"
    static let no = "아니오"
    static let cancel = "취소"
    
    static let delete = "삭제"
    
    static let myQuestion = "내 질문입니다.."
    static let bookmark = "내 질문으로 스크랩되었습니다."
    static let bookmarkCancel = "스크랩이 취소되었습니다."
    
    //new question
    static let newQuestion = "질문하기"
    
   
    //preview 
    static let newAnnouncement = "새 공지"
    
    //saved
    static let saved = "저장되었습니다"
    
    //Login
    static let helpLogin = "Get help signing in"
    static let forgotLogin = "Forgot login details?"
    static let notSignUp = "Don't have an account?"
    static let signUp = "Sign up"
    
    
    //Sign up
    static let agreement = "By singing up, you agree to our"
    static let terms = "terms and privacy policy"
    static let haveAnAccount = "Already Have account?"
    static let login = "Login"
    
    
}

struct cellDimension {
    static let indexLabelHeight: CGFloat = 10
    static let titleLabelHeight: CGFloat = 30
    static let leftMargin: CGFloat = 20
    static let rightMargin: CGFloat = -20
}

struct FontAttributes {
    
    //preview
    static let previewSubMenuTitleFont14Thin = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin) // 24
        static let previewSubMenuTitleColorDarkGray = UIColor.darkGray
    
    //keyword
    static let titleFont = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin) // 24
    static let titleMeaningColor = UIColor.black
    static let titleWordColor = UIColor(r: 31, g:75, b:165, a: 1)
    
    static let pronunciationFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)//was 16
    //static let pronunciationColor = UIColor(r: 155, g:155, b:155, a: 1)
    static let pronunciationColor = UIColor(r: 112, g:112, b:112, a: 1)
    
    static let keywordFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
    static let bulletPoint = "\u{2022}"
    static let blankSpaces = "   " //3 spaces
    
    static let accessaryButtonColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    
}
