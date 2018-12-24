//
//  LoginExtensionController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 25/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import WebKit

extension LoginViewController {
    
    @objc func hideKeyboard(){
        self.loginPageScrollView?.endEditing(true)
    }

    @objc func keyboardWasShown(notification: Notification){
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: kbSize.height + 8.0, right: 0.0)
        self.loginPageScrollView?.contentInset = contentInsets
        loginPageScrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHidden(notification: Notification){
        let contentInsets = UIEdgeInsets.zero
        loginPageScrollView?.contentInset = contentInsets
        loginPageScrollView.scrollIndicatorInsets = contentInsets
    }

    func addHideKeyboardGesture(){
        let hideKeyboardGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.hideKeyboard))
        loginPageScrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    func subscribeToNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWasShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeHidden(notification: )),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func unsubscribeFromNotification(){
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func checkLoginAndPassword(userLogin: String, userPassword: String) -> Bool{
        if userLogin == adminForTest[0] && userPassword == adminForTest[1] {
            return true
        }
        return false
    }
    
    func performAlert(message: String){
        let alert = UIAlertController(
            title: Titles.error.rawValue,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Titles.ok.rawValue, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func cleanFields(){
        userNameField.text = ""
        userPasswordField.text = ""
    }
}
