//
//  FriendExtensionController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 25/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

extension FriendInfoViewController {
    
    func loadDataFromVk(){
        service.loadPhotoDataWithAlamofire(friend: friend!) { (photos, error) in
            if let error = error {
                print(error)
            }
            if let photos = photos {
                self.imageNames = photos
                self.collectionView?.reloadData()
            }
        }
    }
    
    func loadDataFromRealm(){
        if let id = friend?.id {
            self.imageNames = service.loadPhotosFromRealm(user: id)
            if self.imageNames.count == 0 {
                loadDataFromVk()
            }
            self.collectionView?.reloadData()
        }
        
    }
    
    func observeFriendPhotos(){
        let data = realm.objects(FriendPhoto.self)
        print(data)
        notificationToken = data.observe { (changes) in
            switch changes {
            case .initial(let results):
                print(results)
                self.loadDataFromRealm()
            case .update(let results, let deletions, let insertions, let modifications):
                print(results)
                print(deletions)
                print(insertions)
                print(modifications)
                self.loadDataFromRealm()
            case .error(let error):
                print(error)
            }
        }
    }
    
    @objc func didSwipeLeft(sender: UIGestureRecognizer) {
        if currentImage == imageNames.count - 1 {
            currentImage = 0
        } else {
            currentImage += 1
        }
        let indexPath = NSIndexPath(row: sender.view!.tag, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath as IndexPath) as! FriendInfoViewCell
        
        swipeAnimation(cell.friendPhoto, scale: 0.4, action: .right)
        cell.configure(friendPhoto: imageNames[currentImage])
        swipeAnimation(cell.friendPhoto, scale: 1.4, action: .left)
    }
    
    @objc func didSwipeRight(sender: UIGestureRecognizer) {
        if currentImage == 0 {
            currentImage = imageNames.count - 1
        } else {
            currentImage -= 1
        }
        let indexPath = NSIndexPath(row: sender.view!.tag, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath as IndexPath) as! FriendInfoViewCell
        swipeAnimation(cell.friendPhoto, scale: 0.4, action: .left)
        cell.configure(friendPhoto: imageNames[currentImage])
        swipeAnimation(cell.friendPhoto, scale: 1.4, action: .right)
    }
    
    func swipeAnimation(_ sender: UIView, scale: CGFloat, action: SwipesOptions){
        let screenSize: CGRect = UIScreen.main.bounds
        var move: CGFloat = 0
        if action == .left {
            move = screenSize.width
        }
        if action == .right {
            move = -screenSize.width
        }
        
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: [],
                                animations: {
                                    sender.transform = CGAffineTransform(scaleX: 1-scale, y: 1-scale)
                                    //sender.transform = CGAffineTransform(scaleX: scale, y: scale)
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 1,
                                                       animations: {
                                                        sender.center.x += move
                                    })
                                    sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        },
                                completion: nil)
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadDataFromVk()
    }
    
}
