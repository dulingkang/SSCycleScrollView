//
//  FirstViewController.swift
//  SSCycleScrollDemo
//
//  Created by ShawnDu on 2016/11/24.
//  Copyright © 2016年 Shawn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "FirstViewController"
    }

}
