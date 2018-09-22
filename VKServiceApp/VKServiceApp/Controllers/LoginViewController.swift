//
//  ViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 19/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit


class LoginViewController : UIViewController {
    
    //-----------------------------------
    //for testing
    var adminForTest = ["admin","12345"]
    let testingMode: Bool = true
    //-----------------------------------

    @IBOutlet weak var loginPageScrollView: UIScrollView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var serviceTitle: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        let login = userNameField.text!
        let password = userPasswordField.text!
        if checkLoginAndPassword(userLogin: login, userPassword: password){
            performSegue(withIdentifier: SeguesId.goToDashboard.rawValue, sender: nil)
        } else {
            performAlert(message: Messages.loginFailed.rawValue)
        }
    }
    
    @IBAction func logOut(_ segue: UIStoryboardSegue){
        cleanFields()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHideKeyboardGesture()
        userPasswordField.isSecureTextEntry = true
        
        if testingMode {
            userNameField.text = adminForTest[0]
            userPasswordField.text = adminForTest[1]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromNotification()
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
    
    func addHideKeyboardGesture(){
        let hideKeyboardGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.hideKeyboard))
        loginPageScrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    
    @objc func hideKeyboard(){
        self.loginPageScrollView?.endEditing(true)
    }
    
    @objc func keyboardWasShown(notification: Notification){
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 8.0, 0.0)
        self.loginPageScrollView?.contentInset = contentInsets
        loginPageScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification){
        let contentInsets = UIEdgeInsets.zero
        loginPageScrollView?.contentInset = contentInsets
        loginPageScrollView.scrollIndicatorInsets = contentInsets
    }
    
    func subscribeToNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWasShown),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeHidden(notification: )),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func unsubscribeFromNotification(){
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

