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
import Alamofire
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    var sharedDefaults = UserDefaults(suiteName: "group.ru.vkServiceApp")
    
    let baseUrl = "https://api.vk.com/method/"
    var version: String = "5.92"
    
    
    private let dataService = DataService()
    private let newsService = NewsService()
    var news: [News]? = []
    
    @IBOutlet weak var newsCount: UILabel!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        loadDataFromVk()
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        newsCount.text = "Last news : " + String(news!.count)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
            //if news!.count > 0 {
            //    newsCount.text = news![0].getTitle()
            //}
        } else {
            let newHeight = CGFloat(news!.count * 44 + 66)
            self.preferredContentSize = CGSize(width: maxSize.width, height: newHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myNewsWidgetCell.rawValue, for: indexPath) as! NewsWidgetViewCell
        let news = self.news?[indexPath.row]

        cell.newsTitle.text = news!.getTitle()
        cell.newsImage.kf.setImage(with: URL(string: news!.getImage()))

        return cell
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func loadDataFromVk() {
        loadNewsWithAlamofire() { (news, error) in
            if let error = error {
                print(error)
            }
            if let news = news {
                self.news = news
                for i in news {
                    print(i.getTitle())
                }
            }
        }
    }
    
    func loadNewsWithAlamofire(completion: (([News]?, Error?) -> Void)?) {
        let method = "newsfeed.get"
        let parameters: Parameters = [
            "extended": 1,
            "filters": NewsType.post,
            "count": 5,
            "access_token": sharedDefaults?.string(forKey: DefaultKey.tokenField) ?? "noKey",
            "v": version
        ]
        let url = baseUrl + method
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{(response) in
            if let error = response.error {
                completion?(nil, error)
                return
            }
            if let value = response.data, let json = try? JSON(data: value){
                let news = json["response"]["items"].arrayValue.map{ News(json: $0) }
                completion?(news, nil)
            }
        }
    }
}
