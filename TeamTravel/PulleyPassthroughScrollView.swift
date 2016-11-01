//
//  LocationTVCPassthroughScrollView.swift
//  TeamTravelMapViewTest
//
//  Created by Joseph Hansen on 10/29/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

protocol LocationTVCPassthroughScrollViewDelegate: class {
    
    func shouldTouchPassthroughScrollView(scrollView: LocationTVCPassthroughScrollView, point: CGPoint) -> Bool
    func viewToReceiveTouch(scrollView: LocationTVCPassthroughScrollView) -> UIView
}

class LocationTVCPassthroughScrollView: UIScrollView {
    
    weak var touchDelegate: LocationTVCPassthroughScrollViewDelegate?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let touchDel = touchDelegate
        {
            if touchDel.shouldTouchPassthroughScrollView(scrollView: self, point: point)
            {
                return touchDel.viewToReceiveTouch(scrollView: self).hitTest(touchDel.viewToReceiveTouch(scrollView: self).convert(point, from: self), with: event)
            }
        }
        
        return super.hitTest(point, with: event)
    }
}
