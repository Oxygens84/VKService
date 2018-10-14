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
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    var gifImage = UIImageView()
    let loadingLabel = UILabel()
    
    @IBAction func loginButton(_ sender: Any) {
        let login = userNameField.text!
        let password = userPasswordField.text!
        if checkLoginAndPassword(userLogin: login, userPassword: password){
            //---------------------//
            //self.setLoadingScreen()
            self.setGifLoadingScreen()
            //---------------------//
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
        //------------------------//
        sleep(1)
        //self.removeLoadingScreen()
        self.removeGifLoadingScreen()
        //------------------------//
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
    
    private func setLoadingScreen() {
        
        loadingView.frame = UIScreen.main.bounds
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.isUserInteractionEnabled = false
        
        let width: CGFloat = 80
        let height: CGFloat = 30
        let x: CGFloat = (view.frame.width / 2) - (width / 2)
        let y: CGFloat = (view.frame.height / 2) - (height / 2)
        
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        
        spinner.style = .whiteLarge
        spinner.frame = CGRect(x: x - height - 10, y: y, width: height, height: height)
        spinner.startAnimating()
        
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        view.addSubview(loadingView)
        
    }
    
    private func setGifLoadingScreen() {
        
        loadingView.frame = UIScreen.main.bounds
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.isUserInteractionEnabled = false
        
        let width: CGFloat = view.frame.width
        let height: CGFloat = 100
        let x: CGFloat = (view.frame.width / 2) - (width / 2)
        let y: CGFloat = (view.frame.height / 2) - (height / 2)
        
        gifImage = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        gifImage.contentMode = .scaleAspectFit
        gifImage.center = loadingView.center
        gifImage.isUserInteractionEnabled = false
        //gifImage.loadGif(asset: "JumpingDots")
        gifImage.loadGif(asset: "DotsChain")
        //gifImage.loadGif(asset: "Dots")
        
        loadingView.addSubview(gifImage)
        loadingView.bringSubviewToFront(gifImage)
        view.addSubview(loadingView)
        
        
    }
    
    private func removeLoadingScreen() {
        spinner.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    private func removeGifLoadingScreen() {
        gifImage.removeFromSuperview()
        loadingView.removeFromSuperview()
    }

}


