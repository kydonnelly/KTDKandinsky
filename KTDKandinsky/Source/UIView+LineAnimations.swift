//
//  UIView+LineAnimations.swift
//  KTDKandinsky
//
//  Created by Kyle Donnelly on 5/25/21.
//

import UIKit

public protocol Wobbler {
    var wobble: CGFloat { get }
}

extension Wobbler {
    
    private func sineAnimation(t: TimeInterval, min: CGFloat, max: CGFloat) -> CGFloat {
        let diff = max - min
        let sineShift: Double = sin(t) + 1.0
        return min + diff * 0.5 * CGFloat(sineShift)
    }
    
    public func wobble(t: TimeInterval, dt: TimeInterval, widthIndex: Int, width1: inout CGFloat, width2: inout CGFloat, speed: CGFloat = 80.0, wavelength: CGFloat = 0.02) {
        precondition(widthIndex % 2 == 0, "Should update 2 indexes at a time")
        
        let offset = (CGFloat(widthIndex) + CGFloat(dt) * speed) * wavelength
        let offsetSin = sin(offset)
        let offsetSin3 = sin(offset * 3)
        let offsetSin8 = sin(offset * 8)
        let value = width1 * sineAnimation(t: dt * 0.04, min: 0.6, max: 1.3) * 0.7 * (offsetSin * offsetSin3 * offsetSin8 + 0.2)
        let widthOffset = (1.0 - CGFloat(t)) * value
        width1 = width1 + widthOffset
        width2 = width1 + widthOffset
    }
    
}

extension Wobbler where Self: UIView {
    
    public func wobbleIn(duration: TimeInterval = 0.2) {
        self.layer.removeAnimation(forKey: "wobble")
        let animation = CABasicAnimation(keyPath: "wobble")
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        self.layer.add(animation, forKey: "wobble")
    }
    
    public func wobbleOut(duration: TimeInterval = 0.5) {
        self.layer.removeAnimation(forKey: "wobble")
        let animation = CABasicAnimation(keyPath: "wobble")
        animation.duration = duration
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.layer.add(animation, forKey: "wobble")
    }
    
}
