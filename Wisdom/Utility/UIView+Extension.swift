//
//  UIView+Extension.swift
//  Wisdom
//
//  Created by KOSURU UDAY SAIKUMAR on 08/05/23.
//

import UIKit

class UIView_Extension: NSObject {

}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension String {
  static func randomString(list:[String]) -> String? {
    assert(!list.isEmpty,"Empty Lists not supported")
    return list.randomElement()!
  }
}


extension Int {
  static func returnQ(inq:Range<Int>) -> Int {
    var g = SystemRandomNumberGenerator()
    let c = Int.random(in: inq, using: &g)
    return c
  }
  
  static func randomPop(list:inout [String]) -> String {
    assert(!list.isEmpty,"Empty Lists not supported")
    let c = returnQ(inq: 0..<list.count)
    let foo = list.remove(at: c)
    return foo
  }
}
