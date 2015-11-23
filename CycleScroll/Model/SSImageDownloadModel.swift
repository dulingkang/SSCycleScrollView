//
//  SSImageDownloadModel.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit

//the key in plist
let mainScrollKey = "scrollview_pics"
let imageUrlKey = "Url"
let md5Key = "MD5"
let jumpUrlKey = "JumpUrl"
let jumpViewKey = "JumpView"
let imageCachePathKey = "ImageCachePath"

let kImageModelUpdateNotification = "kImageDownloadNotification"

class SSImageDownloadItem: NSObject {
    var imageUrl: String
    var md5: String
    var jumpUrl: String?
    var jumpView: String?
    var imageCachePath: String? //when download image, add image cache path
    
    init(dict: NSDictionary) {
        self.imageUrl = dict[imageUrlKey] as! String
        self.md5 = dict[md5Key] as! String
        self.jumpUrl = dict[jumpUrlKey] as? String
        self.jumpView = dict[jumpViewKey] as? String
        self.imageCachePath = dict[imageCachePathKey] as? String
    }
}

class SSImageDownloadModel: NSObject {
    var imageList: [SSImageDownloadItem] = []
    
    override init() {
        super.init()
        self.createImageListModel()
    }
    
    class var sharedInstance: SSImageDownloadModel {
        struct ssModel {
            static let instance = SSImageDownloadModel()
        }
        return ssModel.instance
    }
    
    private func createImageListModel() {
        let ssFileManager = SSImageFileManager.sharedInstance
        if ssFileManager.createImagePlist() {
            let fetchedArray = NSMutableArray(contentsOfFile: ssFileManager.imagePlistPath)
            if fetchedArray?.count > 0 {
                self.imageList.removeAll()
                for dict in fetchedArray! {
                    let imageItem = SSImageDownloadItem(dict: dict as! NSDictionary)
                    self.imageList.append(imageItem)
                }
            }
        } else {
            print("error: create plist failed & have none plist stored")
        }
    }
    
    func findItemWithMD5(uniqueID: String) -> Int {
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
    
    func updateModel(needNotify: Bool) {
        self.createImageListModel()
        if needNotify {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(kImageModelUpdateNotification, object: nil)
            });
        }
    }
    
    func needDownloadImageAtIndexs() -> NSArray? {
        let indexsArray: NSMutableArray = []
        var index = -1
        for item in self.imageList {
            index++
            if self.isNeedDownloadImage(item.md5) {
                indexsArray.addObject(index)
            }
        }
        if indexsArray.count > 0 {
            return indexsArray
        } else {
            return nil;
        }
    }
    
    func isNeedDownloadImage(uniqueId: String) -> Bool {
        let index = self.findItemWithMD5(uniqueId)
        if index != -1 {
            if let cachePath = self.imageList[index].imageCachePath {
                if cachePath.characters.count > 0 {
                    return false
                } else {
                    return true
                }
                
            } else {
                return true
            }
            
        } else {
            print("not found unique id in plist")
            return false
        }
    }
}


