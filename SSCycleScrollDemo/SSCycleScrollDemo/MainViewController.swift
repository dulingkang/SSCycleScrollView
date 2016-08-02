//
//  MainViewController.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit
import SSCycleScrollView

/*************** 使用请改变成自己服务器的url地址，自己配置json文件 ***************/
let kScreenWidth = UIScreen.mainScreen().bounds.width
let kScreenHeight = UIScreen.mainScreen().bounds.height
let kScrollRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.8)
let kIphone4sScrollRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.94)

class MainViewController: UIViewController {
    
    var scrollImageUrls: [String] {
        get {
            return ["banner1.jpg", "http://www.zhkhy.com/xiaoka/mainscrollview/ios1.2.1/happy_winter_background1.jpg", "banner3.jpg", "banner4.jpg"]
        }
    }
    var mainScrollView: SSCycleScrollView?
    
    //MARK: - life cycle
    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        self.addMainScrollView()
        self.addBottomView()
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
        //Use layer can be more light
        let layer = CALayer()
        layer.frame = CGRectMake(0, kScreenHeight/2, kScreenWidth, kScreenHeight/2)
        layer.contents = UIImage(named: "mainBottomBackground")?.CGImage
        layer.contentsGravity = kCAGravityResizeAspectFill
        self.view.layer.addSublayer(layer)
    }
}
