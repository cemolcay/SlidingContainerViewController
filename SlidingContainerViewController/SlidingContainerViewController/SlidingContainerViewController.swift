
//
//  SlidingContainerViewController.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

@objc protocol SlidingContainerViewControllerDelegate {
    @objc optional func slidingContainerViewControllerDidMoveToViewController (_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int)
    @objc optional func slidingContainerViewControllerDidHideSliderView (_ slidingContainerViewController: SlidingContainerViewController)
    @objc optional func slidingContainerViewControllerDidShowSliderView (_ slidingContainerViewController: SlidingContainerViewController)
}

class SlidingContainerViewController: UIViewController, UIScrollViewDelegate, SlidingContainerSliderViewDelegate {
    
    var contentViewControllers: [UIViewController]!
    var contentScrollView: UIScrollView!
    var titles: [String]!
    
    var sliderView: SlidingContainerSliderView!
    var sliderViewShown: Bool = true
    
    var delegate: SlidingContainerViewControllerDelegate?
    
    
    // MARK: Init
    
    init (parent: UIViewController, contentViewControllers: [UIViewController], titles: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.contentViewControllers = contentViewControllers
        self.titles = titles
        
        
        // Move to parent
        
        willMove(toParentViewController: parent)
        parent.addChildViewController(self)
        didMove(toParentViewController: parent)
        
        
        // Setup Views
        
        sliderView = SlidingContainerSliderView (width: view.frame.size.width, titles: titles)
        sliderView.frame.origin.y = parent.topLayoutGuide.length
        sliderView.sliderDelegate = self
        
        contentScrollView = UIScrollView (frame: view.frame)
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
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
        
        
        // Move First Item
        
        setCurrentViewControllerAtIndex(0)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: ChildViewController Management
    
    func setCurrentViewControllerAtIndex (_ index: Int) {
    
        for i in 0..<self.contentViewControllers.count {
            let vc = contentViewControllers[i]
            
            if i == index {
                
                vc.willMove(toParentViewController: self)
                addChildViewController(vc)
                vc.didMove(toParentViewController: self)
                
                delegate?.slidingContainerViewControllerDidMoveToViewController? (self, viewController: vc, atIndex: index)
            } else {
    
                vc.willMove(toParentViewController: self)
                vc.removeFromParentViewController()
                vc.didMove(toParentViewController: self)
            }
        }
        
        sliderView.selectItemAtIndex(index)
        contentScrollView.setContentOffset(
            CGPoint (x: contentScrollView.frame.size.width * CGFloat(index), y: 0),
            animated: true)
        
        navigationController?.navigationItem.title = titles[index]
    }
    
    
    // MARK: SlidingContainerSliderViewDelegate
    
    func slidingContainerSliderViewDidPressed(_ slidingContainerSliderView: SlidingContainerSliderView, atIndex: Int) {
        sliderView.shouldSlide = false
        setCurrentViewControllerAtIndex(atIndex)
    }
    
    
    // MARK: SliderView
    
    func hideSlider () {
        
        if !sliderViewShown {
            return
        }
        
        UIView.animate(withDuration: 0.3,
            animations: {
                [unowned self] in
                self.sliderView.frame.origin.y += self.parent!.topLayoutGuide.length + self.sliderView.frame.size.height
            },
            completion: {
                [unowned self] finished in
                self.sliderViewShown = false
                self.delegate?.slidingContainerViewControllerDidHideSliderView? (self)
            })
    }
    
    func showSlider () {
        
        if sliderViewShown {
            return
        }
        
        UIView.animate(withDuration: 0.3,
            animations: {
                [unowned self] in
                self.sliderView.frame.origin.y -= self.parent!.topLayoutGuide.length + self.sliderView.frame.size.height
            },
            completion: {
                [unowned self] finished in
                self.sliderViewShown = true
                self.delegate?.slidingContainerViewControllerDidShowSliderView? (self)
            })
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.state == .began {
            sliderView.shouldSlide = true
        }
        
        let contentW = contentScrollView.contentSize.width - contentScrollView.frame.size.width
        let sliderW = sliderView.contentSize.width - sliderView.frame.size.width
        
        let current = contentScrollView.contentOffset.x
        let ratio = current / contentW
        
        if sliderView.contentSize.width > sliderView.frame.size.width && sliderView.shouldSlide == true {
            sliderView.contentOffset = CGPoint (x: sliderW * ratio, y: 0)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / contentScrollView.frame.size.width
        setCurrentViewControllerAtIndex(Int(index))
    }
}

extension UIGestureRecognizerState {
    public var description: String {
        get {
            switch self {
            case .began:
                return "Began"
            case .cancelled:
                return "Cancelled"
            case .changed:
                return "Changed"
            case .ended:
                return "Ended"
            case .failed:
                return "Failed"
            case .possible:
                return "Possible"
            }
        }
    }
}
