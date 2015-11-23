//
//  MainViewController.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit

let mainScrollURL = "http://www.zhkhy.com/xiaoka/mainscrollview/ios1.2.1/mainscrollviewinfo_ios_1.2.1.json"

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        SSDownloadManager.sharedInstance.request(mainScrollURL) { (finished, error) -> Void in
            if finished {
                print("download image finished")
            }
        }
        self.view.backgroundColor = UIColor.whiteColor()

    }
}
