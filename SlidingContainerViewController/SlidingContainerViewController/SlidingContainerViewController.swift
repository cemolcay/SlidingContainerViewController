//
//  SlidingContainerViewController.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class SlidingContainerViewController: UIViewController, UIScrollViewDelegate, SlidingContainerSliderViewDelegate {
    
    var contentViewControllers: [UIViewController]!
    var contentScrollView: UIScrollView!
    var sliderView: SlidingContainerSliderView!
    
    
    // MARK: Init
    
    init (parent: UIViewController, contentViewControllers: [UIViewController], titles: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.contentViewControllers = contentViewControllers
        
        // Move to parent
        
        willMoveToParentViewController(parent)
        parent.addChildViewController(self)
        didMoveToParentViewController(parent)
        
        
        // Setup Views
        
        sliderView = SlidingContainerSliderView (width: view.frame.size.width, titles: titles)
        sliderView.frame.origin.y = parent.topLayoutGuide.length
        sliderView.sliderDelegate = self
        
        contentScrollView = UIScrollView (frame: view.frame)
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.pagingEnabled = true
        contentScrollView.scrollsToTop = false
        contentScrollView.delegate = self
        contentScrollView.contentSize.width = contentScrollView.frame.size.width * CGFloat(contentViewControllers.count)
        
        view.addSubview(contentScrollView)
        view.addSubview(sliderView)
        
        
        // Add Child View Controllers
        
        var currentX: CGFloat = 0
        for vc in contentViewControllers {
            vc.view.frame = CGRect (
                x: currentX,
                y: parent.topLayoutGuide.length,
                width: view.frame.size.width,
                height: view.frame.size.height - parent.topLayoutGuide.length - parent.bottomLayoutGuide.length)
            contentScrollView.addSubview(vc.view)
            
            currentX += contentScrollView.frame.size.width
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: ChildViewController Management
    
    func setCurrentViewControllerAtIndex (index: Int) {
    
        for i in 0..<self.contentViewControllers.count {
            let vc = contentViewControllers[i]
            
            if i == index {
                vc.willMoveToParentViewController(self)
                addChildViewController(vc)
                vc.didMoveToParentViewController(self)
            } else {
                vc.willMoveToParentViewController(self)
                vc.removeFromParentViewController()
                vc.didMoveToParentViewController(self)
            }
        }
        
        sliderView.selectItemAtIndex(index)
        contentScrollView.setContentOffset(
            CGPoint (x: contentScrollView.frame.size.width * CGFloat(index), y: 0),
            animated: true)
    }
    
    
    // MARK: SlidingContainerSliderViewDelegate
    
    func slidingContainerSliderViewDidPressed(slidingContainerSliderView: SlidingContainerSliderView, atIndex: Int) {
        setCurrentViewControllerAtIndex(atIndex)
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let contentW = contentScrollView.contentSize.width - contentScrollView.frame.size.width
        let sliderW = sliderView.contentSize.width - sliderView.frame.size.width
        
        let current = contentScrollView.contentOffset.x
        let ratio = current / contentW
        
        if sliderView.contentSize.width > sliderView.frame.size.width {
            sliderView.contentOffset = CGPoint (x: sliderW * ratio, y: 0)
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / contentScrollView.frame.size.width
        setCurrentViewControllerAtIndex(Int(index))
    }
}
