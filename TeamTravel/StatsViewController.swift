//
//  StatsViewController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/1/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

private let kLivelyGreenColor = UIColor(red: 8 / 255, green: 132 / 255, blue: 67 / 255, alpha: 1)

class StatsViewController: UIViewController {
    
    @IBAction func backButtonTapped(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var segmentedControl: SegmentedControl!

    
    

    
    
    // MARK: - Programmatic segues to UserStatsViewControllers
    
    //PointsView
    
    lazy var pointsViewController: PointsGraphViewController =  {
        let storyboard = UIStoryboard(name: "UserDetailView", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "pointsViewController") as! PointsGraphViewController
        return viewController
    }()
 
    
    //BadgesView
    lazy var badgesViewController: BadgesCollectionViewController = {
        let storyboard = UIStoryboard(name: "UserDetailView", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "badgesViewController") as! BadgesCollectionViewController
        return viewController
    }()
    
    //LocationsView
    lazy var locationsVisitedTableViewController: LocationsVisitedTableViewController = {
        let storyboard = UIStoryboard(name: "UserDetailView", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "locationsVisitedViewController") as! LocationsVisitedTableViewController
        return viewController
    }()
    
    lazy var userDetailViewControllers: [UIViewController] = {
        return [self.pointsViewController, self.badgesViewController, self.locationsVisitedTableViewController]
    }()
    
    // MARK: - View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        UINavigationBar.appearance().isTranslucent = true
        

        self.title = "Achievements"
        setupUI()
        setupViews()
        updateInnerView(index: segmentedControl.selectedIndex)
       let _ = self.userDetailViewControllers.count
        
    }
    
    func setupViews() {
        for viewController in self.userDetailViewControllers {
            addViewControllerAsChild(viewController: viewController)
        }
    }
    
    func addViewControllerAsChild(viewController: UIViewController) {
        //add child view controller
        self.addChildViewController(viewController)
        // add child as subview
        self.innerView.addSubview(viewController.view)
        
        //configure child view
        
        viewController.view.frame = innerView.bounds
        //Notify Child ViewController
        viewController.didMove(toParentViewController: self)
    }
    
    // MARK: - SegmentedController Functions
    
    fileprivate func setupUI() {
        configureSegmentedControl2()
    }
    
    fileprivate func configureSegmentedControl2() {
        let images = [#imageLiteral(resourceName: "TokensSmall"), #imageLiteral(resourceName: "BadgesSmall"), #imageLiteral(resourceName: "QuestsSmall")]
        let selectedImages = [#imageLiteral(resourceName: "TokensSmall"), #imageLiteral(resourceName: "BadgesSmall"), #imageLiteral(resourceName: "QuestsSmall")]
        
        segmentedControl.setImages(images, selectedImages: selectedImages)
        segmentedControl.delegate = self
        segmentedControl.selectionIndicatorStyle = .bottom
        segmentedControl.selectionIndicatorColor = kLivelyGreenColor
        segmentedControl.selectionIndicatorHeight = 3
        segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func updateInnerView(index: Int) {
        for viewController in self.userDetailViewControllers {
            viewController.view.isHidden = true
        }
        
        let selectedView = self.userDetailViewControllers[index]
        selectedView.view.isHidden = false
    }

}

// MARK: - SegmentedControllerDelegate Functions

extension StatsViewController: SegmentedControlDelegate {
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelectIndex selectedIndex: Int) {
        print("Did select index \(selectedIndex)")
        updateInnerView(index: selectedIndex)
        switch segmentedControl.style {
        case .text:
            print("The title is “\(segmentedControl.titles[selectedIndex].string)”\n")
        case .image:
            print("The image is “\(segmentedControl.images[selectedIndex])”\n")
        }
    }
    
    func segmentedControl(_ segmentedControl: SegmentedControl, didLongPressIndex longPressIndex: Int) {
        print("Did long press index \(longPressIndex)")
        if UIDevice.current.userInterfaceIdiom == .pad {
            let viewController = UIViewController()
            viewController.modalPresentationStyle = .popover
            viewController.preferredContentSize = CGSize(width: 200, height: 300)
            if let popoverController = viewController.popoverPresentationController {
                popoverController.sourceView = view
                let yOffset: CGFloat = 10
                popoverController.sourceRect = view.convert(CGRect(origin: CGPoint(x: 70 * CGFloat(longPressIndex), y: yOffset), size: CGSize(width: 70, height: 30)), from: navigationItem.titleView)
                popoverController.permittedArrowDirections = .any
                present(viewController, animated: true, completion: nil)
            }
        } else {
            let message = segmentedControl.style == .text ? "Long press title “\(segmentedControl.titles[longPressIndex].string)”" : "Long press image “\(segmentedControl.images[longPressIndex])”"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
