//
//  loadingAnimation.swift
//  Indicator
//
//  Created by Jairo Eli de Leon on 11/8/16.
//  Copyright © 2016 zero. All rights reserved.
//

import UIKit

typealias PolyColor = UIColor

fileprivate extension Int {
  func duplicate4bits() -> Int {
    return (self << 4) + self
  }
}

extension PolyColor {

  convenience init?(hexString: String) {
    self.init(hexString: hexString, alpha: 1.0)
  }
  
  fileprivate convenience init?(hex3: Int, alpha: Float) {
    self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
              green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
              blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0, alpha: CGFloat(alpha))
  }
  
  fileprivate convenience init?(hex6: Int, alpha: Float) {
    self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
              green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
              blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
  }
  
  convenience init?(hexString: String, alpha: Float) {
    var hex = hexString
    
    if hex.hasPrefix("#") {
      hex.removeFirst()
    }
    
    guard let hexVal = Int(hex, radix: 16) else {
      self.init()
      return nil
    }
    
    switch hex.count {
    case 3:
      self.init(hex3: hexVal, alpha: alpha)
    case 6:
      self.init(hex6: hexVal, alpha: alpha)
    default:
      self.init()
      return nil
    }
  }
  
}
