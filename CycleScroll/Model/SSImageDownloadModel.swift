//
//  SSImageDownloadModel.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit

let kImageListPlistName = "imageDownload.plist"

struct SSImageDownloadItem {
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

struct SSImageDownloadModel {
    var imageList: [SSImageDownloadItem] = []
    var imageListPlistPath: NSString!
    
    init() {
        self.initImageList()
    }
    
    private func initImageList() {
        self.createImageListPlist()
    }
    
    private func createImageListPlist() {
        let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let path = dir.stringByAppendingPathComponent(kImageListPlistName)
        let fileManager = NSFileManager.defaultManager()
        if (!fileManager.fileExistsAtPath(path)) {
            if let bundleImagePath = NSBundle.mainBundle().pathForResource("imageDownload", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundleImagePath)
                print(resultDictionary)
                
                do {
                    try fileManager.copyItemAtPath(bundleImagePath, toPath: path)
                } catch {
                    print("copy bundle error")
                }
                
            } else {
                print("imageDownload.plist not found, make sure it is part of the bundle")
            }
        }
    }
}