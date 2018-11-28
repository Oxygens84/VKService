//
//  FriendInfoViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import RealmSwift

enum SwipesOptions{
    case left
    case right
}

class FriendInfoViewController: UICollectionViewController,CAAnimationDelegate  {

    var friend: Friend?
    var imageNames: [FriendPhoto] = []
    var currentImage: Int = 0
    let service = FriendService()
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    
    @IBAction func valueChanged(_ sender: PhotoLike) {
        if sender.flag == Flag.like && friend != nil{
            if !friend!.myAvatarLike {
                //friend!.avatarLikes = friend!.avatarLikes + 1
                //friend!.myAvatarLike = true
            } else if friend!.avatarLikes > 0 {
                //friend!.avatarLikes = friend!.avatarLikes - 1
                //friend!.myAvatarLike = false
            }
        }
        collectionView?.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = friend!.friend
        observeFriendPhotos()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        notificationToken?.invalidate()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width-100, height: screenSize.height-100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellNames.friendInfoCell.rawValue, for: indexPath) as! FriendInfoViewCell
        
        if imageNames.count > 0 {
            cell.friendPhoto.tag = indexPath.row
            cell.likeFriendPhoto.text = String(friend!.avatarLikes)
            let photo = imageNames[currentImage]
            cell.configure(friendPhoto: photo)
            
            heartBeatingAnimation(cell.heart, scale: 1.4)
            
            let swipeFromRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
            swipeFromRight.direction = UISwipeGestureRecognizer.Direction.left
            cell.addGestureRecognizer(swipeFromRight)

            let swipeFromLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
            swipeFromLeft.direction = UISwipeGestureRecognizer.Direction.right
            cell.addGestureRecognizer(swipeFromLeft)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }

}


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
    
}

extension FriendInfoViewController {

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
                                    //sender.transform = CGAffineTransform(scaleX: 1-scale, y: 1-scale)
                                    sender.transform = CGAffineTransform(scaleX: scale, y: scale)
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
