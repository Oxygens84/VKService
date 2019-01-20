//
//  ViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 19/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift
import FirebaseAuth
import FirebaseDatabase

class LoginViewController : UIViewController {
    
    //-----------------------------------
    //for testing
    var adminForTest = ["admin","12345"]
    let testingMode: Bool = true
    //-----------------------------------
    
    var users = [FirebaseUser]()
    var ref: DatabaseReference!

    @IBOutlet weak var loginPageScrollView: UIScrollView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    var gifImage = UIImageView()
    var handle: AuthStateDidChangeListenerHandle!
    
    @IBAction func loginButton(_ sender: Any) {
        let login = userNameField.text!
        let password = userPasswordField.text!
        if checkLoginAndPassword(userLogin: login, userPassword: password){
            //setLoadingScreen()
            setGifLoadingScreen()
            performSegue(withIdentifier: SeguesId.goToDashboard.rawValue, sender: nil)
        } else {
            performAlert(message: Messages.loginFailed.rawValue)
        }
    }
    
    @IBAction func logOut(_ segue: UIStoryboardSegue){
        cleanFields()
        deleteCookies()
        
        do {
          try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.webViewLoadData(view: webview)
        addHideKeyboardGesture()
        
        userPasswordField.isSecureTextEntry = true
        if testingMode {
            userNameField.text = adminForTest[0]
            userPasswordField.text = adminForTest[1]
        }
        
        ref = Database.database().reference(withPath: "users")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToNotification()
        
        handle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: SeguesId.goToDashboard.rawValue, sender: nil)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //removeLoadingScreen()
        removeGifLoadingScreen()
        super.viewWillDisappear(animated)
        unsubscribeFromNotification()
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
}
