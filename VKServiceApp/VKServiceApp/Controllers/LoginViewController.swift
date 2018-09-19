//
//  ViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 19/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit



class LoginViewController : UIViewController {
    
    var adminForTest = ["admin","12345"]

    @IBOutlet weak var loginPageScrollView: UIScrollView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        let login = userNameField.text!
        let password = userPasswordField.text!
        if login == adminForTest[0] && password == adminForTest[1] {
            print("sign up: success")
            userNameField.text = ""
            userPasswordField.text = ""
        } else {
            print("sign up: failed")
            let alert = UIAlertController(
                title: "Error",
                message: "Invalid login or password",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        //for testing
        //userNameField.text = adminForTest[0]
        //userPasswordField.text = adminForTest[1]
        
        let hideKeyboardGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.hideKeyboard))
        loginPageScrollView?.addGestureRecognizer(hideKeyboardGesture)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    @objc func hideKeyboard(){
        self.loginPageScrollView?.endEditing(true)
    }

}

