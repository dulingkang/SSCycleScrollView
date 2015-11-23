//
//  MainViewController.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit

let kMainScrollURL = "http://www.zhkhy.com/xiaoka/mainscrollview/ios1.2.1/mainscrollviewinfo_ios_1.2.1.json"
let kScreenWidth = UIScreen.mainScreen().bounds.width
let kScreenHeight = UIScreen.mainScreen().bounds.height
let kScrollRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.8)
let kIphone4sScrollRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.94)

class MainViewController: UIViewController {
    
    var scrollImageArray: [UIImage] = []
    var mainScrollView: SSCycleScrollView?
    
    //MARK: - life cycle
    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        SSDownloadManager.sharedInstance.request(kMainScrollURL) { (finished, error) -> Void in
            if finished {
                print("download image finished")
            }
        }
        self.addMainScrollView()
        self.addBottomView()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadScrollImageArray", name: kImageModelUpdateNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kImageModelUpdateNotification, object: nil)
    }
    
    //MARK: - private method
    func addMainScrollView() {
        self.reloadScrollImageArray()
        var currentRect = kScrollRect
        if kScreenHeight == 480 {
            currentRect = kIphone4sScrollRect
        }
        if self.scrollImageArray.count < 1 {
            if let image = UIImage(named: "defaultBackground.jpg") {
                self.scrollImageArray.append(image)
            }
        }
        if self.scrollImageArray.count < 1 {
            print("scrollImageArray can not be nil, make sure you can reach the internet or you have defaultBackground.jpg image")
        } else {
            self.mainScrollView = SSCycleScrollView.init(frame: currentRect, animationDuration: 3, inputImageArray: self.scrollImageArray)
            self.view.addSubview(self.mainScrollView!)
        }
    }
    
    func addBottomView() {
        //Use layer can be more light
        let layer = CALayer()
        layer.frame = CGRectMake(0, kScreenHeight/2, kScreenWidth, kScreenHeight/2)
        layer.contents = UIImage(named: "mainBottomBackground.jpg")?.CGImage
        layer.contentsGravity = kCAGravityResizeAspectFill
        self.view.layer.addSublayer(layer)
    }
    
    func reloadScrollImageArray() {
        let imageModel = SSImageDownloadModel.sharedInstance
        let imageCount = imageModel.imageList.count
        self.scrollImageArray.removeAll()
        if imageCount > 0 {
            for item in imageModel.imageList {
                if let imageUrl = item.imageCachePath {
                    if imageUrl.characters.count > 0 {
                        if let image = UIImage.init(contentsOfFile:imageUrl) {
                            self.scrollImageArray.append(image)
                        }
                    }
                }
            }
        }
        if self.scrollImageArray.count > 0 {
             self.mainScrollView?.allImageArray = self.scrollImageArray
        }
    }
}
