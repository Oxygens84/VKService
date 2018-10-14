//
//  FriendInfoViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class FriendInfoViewController: UICollectionViewController,CAAnimationDelegate  {

    var friend: Friend?
    
    var currentImage: Int = 0
    var imageNames: [String] = []
    
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
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: screenSize.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellNames.friendInfoCell.rawValue, for: indexPath) as! FriendInfoViewCell
        cell.friendPhoto.image = UIImage(named: imageNames[currentImage]) 
        cell.likeFriendPhoto.text = String(friend!.getAvatarLikes())
        
        cell.friendPhoto.tag = indexPath.row
        
        heartBeatingAnimation(cell.heart, scale: 1.4)
        
        let swipeFromRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        swipeFromRight.direction = UISwipeGestureRecognizer.Direction.left
        cell.addGestureRecognizer(swipeFromRight)

        let swipeFromLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        swipeFromLeft.direction = UISwipeGestureRecognizer.Direction.right
        cell.addGestureRecognizer(swipeFromLeft)
        
        return cell
    }
    
    
    @objc func didSwipeLeft(sender: UIGestureRecognizer) {
        let indexPath = NSIndexPath(row: sender.view!.tag, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath as IndexPath) as! FriendInfoViewCell
        swipeAnimation(cell.friendPhoto, scale: 0.4)
        
        if currentImage == imageNames.count - 1 {
            currentImage = 0
        } else {
            currentImage += 1
        }
        cell.friendPhoto.image = UIImage(named: imageNames[currentImage])
        swipeAnimation(cell.friendPhoto, scale: 1.4)
    }
    
    @objc func didSwipeRight(sender: UIGestureRecognizer) {
        let indexPath = NSIndexPath(row: sender.view!.tag, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath as IndexPath) as! FriendInfoViewCell
        swipeAnimation(cell.friendPhoto, scale: 0.4)
        
        if currentImage == 0 {
            currentImage = imageNames.count - 1
        } else {
            currentImage -= 1
        }
        cell.friendPhoto.image = UIImage(named: imageNames[currentImage])
        swipeAnimation(cell.friendPhoto, scale: 1.4)
    }

    
    func swipeAnimation(_ sender: UIView, scale: CGFloat){
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                sender.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { _ in
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0.1,
                options: [.curveEaseIn],
                animations: {
                    sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            )
        }
        )
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


