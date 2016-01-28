//
//  SSImageDownloadModel.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit

/************************ Please custom your own json, the demo json:
{
    "scrollview_pics":[
    {
    "Url":"http://www.zhkhy.com/xiaoka/mainscrollview/ios1.2.1/show_time.jpg",
    "MD5":"CCD5004A25F81C49D6DB7318C42CD33D",
    "JumpView":"0"
    "JumpUrl":"http://www.baidu.com"
    },
    {
    "Url":"http://www.zhkhy.com/xiaoka/mainscrollview/ios1.2.1/happy_winter_background1.jpg",
    "MD5":"4F2B301E4C5DCC37BCD76C1D532CBF90",
    "JumpView":"0"
    }
    ]
}
************************/

/************* The key in plist, also from json *************/
let mainScrollKey = "scrollview_pics"
let imageUrlKey = "Url"
let md5Key = "MD5"
let jumpUrlKey = "JumpUrl"
let jumpViewKey = "JumpView"
let imageCachePathKey = "ImageCachePath"

let kImageModelUpdateNotification = "kImageDownloadNotification"

public class SSImageDownloadItem: NSObject {
/************* custom model, add one more imageCachePath *************/
    var imageUrl: String
    var md5: String
    var jumpUrl: String?
    var jumpView: String?
    public var imageCachePath: String? //when download image, add image cache path
    
    init(dict: NSDictionary) {
        self.imageUrl = dict[imageUrlKey] as! String
        self.md5 = dict[md5Key] as! String
        self.jumpUrl = dict[jumpUrlKey] as? String
        self.jumpView = dict[jumpViewKey] as? String
        self.imageCachePath = SSImageFileManager.sharedInstance.imageCachePath + "/" + self.md5 + ".jpg"
    }
}

public class SSImageDownloadModel: NSObject {
    public var imageList: [SSImageDownloadItem] = []
    public static let sharedInstance = SSImageDownloadModel()
    override init() {
        super.init()
        self.createImageListModel()
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
    
    func updateModel() {
        self.createImageListModel()
    }
    
}


