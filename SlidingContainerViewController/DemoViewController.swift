//
//  DemoViewController.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController, SlidingContainerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo"
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!
        ]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let vc1 = viewControllerWithColorAndTitle(UIColor.whiteColor(), title: "First View Controller")
        let vc2 = viewControllerWithColorAndTitle(UIColor.whiteColor(), title: "Second View Controller")
        let vc3 = viewControllerWithColorAndTitle(UIColor.whiteColor(), title: "Third View Controller")
        let vc4 = viewControllerWithColorAndTitle(UIColor.whiteColor(), title: "Forth View Controller")
        
        let slidingContainerViewController = SlidingContainerViewController (
            parent: self,
            contentViewControllers: [vc1, vc2, vc3, vc4],
            titles: ["First", "Second", "Third", "Forth"])
        
        view.addSubview(slidingContainerViewController.view)
        
        slidingContainerViewController.sliderView.appearance.outerPadding = 0
        slidingContainerViewController.sliderView.appearance.innerPadding = 50
        slidingContainerViewController.setCurrentViewControllerAtIndex(0)
    }
    
    func viewControllerWithColorAndTitle (color: UIColor, title: String) -> UIViewController {
        
        let vc = UIViewController ()
        vc.view.backgroundColor = color
        
        let label = UILabel (frame: vc.view.frame)
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        label.font = UIFont (name: "HelveticaNeue-Light", size: 25)
        label.text = title
        label.sizeToFit()
        label.center = view.center
        vc.view.addSubview(label)
        
        return vc
    }
    
    
    // MARK: SlidingContainerViewControllerDelegate
    
    func slidingContainerViewControllerDidShowSliderView(slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidHideSliderView(slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidMoveToViewController(slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController) {
        
    }
    
    func slidingContainerViewControllerDidMoveToViewControllerAtIndex(slidingContainerViewController: SlidingContainerViewController, index: Int) {
        
    }

}
