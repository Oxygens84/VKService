//
//  TodayViewController.swift
//  VKwidget
//
//  Created by Oxana Lobysheva on 08/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    private let dataService = DataService()
    
    var friends: [Friend]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friends = dataService.friends
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else {
            let newHeight = CGFloat(friends!.count * 44 + 66)
            self.preferredContentSize = CGSize(width: maxSize.width, height: newHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if (friends?.count)! > 0 {
            let friend = friends![indexPath.row]
            cell.textLabel!.text = friend.friend
        } else {
            cell.textLabel!.text = "no data"
        }
        return cell
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {

        completionHandler(NCUpdateResult.newData)
    }
    
}
