SlidingContainerViewController
==============================

An [android scrollable tab bar](http://developer.android.com/design/building-blocks/tabs.html#scrollable) style container view controller


Demo 
----

![alt tag](https://raw.githubusercontent.com/cemolcay/SlidingContainerViewController/master/demo.gif)


Install
-----

#### Manual

Copy & paste `SlidingContainerViewController` folder to your project

#### Cocoapods

coming soon


Usage
-----

Create a `UIViewController` as container, setup your tab view controllers and implement `SlidingContainerViewController` and add its view to view controller's view like:

``` swift
   let slidingContainerViewController = SlidingContainerViewController (
       parent: self,
       contentViewControllers: [vc1, vc2, vc3, vc4],
       titles: ["First", "Second", "Third", "Forth"])
   
   view.addSubview(slidingContainerViewController.view)
```


SlidingContainerViewControllerDelegate
---------------------------------------

``` swift
@objc protocol SlidingContainerViewControllerDelegate {
    optional func slidingContainerViewControllerDidMoveToViewController (slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int)
    optional func slidingContainerViewControllerDidHideSliderView (slidingContainerViewController: SlidingContainerViewController)
    optional func slidingContainerViewControllerDidShowSliderView (slidingContainerViewController: SlidingContainerViewController)
}

```


SlidingContainerSliderView
--------------------------

The tab bar slider view in the sliding container view controller.
Fully customisable with its `appearance` property.


SlidingContainerSliderViewAppearance
------------------------------------

``` swift
	struct SlidingContainerSliderViewAppearance {
	    
	    var backgroundColor: UIColor
	    
	    var font: UIFont
	    var selectedFont: UIFont
	    
	    var textColor: UIColor
	    var selectedTextColor: UIColor
	    
	    var outerPadding: CGFloat
	    var innerPadding: CGFloat
	    
	    var selectorColor: UIColor
	    var selectorHeight: CGFloat
	}
```
