//
//  SSImageFileManager.swift
//  CycleScroll
//
//  Created by dulingkang on 21/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import Foundation

let kImageListPlistName = "imageDownload.plist"

class SSImageFileManager: NSObject {
    var imagePlistPath: String!
    let fileManager = NSFileManager.defaultManager()
    let imageModel = SSImageDownloadModel.sharedInstance
    
    class var sharedInstance: SSImageFileManager {
        struct Singleton {
            static let instance = SSImageFileManager()
        }
        return Singleton.instance
    }
    
    func createImagePlist() -> (Bool) {
        let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        self.imagePlistPath = dir.stringByAppendingPathComponent(kImageListPlistName)
        
        //plist not exist, copy plist in bundle to the path
        if (!fileManager.fileExistsAtPath(self.imagePlistPath!)) {
            if let bundleImagePath = NSBundle.mainBundle().pathForResource("imageDownload", ofType: "plist") {
                let resultArray = NSMutableArray(contentsOfFile: bundleImagePath)
                print(resultArray)
                
                do {
                    try fileManager.copyItemAtPath(bundleImagePath, toPath: self.imagePlistPath!)
                    return true
                } catch {
                    print("copy bundle image download plist error")
                    return false
                }
                
            } else {
                print("imageDownload.plist not found, make sure it is part of the bundle")
                return false
            }
        } else {
            print("imagePlist already exist")
            return true
        }
    }
    
    func updateImagePlist(uniqueId: String, imageUrl: NSURL) {
        let modelArray = NSMutableArray(contentsOfFile: self.imagePlistPath)
        for item in modelArray! {
            if let imageItem = item as? NSMutableDictionary {
                let index = imageModel.findItemWithMD5((imageItem["md5"] as? String)!)
                if index != -1 {
                    imageItem.setObject(imageUrl, forKey: "imageCachePath")
                    modelArray?.replaceObjectAtIndex(index, withObject: imageItem)
                }
            }
        }
        modelArray?.writeToFile(self.imagePlistPath, atomically: true)
    }
    
    func updateImagePlist(imageListArray: NSArray) {
        let sourceModelArray = NSMutableArray(contentsOfFile: self.imagePlistPath)
        let newImageListArray: NSMutableArray = []
        
        //new items in remote imageListArray insert to plist
        let index = imageModel.findItemUsingArray(imageListArray)
        if index != -1 {
            newImageListArray.addObject(imageModel.imageList[index])
        }
        
        if newImageListArray.count > 0 {
            newImageListArray.writeToFile(self.imagePlistPath, atomically: true)
            imageModel.updateModel()
        }
        
        //delete the unused cache image
        for item in sourceModelArray! {
            if let imageItem = item as? NSDictionary {
                let index = imageModel.findItemWithMD5((imageItem["md5"] as? String)!)
                if index != -1 {
                    do {
                        try fileManager.removeItemAtURL(NSURL(string: (imageItem["imageCachePath"] as? String)!)!)
                    } catch {
                        print("remove cache image error")
                    }
                    
                }
            }
        }
    }
}


