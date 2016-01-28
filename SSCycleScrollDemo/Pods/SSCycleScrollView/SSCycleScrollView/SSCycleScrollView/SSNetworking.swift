//
//  SSNetworking.swift
//  CycleScroll
//
//  Created by dulingkang on 21/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import Foundation

struct SSNetworking {
    
//    class var sharedInstance: SSNetworking {
//        struct Singleton {
//            static let instance = SSNetworking()
//        }
//        return Singleton.instance
//    }
    
    static func request(urlStr: String,sessionConfig: NSURLSessionConfiguration,complete: ((NSData?, NSURLResponse?, NSError?) -> Void)?) {
        let session = NSURLSession.init(configuration: sessionConfig)
        let task = session.dataTaskWithURL(NSURL(string: urlStr)!) { (data, response, error) -> Void in
            complete!(data, response, error)
        }
        task.resume()
    }
    
    static func request(urlStr: String,complete: ((NSData?, NSURLResponse?, NSError?) -> Void)?) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession.init(configuration: sessionConfig)
        let task = session.dataTaskWithURL(NSURL(string: urlStr)!) { (data, response, error) -> Void in
            complete!(data, response, error)
        }
        task.resume()
    }
    
    static func download(urlStr: String,complete: ((NSURL?, NSURLResponse?, NSError?) -> Void)?) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession.init(configuration: sessionConfig)
        let task = session.downloadTaskWithURL(NSURL(string: urlStr)!) { (storedUrl, response, error) -> Void in
            complete!(storedUrl, response, error)
        }
        task.resume()
    }

}