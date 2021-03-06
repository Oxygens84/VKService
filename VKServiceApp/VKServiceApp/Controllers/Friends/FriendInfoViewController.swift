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

class FriendInfoViewController: UICollectionViewController, CAAnimationDelegate, UICollectionViewDelegateFlowLayout  {

    var friend: Friend?
    var imageNames: [FriendPhoto] = []
    var currentImage: Int = 0
    let service = FriendService()
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    
    @IBAction func valueChanged(_ sender: PhotoLike) {
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
        if UIDevice.current.orientation == .portrait ||
            UIDevice.current.orientation == .portraitUpsideDown {
            return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-100)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width*0.6, height: UIScreen.main.bounds.size.height)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellNames.friendInfoCell.rawValue, for: indexPath) as! FriendInfoViewCell
        
        if imageNames.count > 0 {
            cell.friendPhoto.tag = indexPath.row
//            if friend?.avatarLikes != nil {
//                cell.likeFriendPhoto.text = String(friend!.avatarLikes)
//            } else {
                cell.likeFriendPhoto.text = ""
//            }
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

}
