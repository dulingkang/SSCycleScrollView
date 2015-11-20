//
//  SSCycleScrollView.swift
//  CycleScroll
//
//  Created by dulingkang on 20/11/15.
//  Copyright © 2015 shawn. All rights reserved.
//

import UIKit

typealias tapActionBlock = (Int) -> ()

class SSCycleScrollView: UIScrollView, UIScrollViewDelegate {
    
    var currentArrayIndex: Int!
    var animationDuration: NSTimeInterval!
    var animationTimer: NSTimer?
    var currentDisplayView: UIImageView?
    var lastDisplayView: UIImageView?
    var previousDisplayView: UIImageView?
    var allImageArray: [UIImage] = []
    var tapBlock: tapActionBlock?
    let kScreenWidth = UIScreen.mainScreen().bounds.size.width
    let kScreenHeight = UIScreen.mainScreen().bounds.size.height
    
    //MARK: - init method
    init(frame: CGRect, animationDuration: NSTimeInterval, inputImageArray: [UIImage]) {
        super.init(frame: frame)
        self.animationDuration = animationDuration
        self.allImageArray = inputImageArray
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
        let tap = UITapGestureRecognizer.init(target: self, action: "tapAction:")
        self.addGestureRecognizer(tap)
        self.addSubview(currentDisplayView!)
        self.addSubview(previousDisplayView!)
        self.addSubview(lastDisplayView!)
        
        self.currentArrayIndex = 1
        self.contentOffset = CGPointMake(CGRectGetWidth(frame), 0)
        
        self.configDisplayViews()
        
        self.createScrollTimer()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    //MARK: - Scrollview delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.animationTimer?.fireDate = NSDate.distantFuture()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.createScrollTimer()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
        self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(self.animationDuration, target: self, selector: "timerFired", userInfo: nil, repeats: true)
    }
    
    //MARK: - private method
    func configDisplayViews() {
        let previousArrayIndex = self.getArrayIndex(self.currentArrayIndex - 1)
        let lastArrayIndex = self.getArrayIndex(self.currentArrayIndex + 1)
        self.previousDisplayView?.image = self.allImageArray[previousArrayIndex]
        self.currentDisplayView?.image = self.allImageArray[self.currentArrayIndex]
        self.lastDisplayView?.image = self.allImageArray[lastArrayIndex]
        self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0)
    }
    
    func getArrayIndex(currentIndex: Int) -> Int{
        if currentIndex == -1 {
            return self.allImageArray.count - 1
        } else if currentIndex == self.allImageArray.count {
            return 0
        } else {
            return currentIndex
        }
    }
}

