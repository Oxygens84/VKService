//
//  FriendInfoViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

enum SwipesOptions{
    case left
    case right
}

class FriendInfoViewController: UICollectionViewController,CAAnimationDelegate  {

    var friend: Friend?
    
    var currentImage: Int = 0
    var imageNames: [String] = []
    
    let vkService = VkService()
    
    @IBAction func valueChanged(_ sender: PhotoLike) {
        if sender.flag == Flag.like && friend != nil{
            if !friend!.getMyAvatarLike() {
                friend!.setAvatarLikes(total: friend!.getAvatarLikes() + 1)
                friend!.setMyAvatarLike(true)
            } else if friend!.getAvatarLikes() > 0 {
                friend!.setAvatarLikes(total: friend!.getAvatarLikes() - 1)
                friend!.setMyAvatarLike(false)
            }
        }
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = friend!.getFriendName()
        setImages()
        
        if let user = Session.shared.userId {
            //vkService.loadUserPhotos(userId: friend!.id)
            vkService.loadUserPhotos(userId: user)
        }
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
        cell.friendPhoto.image = UIImage(named: imageNames[currentImage]) 
        cell.likeFriendPhoto.text = String(friend!.getAvatarLikes())
        cell.friendPhoto.tag = indexPath.row
        
        heartBeatingAnimation(cell.heart, scale: 1.4)
        
        let swipeFromRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        swipeFromRight.direction = UISwipeGestureRecognizer.Direction.left
        cell.addGestureRecognizer(swipeFromRight)

        let swipeFromLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        swipeFromLeft.direction = UISwipeGestureRecognizer.Direction.right
        cell.addGestureRecognizer(swipeFromLeft)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
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
        cell.friendPhoto.image = UIImage(named: imageNames[currentImage])
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
        cell.friendPhoto.image = UIImage(named: imageNames[currentImage])
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
    
    func setImages(){
        if friend?.getFriendAvatar() != nil {
            imageNames = []
            imageNames.append(friend!.getFriendAvatar())
            for i in 1...5 {
                imageNames.append("Party\(i).jpeg")
            }
        } else {
            imageNames =  ["Unknown"]
        }
    }


}


