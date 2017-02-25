//
//  WiggleUICollectionView.swift
//  On The Fly
//
//  Created by Scott Higgins on 2/25/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class WiggleUICollectionView: UICollectionView {

    var isWiggling: Bool { return _isWiggling }
    
    private var _isWiggling = false
    
    override func beginInteractiveMovementForItem(at indexPath: IndexPath) -> Bool {
        startWiggle()
        super.beginInteractiveMovementForItem(at: indexPath)
        return true
    }
    
    override func endInteractiveMovement() {
        super.endInteractiveMovement()
        stopWiggle()
    }
    
    
    private func startWiggle() {
        for cell in self.visibleCells {
            addWiggleAnimationToCell(cell: cell)
        }
        
        _isWiggling = true
    }
    
    private func stopWiggle() {
        for cell in self.visibleCells {
            cell.layer.removeAllAnimations()
        }
        
        _isWiggling = false
    }
    
    private func addWiggleAnimationToCell(cell: UICollectionViewCell) {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        cell.layer.add(rotationAnimation(), forKey: "rotation")
        cell.layer.add(bounceAnimation(), forKey: "bounce")
        CATransaction.commit()
    }
    
    private func rotationAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let angle = CGFloat(0.04)
        let duration = TimeInterval(0.1)
        let variance = Double(0.025)
        animation.values = [angle, -angle]
        animation.autoreverses = true
        animation.duration = self.randomizeInterval(interval: duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }
    
    private func bounceAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let bounce = CGFloat(3.0)
        let duration = TimeInterval(0.12)
        let variance = Double(0.025)
        animation.values = [bounce, -bounce]
        animation.autoreverses = true
        animation.duration = self.randomizeInterval(interval: duration, withVariance: variance)
        animation.repeatCount = Float.infinity
        return animation
    }
    
    private func randomizeInterval(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }

}
