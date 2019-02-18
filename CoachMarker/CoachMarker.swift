//
//  CoachMarker.swift
//  CoachMarker
//
//  Created by Ahmet Doğu on 13.02.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit

public protocol CoachMarkerDelegate: class {
    func coachMarkerDidShow(_ coachMarker: CoachMarker)
}

public protocol CoachMarkerDataSource: class {
    func numberOfMarkers(in marker: CoachMarker) -> Int
    func coachMarker(_ coachMarker: CoachMarker, viewForItemAtIndex: Int) -> UIView
    func coachMarker(_ coachMarker: CoachMarker, markerForItemAtIndex: Int) -> CoachMarkerData
}

public final class CoachMarker: NSObject {
    
    // MARK: - Private Variables etc.
    private let animationKey = "coachMarkerPathAnimation"
    private weak var dataSource: CoachMarkerDataSource?
    
    private var parentView: UIView!
    private var tutorialView = UIView(frame: .zero)
    private var pathAnimation: CABasicAnimation?
    private var currentMarkerIndex = 0
    private var currentMarkerView: UIView?
    
    // MARK: - Public Variables etc.
    public var effectAnimationHeight: CGFloat = 10
    public var effectAnimationDuration: TimeInterval = 0.4
    public var effectAnimationRepeatCount: Float = .infinity
    public var effectAnimationAutoReverses = true

    public weak var delegate: CoachMarkerDelegate?
    
    // MARK: - Init & Deinit
    public override init() { }
    
    public convenience init (parentView: UIView, dataSource: CoachMarkerDataSource) {
        self.init()
        self.parentView = parentView
        self.dataSource = dataSource
        addNotificationObservers()
    }
    
    deinit {
        removeNotificationObservers()
    }
    
    // MARK: - Public functions
    
    public func nextCoachMarker() {
        showCoachMarker()
    }
    
    public func showCoachMarker() {
        guard let dataSource = dataSource else { return }
        if currentMarkerIndex < dataSource.numberOfMarkers(in: self) {
            changeCoachMarker(data: dataSource.coachMarker(self, markerForItemAtIndex: currentMarkerIndex))
        } else {
            skipCoachMarker()
        }
    }
    
    public func skipCoachMarker() {
        removeMarker()
        delegate?.coachMarkerDidShow(self)
    }
    
    // MARK: - Private functions

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
                guard let self = self else { return }
                self.currentMarkerView?.removeFromSuperview()
                self.currentMarkerView = nil
                completion?()
            }
        } else {
            currentMarkerView?.removeFromSuperview()
            currentMarkerView = nil
            completion?()
        }
    }
    
    // MARK: - Logic

    private func createOverlayWithCircle( xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> UIView {
        
        guard let overlayView = dataSource?.coachMarker(self, viewForItemAtIndex: currentMarkerIndex) else { return UIView(frame: .zero) }
        
        let firstPath = createRadiusPath(size: overlayView.frame.size, xOffset: xOffset, yOffset: yOffset, radius: radius)
        let secondPath = createRadiusPath(size: overlayView.frame.size, xOffset: xOffset, yOffset: yOffset, radius: radius + effectAnimationHeight)
        
        addAnimation(firstPath: firstPath, secondPath: secondPath, overlayView: overlayView)
        
        return overlayView
    }
    
    private func createOverlay(offset: CGRect) -> UIView {
        
        guard let overlayView = dataSource?.coachMarker(self, viewForItemAtIndex: currentMarkerIndex) else { return UIView(frame: .zero) }
        
        let firstPath = createOverlayPath(offset: offset, size: overlayView.bounds.size, effectHeight: 0)
        let secondPath = createOverlayPath(offset: offset, size: overlayView.bounds.size, effectHeight: effectAnimationHeight)
        
        addAnimation(firstPath: firstPath, secondPath: secondPath, overlayView: overlayView)
        
        return overlayView
    }
    
    private func createAnimateGroup(animation: CAAnimation) -> CAAnimationGroup {
        let animates = CAAnimationGroup()
        animates.animations = [animation]
        animates.autoreverses = effectAnimationAutoReverses
        animates.repeatCount = effectAnimationRepeatCount
        animates.duration = effectAnimationDuration
        return animates
    }
    
    private func addAnimation(firstPath: CGMutablePath, secondPath: CGMutablePath, overlayView: UIView) {
        pathAnimation = CABasicAnimation(keyPath: "path")
        guard let pathAnimation = pathAnimation else { return }
        pathAnimation.fromValue = firstPath
        pathAnimation.toValue = secondPath
        
        let shape = createShape(path: firstPath)
        shape.add(createAnimateGroup(animation: pathAnimation), forKey: animationKey)
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
// MARK: - Restart animation when app coming from background
private extension CoachMarker {
    @objc private func didEnterBackground() {
        currentMarkerView?.layer.mask?.removeAllAnimations()
    }
    
    @objc private func willEnterForeground() {
        guard
            let currentMarkerView = currentMarkerView,
            currentMarkerView.layer.mask?.animation(forKey: animationKey) == nil,
            let pathAnimation = pathAnimation else { return }
        
        currentMarkerView.layer.mask?.add(createAnimateGroup(animation: pathAnimation), forKey: animationKey)
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground),
                                               name:  UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),
                                               name:  UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func removeNotificationObservers() {
        guard #available(iOS 9, *) else {
            NotificationCenter.default.removeObserver(self)
            return
        }
    }
}
// MARK: - Data Classes
public final class CoachMarkerCircleData: CoachMarkerData {
    var radius: CGFloat!
    
    public override init() { }
    
    public required init(coordinate: CGPoint = .zero, radius: CGFloat = 30) {
        super.init()
        self.coordinate = coordinate
        self.radius = radius
    }
}

public final class CoachMarkerSquareData: CoachMarkerData {
    var size: CGSize = CGSize.zero
    
    public override init() { }
    
    public required init(coordinate: CGPoint = .zero, size: CGSize = .zero) {
        super.init()
        self.coordinate = coordinate
        self.size = size
    }
}

public class CoachMarkerData: NSObject {
    var coordinate = CGPoint.zero
}
