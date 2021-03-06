//
//  ViewController.swift
//  InfiniteScroll
//
//  Created by qihaijun on 11/25/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previousView: UIImageView!
    @IBOutlet weak var currentView: UIImageView!
    @IBOutlet weak var nextView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var showingIndex: Int = 0
    var timer: Timer!
    var timeInterval: TimeInterval = 5
    
    let imageData = [UIImage(named: "0")!, UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageControl.numberOfPages = imageData.count
        scrollView.scrollRectToVisible(currentView.frame, animated: false)
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(ViewController.tick(_:)), userInfo: nil, repeats: true)
    }
    
    fileprivate func updateImages(_ index: Int) {
        showingIndex = index;
        if showingIndex < 0 {
            showingIndex = imageData.count - 1
        } else if showingIndex >= imageData.count {
            showingIndex = 0
        }
        pageControl.currentPage = showingIndex
        currentView.image = imageData[showingIndex]
        
        var nextIndex = showingIndex + 1
        if nextIndex >= imageData.count {
            nextIndex = 0
        }
        nextView.image = imageData[nextIndex]
        
        var previousIndex = showingIndex - 1
        if previousIndex < 0 {
            previousIndex = imageData.count - 1
        }
        previousView.image = imageData[previousIndex]
        
        scrollView.scrollRectToVisible(currentView.frame, animated: false)
    }
    
    func tick(_ timer: Timer) {
        showingIndex += 1
        scrollView.scrollRectToVisible(nextView.frame, animated: true)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        timer.invalidate()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let viewIndex = lround(Double(scrollView.contentOffset.x / scrollView.frame.width));
        if viewIndex == 2 {
            showingIndex += 1
        } else if viewIndex == 0 {
            showingIndex -= 1
        }
        
        updateImages(showingIndex)
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(ViewController.tick(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateImages(showingIndex)
    }
}

