//
//  CoachMarker.swift
//  CoachMarkerApp
//
//  Created by Ahmet Doğu on 13.02.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit

protocol CoachMarkerDelegate: class {
    func coachMarkerDidShow(_ coachMarker: CoachMarker)
}

protocol CoachMarkerDataSource {
    func numberOfMarkers(in marker: CoachMarker) -> Int
    func coachMarker(_ coachMarker: CoachMarker, viewForItemAtIndex: Int) -> UIView
    func coachMarker(_ coachMarker: CoachMarker, markerForItemAtIndex: Int) -> CoachMarkerData
}

final class CoachMarker: NSObject {
    private var parentView: UIView
    private var dataSource: CoachMarkerDataSource
    
    private var tutorialView = UIView(frame: .zero)
    
    var effectAnimationHeight: CGFloat = 10
    weak var delegate: CoachMarkerDelegate?
    
    private var currentMarkerIndex = 0
    private var currentMarkerView: UIView?
    
    
    init(parentView: UIView, dataSource: CoachMarkerDataSource) {
        self.parentView = parentView
        self.dataSource = dataSource
    }
    
    func nextCoachMarker() {
        showCoachMarker()
    }
    
    func showCoachMarker() {
        
        if currentMarkerIndex < dataSource.numberOfMarkers(in: self) {
            changeCoachMarker(data: dataSource.coachMarker(self, markerForItemAtIndex: currentMarkerIndex))
        } else {
            skipCoachMarker()
        }
    }
    
    func skipCoachMarker() {
        removeMarker()
        delegate?.coachMarkerDidShow(self)
    }
    
    private func changeCoachMarker(data: CoachMarkerData) {
        removeMarker() { [weak self] in
            guard let self = self else { return }
            if let circleData = data as? CoachMarkerCircleData {
                self.currentMarkerView = self.createOverlayWithCircle(xOffset: circleData.coordinate.x,
                                                                      yOffset: circleData.coordinate.y,
                                                                      radius: circleData.radius)
                
            } else if let squareData = data as? CoachMarkerSquareData {
                self.currentMarkerView = self.createOverlay(offset: CGRect(origin: squareData.coordinate, size: squareData.size))
            }
            
            guard let currentMarkerView = self.currentMarkerView else { return }
            self.parentView.addSubview(currentMarkerView)
            self.currentMarkerIndex += 1
        }
    }
    
    private func removeMarker(completion: ( () -> () )? = nil) {
        if let currentMarkerView = currentMarkerView {
            UIView.animate(withDuration: 0.25, animations: {
                currentMarkerView.alpha = 0.10
            }) { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.currentMarkerView?.removeFromSuperview()
                strongSelf.currentMarkerView = nil
                completion?()
            }
        } else {
            currentMarkerView?.removeFromSuperview()
            currentMarkerView = nil
            completion?()
        }
    }
    
    
    private func createOverlayWithCircle( xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> UIView {
        
        let overlayView = dataSource.coachMarker(self, viewForItemAtIndex: currentMarkerIndex)
        
        let firstPath = createRadiusPath(size: overlayView.frame.size, xOffset: xOffset, yOffset: yOffset, radius: radius)
        let secondPath = createRadiusPath(size: overlayView.frame.size, xOffset: xOffset, yOffset: yOffset, radius: radius + effectAnimationHeight)
        
        addAnimation(firstPath: firstPath, secondPath: secondPath, overlayView: overlayView)
        
        return overlayView
    }
    
    private func createOverlay(offset: CGRect) -> UIView {
        
        let overlayView = dataSource.coachMarker(self, viewForItemAtIndex: currentMarkerIndex)
        
        let firstPath = createOverlayPath(offset: offset, size: overlayView.bounds.size, effectHeight: 0)
        let secondPath = createOverlayPath(offset: offset, size: overlayView.bounds.size, effectHeight: effectAnimationHeight)
        
        addAnimation(firstPath: firstPath, secondPath: secondPath, overlayView: overlayView)
        
        return overlayView
    }
    
    private func createAnimateGroup(animation: CAAnimation) -> CAAnimationGroup {
        let animates = CAAnimationGroup()
        animates.animations = [animation]
        animates.autoreverses = true
        animates.repeatCount = .infinity
        animates.duration = 0.4
        return animates
    }
    
    private func addAnimation(firstPath: CGMutablePath, secondPath: CGMutablePath, overlayView: UIView) {
        // Note: this keyPath is a not hard coded text, it's a keyword of animation
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = firstPath
        pathAnimation.toValue = secondPath
        
        let shape = createShape(path: firstPath)
        shape.add(createAnimateGroup(animation: pathAnimation), forKey: nil)
        overlayView.layer.mask = shape
        overlayView.clipsToBounds = true
    }
    
    private func createRadiusPath(size: CGSize, xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: xOffset, y: yOffset),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(CGRect(origin: .zero, size: size))
        
        return path
    }
    
    private func createOverlayPath(offset: CGRect, size: CGSize, effectHeight: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()
        path.addRoundedRect(in: CGRect(x: offset.origin.x, y: offset.origin.y - effectHeight, width: offset.width, height: offset.height), cornerWidth: 4, cornerHeight: 4)
        path.addRect(CGRect(origin: .zero, size: size))
        return path
    }
    
    private func createShape(path: CGPath) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        return maskLayer
    }
}

final class CoachMarkerCircleData: CoachMarkerData {
    var radius: CGFloat!
    
    required init(coordinate: CGPoint = .zero, radius: CGFloat = 30) {
        super.init()
        self.coordinate = coordinate
        self.radius = radius
    }
}

final class CoachMarkerSquareData: CoachMarkerData {
    var size: CGSize = CGSize.zero
    
    required init(coordinate: CGPoint = .zero, size: CGSize = .zero) {
        super.init()
        self.coordinate = coordinate
        self.size = size
    }
}

class CoachMarkerData: NSObject {
    var coordinate = CGPoint.zero
}


