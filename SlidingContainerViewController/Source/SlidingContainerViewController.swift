
//
//  SlidingContainerViewController.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

public protocol SlidingContainerViewControllerDelegate: class {
  func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int)
  func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController)
  func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController)
}

public class SlidingContainerViewController: UIViewController, UIScrollViewDelegate, SlidingContainerSliderViewDelegate {
  public var contentViewControllers: [UIViewController]!
  public var contentScrollView: UIScrollView!
  public var titles: [String]!
  public var sliderView: SlidingContainerSliderView!
  public var sliderViewShown: Bool = true
  public weak var delegate: SlidingContainerViewControllerDelegate?

  // MARK: Init

  public init (parent: UIViewController, contentViewControllers: [UIViewController], titles: [String]) {
    super.init(nibName: nil, bundle: nil)
    self.contentViewControllers = contentViewControllers
    self.titles = titles

    // Move to parent
    willMove(toParent: parent)
    parent.addChild(self)
    didMove(toParent: parent)

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

  public required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }

  // MARK: Lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: ChildViewController Management

  public func setCurrentViewControllerAtIndex(_ index: Int) {
    for i in 0..<self.contentViewControllers.count {
      let vc = contentViewControllers[i]

      if i == index {
        vc.willMove(toParent: self)
        addChild(vc)
        vc.didMove(toParent: self)
        delegate?.slidingContainerViewControllerDidMoveToViewController(self, viewController: vc, atIndex: index)
      } else {
        vc.willMove(toParent: self)
        vc.removeFromParent()
        vc.didMove(toParent: self)
      }
    }

    sliderView.selectItemAtIndex(index)
    
    var offset = contentScrollView.contentOffset
    offset.x = contentScrollView.frame.size.width * CGFloat(index)
    contentScrollView.setContentOffset( offset,
                                        animated: true)

    navigationController?.navigationItem.title = titles[index]
  }

  // MARK: SlidingContainerSliderViewDelegate

  public func slidingContainerSliderViewDidPressed(_ slidingContainerSliderView: SlidingContainerSliderView, atIndex: Int) {
    sliderView.shouldSlide = false
    setCurrentViewControllerAtIndex(atIndex)
  }

  // MARK: SliderView

  public func hideSlider() {
    guard !sliderViewShown else { return }

    UIView.animate(
      withDuration: 0.3,
      animations: { [weak self] in
        guard let this = self else { return }
        this.sliderView.frame.origin.y += this.parent!.topLayoutGuide.length + this.sliderView.frame.size.height
      }, completion: { [weak self] finished in
        guard let this = self else { return }
        this.sliderViewShown = false
        this.delegate?.slidingContainerViewControllerDidHideSliderView(this)
      })
  }

  public func showSlider() {
    guard sliderViewShown else { return }

    UIView.animate(
      withDuration: 0.3,
      animations: { [weak self] in
        guard let this = self else { return }
        this.sliderView.frame.origin.y -= this.parent!.topLayoutGuide.length + this.sliderView.frame.size.height
      }, completion: { [weak self] finished in
        guard let this = self else { return }
        this.sliderViewShown = true
        this.delegate?.slidingContainerViewControllerDidShowSliderView(this)
      })
  }

  // MARK: UIScrollViewDelegate

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = scrollView.contentOffset.x / contentScrollView.frame.size.width
    setCurrentViewControllerAtIndex(Int(index))
  }
}
