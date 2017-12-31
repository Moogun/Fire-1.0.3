//
//  Extensions.swift
//  Fire
//
//  Created by Moogun Jung on 12/18/16.
//  Copyright © 2016 Moogun. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
 
    func questionAlertView(message: String) {
        
        DispatchQueue.main.async {
            
            let savedLabel = UILabel()
            savedLabel.text = message
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
    
    func alertView1(message: String) {
        
        DispatchQueue.main.async {
            
            let savedLabel = UILabel()
            savedLabel.text = message
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
                    self.dismiss(animated: true, completion: nil)
                })
                
            })
        }
        
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension Date {
    
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self)) + 1
        //this returns integer value and 
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "seccond"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "minute"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "Month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
        
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static func mainBlue() -> UIColor {
        //return UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        return UIColor.rgb(red: 17, green: 154, blue: 237)
    }
    
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {  
        view.endEditing(true)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}


//extension AuthErrorCode {
//    var errorMessage: String {
//        switch self {
//
//            /** Indicates a validation error with the custom token.
//             */
//        case .errorCodeInvalidCustomToken:
//            return "errorCode Invalid CustomToken"
//
//
//            /** Indicates the service account and the API key belong to different projects.
//             */
//        case .errorCodeCustomTokenMismatch:
//            return "CustomTokenMismatch"
//
//
//            /** Indicates the IDP token or requestUri is invalid.
//             */
//        case .errorCodeInvalidCredential:
//            return "Invalid Credential"
//
//            /** Indicates the user's account is disabled on the server.
//             */
//        case .errorCodeUserDisabled:
//            return "User Disabled"
//
//            /** Indicates the administrator disabled sign in with the specified identity provider.
//             */
//        case .errorCodeOperationNotAllowed:
//            return "Operation Not allowed"
//
//
//            /** Indicates the email used to attempt a sign up is already in use.
//             */
//        case .errorCodeEmailAlreadyInUse:
//            return "EmailAlreadyInUse"
//
//
//            /** Indicates the email is invalid.
//             */
//        case .errorCodeInvalidEmail:
//            return "EmailAlreadyInUse"
//
//
//            /** Indicates the user attempted sign in with a wrong password.
//             */
//        case .errorCodeWrongPassword:
//            return "Wrong password"
//
//
//            /** Indicates that too many requests were made to a server method.
//             */
//        case .errorCodeTooManyRequests:
//            return "Too many Requests"
//
//
//            /** Indicates the user account was not found.
//             */
//        case .errorCodeUserNotFound:
//            return "User not found"
//
//
//            /** Indicates account linking is required.
//             */
//        case .errorCodeAccountExistsWithDifferentCredential:
//            return "AccountExistsWithDifferentCredential"
//
//
//            /** Indicates the user has attemped to change email or password more than 5 minutes after
//             signing in.
//             */
//        case .errorCodeRequiresRecentLogin:
//            return "RequiresRecentLogin"
//
//
//            /** Indicates an attempt to link a provider to which the account is already linked.
//             */
//        case .errorCodeProviderAlreadyLinked:
//            return "ProviderAlreadyLinked"
//
//
//            /** Indicates an attempt to unlink a provider that is not linked.
//             */
//        case .errorCodeNoSuchProvider:
//            return "NoSuchProvider"
//
//
//            /** Indicates user's saved auth credential is invalid, the user needs to sign in again.
//             */
//        case .errorCodeInvalidUserToken:
//            return "InvalidUserToken"
//
//            /** Indicates a network error occurred (such as a timeout, interrupted connection, or
//             unreachable host). These types of errors are often recoverable with a retry. The @c
//             NSUnderlyingError field in the @c NSError.userInfo dictionary will contain the error
//             encountered.
//             */
//        case .errorCodeNetworkError:
//            return "NetworkError"
//
//
//            /** Indicates the saved token has expired, for example, the user may have changed account
//             password on another device. The user needs to sign in again on the device that made this
//             request.
//             */
//        case .errorCodeUserTokenExpired:
//            return "TokenExpired"
//
//            /** Indicates an invalid API key was supplied in the request.
//             */
//        case .errorCodeInvalidAPIKey:
//            return "InvalidAPIKey"
//
//            /** Indicates that an attempt was made to reauthenticate with a user which is not the current
//             user.
//             */
//        case .errorCodeUserMismatch:
//            return "UserMismatch"
//
//            /** Indicates an attempt to link with a credential that has already been linked with a
//             different Firebase account
//             */
//        case .errorCodeCredentialAlreadyInUse:
//            return "CredentialAlreadyInUse"
//
//            /** Indicates an attempt to set a password that is considered too weak.
//             */
//        case .errorCodeWeakPassword:
//            return "WeakPassword"
//
//            /** Indicates the App is not authorized to use Firebase Authentication with the
//             provided API Key.
//             */
//        case .errorCodeAppNotAuthorized:
//            return "AppNotAuthorized"
//
//
//            /** Indicates an error occurred while attempting to access the keychain.
//             */
//        case .errorCodeKeychainError:
//            return "KeychainError"
//
//
//            /** Indicates an internal error occurred.
//             */
//        case .errorCodeInternalError:
//            return "Internal Error"
//
//            //default:
//            //  return "Unknown error occurred"
//        }
//    }
//}



