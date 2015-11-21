//
//  SSImageDownloadModel.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit

class SSImageDownloadItem: NSObject {
    var imageUrl: NSString
    var md5: NSString
    var jumpUrl: NSString?
    var jumpView: NSString?
    var imageCachePath: NSString? //when download image, add image cache path
    
    init(dict: NSDictionary) {
        self.imageUrl = dict["imageUrl"] as! NSString
        self.md5 = dict["md5"] as! NSString
        self.jumpUrl = dict["jumpUrl"] as? NSString
        self.jumpView = dict["jumpView"] as? NSString
        self.imageCachePath = dict["imageCachePath"] as? NSString
    }
}

class SSImageDownloadModel: NSObject {
    var imageList: [SSImageDownloadItem] = []
    var imageListPlistPath: NSString!
    
    override init() {
        super.init()
        self.initImageList()
    }
    
    private func initImageList() {
        self.createImageListPlist()
    }
    
    private func createImageListPlist() {
        let ssFileManager = SSImageFileManager.sharedInstance
        if ssFileManager.createImagePlist() {
            let fetchedArray = NSMutableArray(contentsOfFile: ssFileManager.imagePlistPath)
            for dict in fetchedArray! {
                let imageItem = SSImageDownloadItem(dict: dict as! NSDictionary)
                self.imageList.append(imageItem)
            }
        } else {
            print("error: create plist failed & have none plist stored")
        }
    }
    
}