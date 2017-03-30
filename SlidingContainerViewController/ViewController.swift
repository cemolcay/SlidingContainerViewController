//
//  ViewController.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

  var smallSlider: UIScrollView!
  var bigSlider: UIScrollView!

  override func viewDidLoad() {
    super.viewDidLoad()

    smallSlider = UIScrollView (frame: CGRect (x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2))
    bigSlider = UIScrollView (frame: CGRect (x: 0, y: smallSlider.frame.size.height, width: view.frame.size.width, height: view.frame.size.height/2))

    smallSlider.backgroundColor = UIColor.red
    bigSlider.backgroundColor = UIColor.yellow

    smallSlider.contentSize = CGSize (width: 1000, height: smallSlider.frame.size.height)
    bigSlider.contentSize = CGSize (width: 500, height: bigSlider.frame.size.height)

    smallSlider.delegate = self
    bigSlider.delegate = self

    view.addSubview(smallSlider)
    view.addSubview(bigSlider)

    let gradient = CAGradientLayer()
    gradient.frame = CGRect (x: 0, y: 0, width: smallSlider.contentSize.width, height: smallSlider.frame.height)
    gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
    gradient.locations = [0, 1]
    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    smallSlider.layer.addSublayer(gradient)

    smallSlider.bounces = false
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == bigSlider {

      let bigContent = bigSlider.contentSize.width - bigSlider.frame.size.width
      let smallContent = smallSlider.contentSize.width - smallSlider.frame.size.width

      let current = bigSlider.contentOffset.x
      let ratio = current / bigContent

      smallSlider.contentOffset = CGPoint (x: smallContent * ratio, y: 0)
    }
  }
}
