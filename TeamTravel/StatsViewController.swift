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
    
    @IBOutlet weak var segmentedControl: SegmentedControl!
    
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var pointsView: UIView!
    @IBOutlet var badgesView: UIView!
    @IBOutlet var locationsView: UIView!
    
    @IBAction func pointsButtonTapped() {
        if pointsView.isHidden == true {
            pointsView.isHidden = false
            badgesView.isHidden = true
            locationsView.isHidden = true
        } else {
            return
        }
    }
    
    @IBAction func badgesButtonTapped() {
        if badgesView.isHidden == true {
            pointsView.isHidden = true
            badgesView.isHidden = false
            locationsView.isHidden = true
        } else {
            return
        }
    }
    
    @IBAction func locationsButtonTapped() {
        if locationsView.isHidden == true {
            pointsView.isHidden = true
            badgesView.isHidden = true
            locationsView.isHidden = false
        } else {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsView.isHidden = true
        badgesView.isHidden = false
        locationsView.isHidden = true
        setupUI()
        
    }
    
    fileprivate func setupUI() {
        configureSegmentedControl2()
    }
    
    fileprivate func configureSegmentedControl2() {
        let images = [#imageLiteral(resourceName: "pin"), #imageLiteral(resourceName: "pin"), #imageLiteral(resourceName: "pin") ]
        let selectedImages = [#imageLiteral(resourceName: "pin"), #imageLiteral(resourceName: "pin"), #imageLiteral(resourceName: "pin") ]
        segmentedControl.setImages(images, selectedImages: selectedImages)
        segmentedControl.delegate = self
        segmentedControl.selectionIndicatorStyle = .bottom
        segmentedControl.selectionIndicatorColor = kLivelyGreenColor
        segmentedControl.selectionIndicatorHeight = 3
        segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

}

extension StatsViewController: SegmentedControlDelegate {
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelectIndex selectedIndex: Int) {
        print("Did select index \(selectedIndex)")
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
