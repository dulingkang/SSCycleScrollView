//
//  SSCycleScrollView.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit
import SDWebImage

public typealias tapActionBlock = (Int) -> ()

open class SSCycleScrollView: UIScrollView, UIScrollViewDelegate {
    var currentArrayIndex: Int!
    var animationDuration: TimeInterval!
    var animationTimer: Timer?
    var currentDisplayView: UIImageView?
    var lastDisplayView: UIImageView?
    var previousDisplayView: UIImageView?
    open var allImageUrls: [[String]] = [[]]
    open var autoScroll = true {
        didSet {
            if !autoScroll {
                cancelTimer()
            }
        }
    }
    open var tapBlock: tapActionBlock?
    let kScreenWidth = UIScreen.main.bounds.size.width
    let kScreenHeight = UIScreen.main.bounds.size.height
    var needScroll = true
    
    //MARK: - init method
    public init(frame: CGRect, animationDuration: TimeInterval, inputImageUrls: [[String]]) {
        super.init(frame: frame)
        self.animationDuration = animationDuration
        self.currentArrayIndex = 1
        if inputImageUrls.count < 1 {
            print("inputImageUrls can not be nil!")
            return
        }
        if inputImageUrls.count == 1 {
            needScroll = false
            self.currentArrayIndex = 0
        }
        allImageUrls = inputImageUrls
        self.configScrollView(frame)
    }
    
    fileprivate func configScrollView(_ frame: CGRect) {
        self.autoresizesSubviews = true
        self.contentMode = UIViewContentMode.center
        self.contentSize = CGSize(width: 3 * frame.width, height: frame.height)
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.delegate  = self
        self.isPagingEnabled = true
        
        
        self.currentDisplayView = UIImageView.init(frame:  CGRect(x: frame.width, y: frame.origin.y, width: frame.width, height: frame.height))
        self.previousDisplayView = UIImageView.init(frame: CGRect(x: 0, y: frame.origin.y, width: frame.width, height: frame.height))
        self.lastDisplayView = UIImageView.init(frame: CGRect(x: 2 * frame.width, y: frame.origin.y, width: frame.width, height: frame.height))
        self.currentDisplayView?.isUserInteractionEnabled = true
        self.previousDisplayView?.isUserInteractionEnabled = true
        self.lastDisplayView?.isUserInteractionEnabled = true
        self.currentDisplayView?.contentMode = .scaleAspectFill
        self.previousDisplayView?.contentMode = .scaleAspectFill
        self.lastDisplayView?.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(SSCycleScrollView.tapAction(_:)))
        self.addGestureRecognizer(tap)
        self.addSubview(currentDisplayView!)
        self.addSubview(previousDisplayView!)
        self.addSubview(lastDisplayView!)
        
        self.contentOffset = CGPoint(x: frame.width, y: 0)
        
        self.configDisplayViews()
        if needScroll {
            self.createScrollTimer()
        }
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    //MARK: - Scrollview delegate
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoScroll {
            self.animationTimer?.fireDate = Date.distantFuture
        }
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll {
            self.createScrollTimer()
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.contentOffset.x >= (2 * self.frame.width){
            self.currentArrayIndex = self.getArrayIndex(self.currentArrayIndex + 1)
            self.configDisplayViews()
        } else if self.contentOffset.x <= 0 {
            self.currentArrayIndex = self.getArrayIndex(self.currentArrayIndex - 1)
            self.configDisplayViews()
        }
    }
    
    //MARK: - event response
    func timerFired() {
        let xOffset = Int(self.contentOffset.x/kScreenWidth)
        let xOffsetFloat = CGFloat(xOffset) * kScreenWidth
        let newOffset = CGPoint(x: xOffsetFloat + self.frame.width, y: self.contentOffset.y)
        self.setContentOffset(newOffset, animated: true)
    }
    
    func tapAction(_ tap: UITapGestureRecognizer) {
        if (self.tapBlock != nil) {
            self.tapBlock!(self.currentArrayIndex)
        }
    }
    
    //MARK: - public method
    func createScrollTimer() {
        self.animationTimer?.invalidate()
        self.animationTimer = Timer.scheduledTimer(timeInterval: self.animationDuration, target: self, selector: #selector(SSCycleScrollView.timerFired), userInfo: nil, repeats: true)
    }
    
    //MARK: - private method
    func configDisplayViews() {
        let previousArrayIndex = self.getArrayIndex(self.currentArrayIndex - 1)
        let lastArrayIndex = self.getArrayIndex(self.currentArrayIndex + 1)
        configPreviousDisplayView(previousArrayIndex: previousArrayIndex)
        configCurrentDisplayView()
        configLastDisplayView(lastArrayIndex: lastArrayIndex)
        self.contentOffset = CGPoint(x: self.frame.width, y: 0)
    }
    
    func cancelTimer() {
        self.animationTimer?.invalidate()
        self.animationTimer = nil
    }
    
    func getArrayIndex(_ currentIndex: Int) -> Int{
        if currentIndex == -1 {
            return allImageUrls.count - 1
        } else if currentIndex == allImageUrls.count {
            return 0
        } else {
            return currentIndex
        }
    }
    
    func configPreviousDisplayView(previousArrayIndex: Int) {
        let (webUrl, image) = decodeAllImageUrls(index: previousArrayIndex)
        if webUrl != nil && image != nil {
            self.previousDisplayView?.sd_setImage(with: webUrl, placeholderImage: image)
        } else if image == nil {
            self.previousDisplayView?.sd_setImage(with: webUrl)
        } else if webUrl == nil {
            self.previousDisplayView?.image = image
        }
    }
    
    func decodeAllImageUrls(index: Int) -> (webUrl: URL?, image: UIImage?) {
        var webUrl: URL?
        var image: UIImage?
        let firstString = allImageUrls[index][0]
        if firstString.hasPrefix("http") {
            webUrl = URL(string: firstString)
            if allImageUrls[index].count > 1 {
                if let img = UIImage(named: allImageUrls[index][1]) {
                    image = img
                }
            }
        } else {
            if let img = UIImage(named: firstString) {
                image = img
            }
        }
        return (webUrl, image)
    }
    
    func configCurrentDisplayView() {
        let (webUrl, image) = decodeAllImageUrls(index: currentArrayIndex)
        if webUrl != nil && image != nil {
            self.currentDisplayView?.sd_setImage(with: webUrl, placeholderImage: image)
        } else if image == nil {
            self.currentDisplayView?.sd_setImage(with: webUrl)
        } else if webUrl == nil {
            self.currentDisplayView?.image = image
        }
    }
    
    func configLastDisplayView(lastArrayIndex: Int) {
        let (webUrl, image) = decodeAllImageUrls(index: lastArrayIndex)
        if webUrl != nil && image != nil {
            self.lastDisplayView?.sd_setImage(with: webUrl, placeholderImage: image)
        } else if image == nil {
            self.lastDisplayView?.sd_setImage(with: webUrl)
        } else if webUrl == nil {
            self.lastDisplayView?.image = image
        }
    }
}

