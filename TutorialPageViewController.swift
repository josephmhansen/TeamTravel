//
//  File.swift
//  TeamTravel
//
//  Created by Jairo Eli de Leon on 11/7/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setViewControllers([getStepZero()], direction: .forward, animated: false, completion: nil)
    dataSource = self
    
    view.backgroundColor = UIColor.clear // set color behind page dots
    
    // set color of page indicator
    UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.black
    
  }
  
  override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
    return false
  }
  
  override func viewDidLayoutSubviews() {
    // place the page indicator over other views
    for subView in self.view.subviews {
      if subView is UIScrollView {
        subView.frame = self.view.bounds
      } else if subView is UIPageControl {
        self.view.bringSubview(toFront: subView)
      }
    }
    super.viewDidLayoutSubviews()
  }
  
  // MARK: - Pages
  
  func getStepZero() -> StepZeroViewController {
    return storyboard!.instantiateViewController(withIdentifier: "StepZero") as! StepZeroViewController
  }
  
  func getStepTwo() -> StepTwoViewController {
    return storyboard!.instantiateViewController(withIdentifier: "StepTwo") as! StepTwoViewController
  }
  
  func getStepThree() -> StepThreeViewController {
    return storyboard!.instantiateViewController(withIdentifier: "StepThree") as! StepThreeViewController
  }
  
  func getStepFour() -> StepFourViewController {
    return storyboard!.instantiateViewController(withIdentifier: "StepFour") as! StepFourViewController
  }
  
  func getStepFive() -> StepFiveViewController {
    return storyboard!.instantiateViewController(withIdentifier: "StepFive") as! StepFiveViewController
  }
  
  func getStepSix() -> StepSixViewController {
    return storyboard!.instantiateViewController(withIdentifier: "StepSix") as! StepSixViewController
  }
  
}

extension TutorialPageViewController : UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    if viewController is StepSixViewController {
      return getStepFive()
    } else if viewController is StepFiveViewController {
      return getStepFour()
    } else if viewController is StepFourViewController {
      return getStepThree()
    } else if viewController is StepThreeViewController {
      return getStepTwo()
    } else if viewController is StepTwoViewController {
      return getStepZero()
    } else {
      return nil
    }
  }
  
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    if viewController is StepZeroViewController {
      return getStepTwo()
    } else if viewController is StepTwoViewController {
      return getStepThree()
    } else if viewController is StepThreeViewController {
      return getStepFour()
    } else if viewController is StepFourViewController {
      return getStepFive()
    } else if viewController is StepFiveViewController {
      return getStepSix()
    } else {
      return nil
    }
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return 6
  }
  
  /// start at first dot
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }
  
}
