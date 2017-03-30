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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let vc1 = viewControllerWithColorAndTitle(UIColor.white, title: "First View Controller")
    let vc2 = viewControllerWithColorAndTitle(UIColor.white, title: "Second View Controller")
    let vc3 = viewControllerWithColorAndTitle(UIColor.white, title: "Third View Controller")
    let vc4 = viewControllerWithColorAndTitle(UIColor.white, title: "Forth View Controller")

    let slidingContainerViewController = SlidingContainerViewController (
      parent: self,
      contentViewControllers: [vc1, vc2, vc3, vc4],
      titles: ["First", "Second", "Third", "Forth"])

    view.addSubview(slidingContainerViewController.view)

    slidingContainerViewController.sliderView.appearance.outerPadding = 0
    slidingContainerViewController.sliderView.appearance.innerPadding = 50
    slidingContainerViewController.sliderView.appearance.fixedWidth = true
    slidingContainerViewController.setCurrentViewControllerAtIndex(0)
    slidingContainerViewController.delegate = self
  }

  func viewControllerWithColorAndTitle (_ color: UIColor, title: String) -> UIViewController {
    let vc = UIViewController ()
    vc.view.backgroundColor = color

    let label = UILabel (frame: vc.view.frame)
    label.textColor = UIColor.black
    label.textAlignment = .center
    label.font = UIFont (name: "HelveticaNeue-Light", size: 25)
    label.text = title

    label.sizeToFit()
    label.center = view.center

    vc.view.addSubview(label)

    return vc
  }

  // MARK: SlidingContainerViewControllerDelegate
  
  func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {

  }

  func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {

  }

  func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {

  }
}
