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
    
    class var sharedInstance: SSImageDownloadModel {
        struct Singleton {
            static let instance = SSImageDownloadModel()
        }
        return Singleton.instance
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
    
    func findItemWithMD5(uniqueID: NSString) -> Int {
        var index: Int = -1
        for item in self.imageList {
            index++
            if item.md5 == uniqueID {
                return index
            } else {
                continue
            }
        }
        return -1
    }
    
    func findItemUsingArray(usingArray: NSArray) -> Int {
        for item in usingArray {
            if let imageItem = item as? NSDictionary {
                let index = self.findItemWithMD5((imageItem["md5"] as? String)!)
                return index
            }
        }
        return -1
    }
    
    func updateModel() {
        self.createImageListPlist()
    }
    func isNeedDownloadImage(uniqueId: NSString) -> Bool {
        let index = self.findItemWithMD5(uniqueId)
        if index != -1 {
            if self.imageList[index].imageCachePath?.length != 0 {
                return false
            } else {
                return true
            }
        } else {
            print("not found unique id in plist")
            return false
        }
        
    }
}


