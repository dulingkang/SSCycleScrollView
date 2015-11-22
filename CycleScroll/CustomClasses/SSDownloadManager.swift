//
//  SSDownloadManager.swift
//  CycleScroll
//
//  Created by dulingkang on 21/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import Foundation

public protocol URLStringConvertible {
    var URLString: String { get }
}

extension String: URLStringConvertible {
    public var URLString: String {
        return self
    }
}

extension NSURL: URLStringConvertible {
    public var URLString: String {
        return absoluteString
    }
}

class SSDownloadManager: NSObject {
    
    class var sharedInstance: SSDownloadManager {
        struct Singleton {
            static let instance = SSDownloadManager()
        }
        return Singleton.instance
    }
    
    func ephemeralRequest(urlStr: URLStringConvertible, complete: ((NSData?, NSURLResponse?, NSError?) -> Void)?) {
        let sessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession.init(configuration: sessionConfig)
        let task = session.dataTaskWithURL(NSURL(string: urlStr.URLString)!) { (data, response, error) -> Void in
            complete!(data, response, error)
        }
        task.resume()
    }

}