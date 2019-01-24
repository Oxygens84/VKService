//
//  MyNewsExtensionController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 25/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

extension MyNewsViewController {
    
    func loadDataFromVk() {
        service.loadNewsPostWithAlamofire() { (news, error) in
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
    
    func updateViewsCount(){
        for news in myNews {
            news.setViews(total: news.getViewsCount() + 1)
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadDataFromVk()
    }
    
    @objc func handlerRefresh(){
        loadDataFromVk()
        refresher.endRefreshing()
    }
    
    func addRefresher(){
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.tintColor = UIColor.purple
        refresher.addTarget(self, action: #selector(handlerRefresh), for: .valueChanged)
    }
}
