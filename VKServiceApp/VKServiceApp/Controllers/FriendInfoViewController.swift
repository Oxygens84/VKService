//
//  FriendInfoViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class FriendInfoViewController: UICollectionViewController {

    var friendName: String = Defaults.friendName.rawValue
    var likeFriendPhoto: Int = 0
    
    @IBAction func valueChanged(_ sender: PhotoLike) {
        if sender.flag == Flag.like {
            likeFriendPhoto += 1
        } else if likeFriendPhoto > 0 {
            likeFriendPhoto -= 1
        }
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = friendName
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellNames.friendInfoCell.rawValue, for: indexPath) as! FriendInfoViewCell
        cell.friendPhoto.image = UIImage(named: friendName)
        
        cell.likeFriendPhoto.text = "Likes: " + String(likeFriendPhoto)
        return cell
    }
}
