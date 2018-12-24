//
//  MyNewsExtensionController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 25/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

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
            let count = news.getViewsCount() + 1
            news.setViews(total: count)
        }
    }
    
}
