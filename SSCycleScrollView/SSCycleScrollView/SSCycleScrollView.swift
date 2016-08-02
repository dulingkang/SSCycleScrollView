//
//  SSCycleScrollView.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit
import SDWebImage

typealias tapActionBlock = (Int) -> ()

public class SSCycleScrollView: UIScrollView, UIScrollViewDelegate {
    var currentArrayIndex: Int!
    var animationDuration: NSTimeInterval!
    var animationTimer: NSTimer?
    var currentDisplayView: UIImageView?
    var lastDisplayView: UIImageView?
    var previousDisplayView: UIImageView?
    public var allImageUrls: [String] = []
    public var autoScroll = true {
        didSet {
            if !autoScroll {
                cancelTimer()
            }
        }
    }
    var tapBlock: tapActionBlock?
    let kScreenWidth = UIScreen.mainScreen().bounds.size.width
    let kScreenHeight = UIScreen.mainScreen().bounds.size.height
    var needScroll = true
    
    //MARK: - init method
    public init(frame: CGRect, animationDuration: NSTimeInterval, inputImageUrls: [String]) {
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
    
    private func configScrollView(frame: CGRect) {
        self.autoresizesSubviews = true
        self.contentMode = UIViewContentMode.Center
        self.contentSize = CGSizeMake(3 * CGRectGetWidth(frame), CGRectGetHeight(frame))
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.delegate  = self
        self.pagingEnabled = true
        
        
        self.currentDisplayView = UIImageView.init(frame:  CGRectMake(CGRectGetWidth(frame), frame.origin.y, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        self.previousDisplayView = UIImageView.init(frame: CGRectMake(0, frame.origin.y, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        self.lastDisplayView = UIImageView.init(frame: CGRectMake(2 * CGRectGetWidth(frame), frame.origin.y, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        self.currentDisplayView?.userInteractionEnabled = true
        self.previousDisplayView?.userInteractionEnabled = true
        self.lastDisplayView?.userInteractionEnabled = true
        self.currentDisplayView?.contentMode = .ScaleAspectFill
        self.previousDisplayView?.contentMode = .ScaleAspectFill
        self.lastDisplayView?.contentMode = .ScaleAspectFill
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(SSCycleScrollView.tapAction(_:)))
        self.addGestureRecognizer(tap)
        self.addSubview(currentDisplayView!)
        self.addSubview(previousDisplayView!)
        self.addSubview(lastDisplayView!)
        
        self.contentOffset = CGPointMake(CGRectGetWidth(frame), 0)
        
        self.configDisplayViews()
        if needScroll {
            self.createScrollTimer()
        }
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    //MARK: - Scrollview delegate
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if autoScroll {
            self.animationTimer?.fireDate = NSDate.distantFuture()
        }
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll {
            self.createScrollTimer()
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.contentOffset.x >= (2 * CGRectGetWidth(self.frame)){
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
        let newOffset = CGPointMake(xOffsetFloat + CGRectGetWidth(self.frame), self.contentOffset.y)
        self.setContentOffset(newOffset, animated: true)
    }
    
    func tapAction(tap: UITapGestureRecognizer) {
        if (self.tapBlock != nil) {
            self.tapBlock!(self.currentArrayIndex)
        }
    }
    
    //MARK: - public method
    func createScrollTimer() {
        self.animationTimer?.invalidate()
        self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(self.animationDuration, target: self, selector: #selector(SSCycleScrollView.timerFired), userInfo: nil, repeats: true)
    }
    
    //MARK: - private method
    func configDisplayViews() {
        let previousArrayIndex = self.getArrayIndex(self.currentArrayIndex - 1)
        let lastArrayIndex = self.getArrayIndex(self.currentArrayIndex + 1)
        configPreviousDisplayView(previousArrayIndex)
        configCurrentDisplayView()
        configLastDisplayView(lastArrayIndex)
        self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0)
    }
    
    func cancelTimer() {
        self.animationTimer?.invalidate()
        self.animationTimer = nil
    }
    
    func getArrayIndex(currentIndex: Int) -> Int{
        if currentIndex == -1 {
            return allImageUrls.count - 1
        } else if currentIndex == allImageUrls.count {
            return 0
        } else {
            return currentIndex
        }
    }
    
    func configPreviousDisplayView(previousArrayIndex: Int) {
        if allImageUrls[previousArrayIndex].hasPrefix("http"){
            self.previousDisplayView?.sd_setImageWithURL(NSURL(string:allImageUrls[previousArrayIndex]))
        } else {
            self.previousDisplayView?.image = UIImage(named: allImageUrls[previousArrayIndex])
        }
    }
    
    func configCurrentDisplayView() {
        if allImageUrls[currentArrayIndex].hasPrefix("http"){
            self.currentDisplayView?.sd_setImageWithURL(NSURL(string:allImageUrls[currentArrayIndex]))
        } else {
            self.currentDisplayView?.image = UIImage(named: allImageUrls[currentArrayIndex])
        }
    }
    
    func configLastDisplayView(lastArrayIndex: Int) {
        if allImageUrls[lastArrayIndex].hasPrefix("http"){
            self.lastDisplayView?.sd_setImageWithURL(NSURL(string:allImageUrls[lastArrayIndex]))
        } else {
            self.lastDisplayView?.image = UIImage(named: allImageUrls[lastArrayIndex])
        }
    }
}

