//
//  loadingAnimation.swift
//  Indicator
//
//  Created by Jairo Eli de Leon on 11/8/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class loadingAnimation: UIView {
  
  // MARK: - Properties
  fileprivate var stopped: Bool = false
  var hidesWhenStopped: Bool = true
  
  // The color of the loader view
  override var tintColor: UIColor! {
    didSet {
      if let _ = tintColor {
        for sublayer in layer.sublayers! {
          let _sublayer = sublayer
          
          _sublayer.backgroundColor = tintColor.cgColor
        }
      }
    }
  }
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupAnimation(layer, size: frame.size, color: tintColor)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupAnimation(layer, size: frame.size, color: tintColor)
  }
  
  // MARK: - Setup
  fileprivate func setupAnimation(_ layer: CALayer, size: CGSize, color: UIColor) {
    let beginTime = CACurrentMediaTime()
    
    let offset: CGFloat = size.width / 8
    let circleSize: CGFloat = offset * 2
    
    for i in 0..<3 {
      
      let circleX = CGFloat(i) * 3 * offset
      let circleY = size.height / 2 - circleSize/2
      
      let circle = CALayer()
      circle.frame = CGRect(x: circleX, y: circleY, width: circleSize, height: circleSize)
      circle.backgroundColor = color.cgColor
      circle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
      circle.cornerRadius = circle.bounds.height * 0.5
      circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
      
      let anim = CAKeyframeAnimation(keyPath: "transform")
      anim.isRemovedOnCompletion = false
      anim.repeatCount = Float.infinity
      anim.duration = 1.5
      anim.beginTime = beginTime + CFTimeInterval(0.25 * CGFloat(i))
      anim.keyTimes = [0.0, 0.5, 1.0]
      
      anim.timingFunctions = [
        CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
        CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
        CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
      ];
      
      anim.values = [
        NSValue(caTransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)),
        NSValue(caTransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0)),
        NSValue(caTransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0))
      ];
      
      layer.addSublayer(circle)
      circle.add(anim, forKey: "anime")
    }
  }
  
  // MARK: - Start & Stop
  func startAnimating() {
    if !isAnimating() {
      stopped = false
      isHidden = false
      resumeLayers()
    }
  }
  
  func stopAnimating() {
    if isAnimating() {
      if hidesWhenStopped {
        isHidden = true
      }
      stopped = true
      pauseLayers()
    }
  }
  
  func isAnimating() -> Bool {
    return !stopped
  }
  
  // MARK: - Handle resume/pause
  fileprivate func resumeLayers() {
    let pausedTime = layer.timeOffset
    let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    
    layer.speed = 1.0
    layer.timeOffset = 0.0
    layer.beginTime = 0.0
    layer.beginTime = timeSincePause
  }
  
  fileprivate func pauseLayers() {
    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
    
    layer.speed = 0.0
    layer.timeOffset = pausedTime
  }
  
  
}
