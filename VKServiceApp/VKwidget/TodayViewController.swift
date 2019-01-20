//
//  TodayViewController.swift
//  VKwidget
//
//  Created by Oxana Lobysheva on 08/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import NotificationCenter
import Kingfisher

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var sharedDefaults = UserDefaults(suiteName: "group.ru.vkServiceApp")
    
    let baseUrl = "https://api.vk.com/method/"
    var version: String = "5.92"
    
    var news: [News]? = []
    
    override func viewDidLoad() {
        loadDataFromVk()
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else {
            let newHeight = CGFloat(news!.count * 110)
            self.preferredContentSize = CGSize(width: maxSize.width, height: newHeight)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
        
}


extension TodayViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //prod
        //return news.count
        //test
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNewsWidgetCell", for: indexPath) as! NewsWidgetViewCell
        
        //prod
        //let news = self.news?[indexPath.row]
        //cell.newsTitle.text = news!.getTitle()
        //cell.newsImage.kf.setImage(with: URL(string: news!.getImage()))
        //test
        cell.newsImage.image = UIImage(named: "Unknown")
        cell.newsTitle.text = "test"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

