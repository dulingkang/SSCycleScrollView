//
//  SSImageFileManager.swift
//  CycleScroll
//
//  Created by dulingkang on 21/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import Foundation

let kImageListPlistName = "imageDownload.plist"
let kCacheFolderName = "imageCache"

class SSImageFileManager: NSObject {
    var imagePlistPath: String!
    var imageCachePath: String!
    let fileManager = NSFileManager.defaultManager()
    
    override init() {
        super.init()
        self.createImagePlist()
        self.createImageCacheFolder()
    }
    
    class var sharedInstance: SSImageFileManager {
        struct ssFileManager {
            static let instance = SSImageFileManager()
        }
        return ssFileManager.instance
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
                    print ("copy to imagePlistPath:", self.imagePlistPath)
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
            print("imagePlist already exist:", self.imagePlistPath)
            return true
        }
    }
    
    func createImageCacheFolder() -> (Bool) {
        let dir: NSString = NSTemporaryDirectory()
        self.imageCachePath = dir.stringByAppendingPathComponent(kCacheFolderName)
        
        if (!fileManager.fileExistsAtPath(self.imageCachePath)) {
            do {
                try fileManager.createDirectoryAtPath(self.imageCachePath, withIntermediateDirectories: true, attributes: nil)
                return true
                
            } catch {
                print("create cache folder failed")
                return false
            }
        } else {
            print("imageCache folder already exist:", self.imageCachePath)
            return true
        }
    }

    
    func findItemWithUniqueId(uniqueId: String) -> Int {
        let modelArray = NSMutableArray(contentsOfFile: self.imagePlistPath)
        var count = -1
        for item in modelArray! {
            count++
            if let imageItem = item as? NSMutableDictionary {
                if imageItem[md5Key] as? String == uniqueId {
                    return count
                } else {
                    print("SSImageFileManager not found the unique id:", uniqueId)
                    return -1
                }
            }
        }
        return -1
    }
    
    func updateImagePlist(uniqueId: String, cachePath: String) {
        let modelArray = NSMutableArray(contentsOfFile: self.imagePlistPath)
        let index = self.findItemWithUniqueId(uniqueId)
        if index != -1 {
            if let dict = modelArray![index] as? NSDictionary {
                dict.setValue(cachePath, forKey: uniqueId)
                modelArray?.replaceObjectAtIndex(index, withObject: dict)
                print("update Image list, model Array:", modelArray)
                modelArray?.writeToFile(self.imagePlistPath, atomically: true)
                SSImageDownloadModel.sharedInstance.updateModel(true)
            }
        }
    }
    
    func updateImagePlist(imageListArray: NSArray) {
        let sourceModelArray = NSMutableArray(contentsOfFile: self.imagePlistPath)
        let newImageListArray: NSMutableArray = []
        
        //new items in remote imageListArray insert to plist
        for item in imageListArray {
            if let imageItem = item as? NSDictionary {
                let index = self.findItemWithUniqueId((imageItem[md5Key] as? String)!)
                if index == -1 {
                    newImageListArray.addObject(imageItem)
                }
            }
        }
        
        if newImageListArray.count > 0 {
            newImageListArray.writeToFile(self.imagePlistPath, atomically: true)
            print("update Image plist", imageListArray)
            SSImageDownloadModel.sharedInstance.updateModel(false)
        }
        
        //delete the unused cache image
        for item in sourceModelArray! {
            if let imageItem = item as? NSDictionary {
                let index = self.findItemWithUniqueId((imageItem[md5Key] as? String)!)
                if index == -1 {
                    if let cachePath = imageItem[imageCachePathKey] as? String {
                        if  cachePath.characters.count > 0 {
                            do {
                                try fileManager.removeItemAtPath((imageItem[imageCachePathKey] as? String)!)
                            } catch {
                                print("remove cache image error")
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
}


