//
//  LoginWebViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 25/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAuth

extension LoginViewController : WKNavigationDelegate {
    
    func setLoadingScreen() {
        
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
    
    func setGifLoadingScreen() {
        
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
        gifImage.loadGif(asset: "JumpingDots")
        //gifImage.loadGif(asset: "DotsChain")
        //gifImage.loadGif(asset: "Dots")
        
        loadingView.addSubview(gifImage)
        loadingView.bringSubviewToFront(gifImage)
        view.addSubview(loadingView)
    }
    
    func removeLoadingScreen() {
        spinner.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    func removeGifLoadingScreen() {
        gifImage.removeFromSuperview()
        loadingView.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse:
        WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void )
    {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
            else {
                decisionHandler(.allow)
                return
        }
        
        //self.setLoadingScreen()
        setGifLoadingScreen()
        
        let params = fragment
            .components(separatedBy: "&")
            .map{$0.components(separatedBy: "=")}
            .reduce([String : String]()) {result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        if let tokenValue = params["access_token"],
            let user = params["user_id"]{
            Session.shared.token = tokenValue
            Session.shared.userId = Int(user)
            
            Auth.auth().signIn(withEmail: user, password: tokenValue) { (user, error) in
                // completion(user != nil)
            }
            
            if (Int(user) != nil){
                let userFB = FirebaseUser(userId: Int(user)!, groups: [])
                let userRef = self.ref.child(user)
                userRef.setValue(userFB.toAnyObject())
                users.append(userFB)
            }
            
            performSegue(withIdentifier: SeguesId.goToDashboard.rawValue, sender: nil)
        }
        decisionHandler(.cancel)
        
    }
    
    func deleteCookies() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records) {
                print("Deleted: " + records.description)
                
            }
        }
    }
    
    
    //    private func saveToFirestore(_ users: [FirebaseUser]) {
    //        let database = Firestore.firestore()
    //        let settings = database.settings
    //        settings.areTimestampsInSnapshotsEnabled = true
    //        database.settings = settings
    //
    //        let weathersToSend = weathers
    //            .map { $0.toFirestore() }
    //            .reduce([:]) { $0.merging($1) { (current, _) in current } }
    //
    //        database.collection("forecasts").document(self.cityname).setData(weathersToSend, merge: true) { error in
    //            if let error = error {
    //                print(error.localizedDescription)
    //            } else { print("data saved")}
    //        }
    //    }
}
