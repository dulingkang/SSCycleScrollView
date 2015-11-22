//
//  SSDownloadManager.swift
//  CycleScroll
//
//  Created by dulingkang on 22/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import Foundation

let mainScrollURL = "http://www.zhkhy.com/xiaoka/mainscrollview/ios1.2.1/mainscrollviewinfo_ios_1.2.1.json"

class SSDownloadManager: NSObject {
    
    let ssFileManager = SSImageFileManager.sharedInstance
    let ssImageModel = SSImageDownloadModel.sharedInstance
    
    class var sharedInstance: SSDownloadManager {
        struct Singleton {
            static let instance = SSDownloadManager()
        }
        return Singleton.instance
    }
    
    func request(urlStr: String, complete: ((Bool, NSError?) -> Void)) {
        SSNetworking.request(urlStr, sessionConfig: NSURLSessionConfiguration.ephemeralSessionConfiguration()) { (data, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if data != nil {
                    do {
                        let parsedObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        if let imageList = parsedObject as? NSArray {
                            if imageList.count > 0 {
                                self.ssFileManager.updateImagePlist(imageList)
                                if self.ssImageModel.isNeedDownloadImage()
                                complete(true, error)
                            }
                        }
                    } catch {
                        print("parseJsonError")
                    }

                }
            }
        }
    }
    
    func download(urlStr: String, uniqueId: String, complete: ((Bool, NSError?) -> Void)?) {
        
    }
    
    func downloadWithId(urlStr: String, uniqueId: String, complete: ((NSURL?, NSURLResponse?, NSError?) -> Void)?) {
        SSNetworking.download(urlStr) { (storedUrl, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                self.ssFileManager.updateImagePlist(uniqueId, imageUrl: storedUrl!)
            }
        }
    }
}
