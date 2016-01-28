//
//  SSDownloadManager.swift
//  CycleScroll
//
//  Created by dulingkang on 22/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import Foundation

public class SSDownloadManager: NSObject {
    
    public static let sharedInstance = SSDownloadManager()
    override init() {
        super.init()
    }
    
    public func request(urlStr: String, requestComplete: ((Bool, NSError?) -> Void)) {
        SSNetworking.request(urlStr, sessionConfig: NSURLSessionConfiguration.ephemeralSessionConfiguration()) { (data, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if data != nil {
                    do {
                        let parsedObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        if let imageDict = parsedObject as? NSDictionary {
                            let imageList = imageDict[mainScrollKey] as! NSArray
                            if imageList.count > 0 {
                                SSImageFileManager.sharedInstance.updateImagePlist(imageList)
                                if let indexArray = SSImageFileManager.sharedInstance.needDownloadImageAtIndexs() {
                                    if indexArray.count > 0 {
                                        var count = 0
                                        for index in indexArray {
                                            if let item = SSImageFileManager.sharedInstance.fetchItemAtIndex((index as? Int)!) {
                                                self.downloadWithId((item[imageUrlKey] as? String)!, uniqueId: (item[md5Key] as? String)!, complete: { (success, downloadError) -> Void in
                                                    if success {
                                                        count++
                                                        if count == indexArray.count {
                                                            requestComplete(true, error)
                                                        }
                                                    }
                                                })
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("parseJsonError")
                    }

                }
            }
        }
    }
    
    func downloadWithId(urlStr: String, uniqueId: String, complete: ((Bool, NSError?) -> Void)?) {
        SSNetworking.request(urlStr, sessionConfig: NSURLSessionConfiguration.ephemeralSessionConfiguration()) { (data, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                let fileManager = NSFileManager.defaultManager()
                let  destinationPath = SSImageFileManager.sharedInstance.imageCachePath + "/" + uniqueId + ".jpg"
                if fileManager.fileExistsAtPath(destinationPath) {
                    do {
                        try fileManager.removeItemAtPath(destinationPath)
                    } catch {
                        print("remove downloaded image failed!")
                    }
                } else {
                    data?.writeToFile(destinationPath, atomically: true)
//                    SSImageFileManager.sharedInstance.updateImagePlist(uniqueId)
                    complete!(true, error)
                }
            }
        }
    }
//    func downloadWithId(urlStr: String, uniqueId: String, complete: ((Bool, NSError?) -> Void)?) {
//        SSNetworking.download(urlStr) { (storedUrl, response, error) -> Void in
//            if error != nil {
//                print(error)
//            } else {
//                SSImageFileManager.sharedInstance.updateImagePlist(uniqueId, imageUrl: storedUrl!)
//                let folderPath = SSImageFileManager.sharedInstance.imageCachePath
//                let destinationPath = folderPath + "/" + "1.jpg"
//                do {
//                    try
//                        NSFileManager.defaultManager().copyItemAtPath(String(storedUrl), toPath: destinationPath)
//
//                } catch {
//                    print("move tmp download image from path:", storedUrl, "toPath:", destinationPath, "failed!")
//                }
//                complete!(true, error)
//            }
//        }
//    }
}
