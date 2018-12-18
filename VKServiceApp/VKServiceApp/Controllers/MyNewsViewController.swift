//
//  MyNewsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 07/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import Kingfisher

class MyNewsViewController: UITableViewController{
  
    let service = NewsService()
    var myNews: [News] = []
    
    @IBOutlet weak var table: UITableView!

    @IBAction func valueChanged(_ sender: PhotoLike) {
        if let cell = sender.superview?.superview as? MyNewsViewCell {
            if let indexPath = tableView.indexPath(for: cell)?.row {
                if sender.flag == Flag.like {
                    if !myNews[indexPath].getMyLike() {
                        myNews[indexPath].setMyLike(value: true)
                        myNews[indexPath].setImageLikes(total: myNews[indexPath].getLikesCount() + 1)
                    } else if myNews[indexPath].getLikesCount() > 0 {
                        myNews[indexPath].setMyLike(value: false)
                        myNews[indexPath].setImageLikes(total: myNews[indexPath].getLikesCount() - 1)
                    }
                     cell.newsLikes.text = String(myNews[indexPath].getLikesCount())
                }
            }
        }
    }
    
    @IBAction func addedComments(_ sender: PhotoComment) {
        if let cell = sender.superview?.superview as? MyNewsViewCell {
            if let indexPath = tableView.indexPath(for: cell)?.row {
                if sender.option == Options.comment {
                    myNews[indexPath].setImageComments(total: myNews[indexPath].getCommentsCount() + 1)
                    myNews[indexPath].addComment(text: "one more comment " + String(describing: NSDate()))
                }
                 cell.newsComments.text = String(myNews[indexPath].getCommentsCount())
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromVk()
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        updateViewsCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myNewsCell.rawValue, for: indexPath) as! MyNewsViewCell
        let news = myNews[indexPath.row]
     
        cell.newsImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        cell.newsImage.isUserInteractionEnabled = true
        cell.newsImage.tag = indexPath.row
        
        cell.newsTitle.text = service.getPostAuthor(user: news.ownerId) + " \n" + news.getTitle()
        cell.newsImage.kf.setImage(with: URL(string: news.getImage()))        
        cell.newsLikes.text = String(news.getLikesCount())
        cell.newsComments.text = String(news.getCommentsCount())
        cell.newsViews.text = String(news.getViewsCount())
        heartBeatingAnimation(cell.heart, scale: 1.4)
        
        return cell
    }    
    
    func updateViewsCount(){
        for news in myNews {
            let count = news.getViewsCount() + 1
            news.setViews(total: count)
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let indexPath = NSIndexPath(row: sender.view!.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! MyNewsViewCell
        heartBeatingAnimation(cell.newsImage, scale: 0.4)        
    }
    
}


extension MyNewsViewController {
    
    func loadDataFromVk() {
        service.loadNewsDataWithAlamofire() { (news, error) in
            if let error = error {
                print(error)
            }
            if let news = news {
                self.myNews = self.filterNewsWithoutPhoto(news)
                self.tableView?.reloadData()
            }
        }
    }
    
    func filterNewsWithoutPhoto(_ origin: [News]) -> [News]{
        var res: [News] = []
        for i in origin {
            if i.getImage() != "" {
                res.append(i)
            }
        }
        return res
    }
    
}
