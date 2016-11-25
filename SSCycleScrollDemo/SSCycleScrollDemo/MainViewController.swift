//
//  MainViewController.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit
import SSCycleScrollView

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kScrollRect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight*0.8)
let kIphone4sScrollRect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight*0.94)

class MainViewController: UIViewController {
    
    var scrollImageUrls: [[String]] {
        get {
            return [["https://devthinking.com/images/wechatqcode.jpg", "banner4.jpg"],
                    ["banner1.jpg"],
                    ["banner3.jpg"]]
        }
    }
    var mainScrollView: SSCycleScrollView?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        self.addMainScrollView()
        self.addBottomView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - private method
    func addMainScrollView() {
        var currentRect = kScrollRect
        if kScreenHeight == 480 {
            currentRect = kIphone4sScrollRect
        }
        self.mainScrollView = SSCycleScrollView.init(frame: currentRect, animationDuration: 3, inputImageUrls: self.scrollImageUrls)
        self.mainScrollView?.tapBlock = {index in
            print("tapped page\(index)")
        }
//        self.mainScrollView?.autoScroll = false
        self.view.addSubview(self.mainScrollView!)
    }
    
    func addBottomView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: kScreenHeight/2, width: kScreenWidth, height: kScreenHeight/2))
        imageView.image = UIImage(named: "mainBottomBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.imageViewTapped))
        imageView.addGestureRecognizer(tap)
        self.view.addSubview(imageView)
    }
    
    func imageViewTapped() {
        navigationController?.pushViewController(FirstViewController(), animated: true)
    }
}
