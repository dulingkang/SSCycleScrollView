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
    
    class var sharedInstance: SSImageFileManager {
        struct Singleton {
            static let instance = SSImageFileManager()
        }
        return Singleton.instance
    }
    
    func createImagePlist() -> (Bool) {
        let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        self.imagePlistPath = dir.stringByAppendingPathComponent(kImageListPlistName)
        let fileManager = NSFileManager.defaultManager()
        
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
}