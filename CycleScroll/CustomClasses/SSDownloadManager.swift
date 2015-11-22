//
//  SSDownloadManager.swift
//  CycleScroll
//
//  Created by dulingkang on 22/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import Foundation

class SSDownloadManager: NSObject {
    
    let ssFileManager = SSImageFileManager.sharedInstance
    let ssImageModel = SSImageDownloadModel.sharedInstance
    
    override init() {
        super.init()
    }
    
    class var sharedInstance: SSDownloadManager {
        struct ssDownload {
            static let instance = SSDownloadManager()
        }
        return ssDownload.instance
    }
    
    func request(urlStr: String, requestComplete: ((Bool, NSError?) -> Void)) {
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
                                if let indexArray = self.ssImageModel.needDownloadImageAtIndexs() {
                                    if indexArray.count > 0 {
                                        var count = 0
                                        for index in indexArray {
                                            let item = self.ssImageModel.imageList[index as! Int]
                                            self.downloadWithId(item.imageUrl, uniqueId: item.md5, complete: { (success, downloadError) -> Void in
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
                    } catch {
                        print("parseJsonError")
                    }

                }
            }
        }
    }
    
    func downloadWithId(urlStr: String, uniqueId: String, complete: ((Bool, NSError?) -> Void)?) {
        SSNetworking.download(urlStr) { (storedUrl, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                self.ssFileManager.updateImagePlist(uniqueId, imageUrl: storedUrl!)
                complete!(true, error)
            }
        }
    }
}
