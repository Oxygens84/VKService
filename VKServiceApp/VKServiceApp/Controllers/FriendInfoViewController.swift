//
//  FriendInfoViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class FriendInfoViewController: UICollectionViewController {

    var friend: Friend?
    
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
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellNames.friendInfoCell.rawValue, for: indexPath) as! FriendInfoViewCell
        cell.friendPhoto.image = UIImage(named: friend!.getFriendAvatar())
        cell.likeFriendPhoto.text = String(friend!.getAvatarLikes())
        return cell
    }

}
