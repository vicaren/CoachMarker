//
//  ViewController.swift
//  CoachMarkerApp
//
//  Created by Ahmet Doğu on 13.02.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coachMarker: CoachMarker?
    
    let markerTexts = [
        "Two driven jocks help fax my big quiz.",
        "Pack my box with five dozen liquor jugs.",
        "The five boxing wizards jump quickly." ]
    
    let markerData = [ CoachMarkerCircleData(coordinate: CGPoint(x: 10, y: 10), radius: 30),
                       CoachMarkerCircleData(coordinate: CGPoint(x: 300, y: 50), radius: 60),
                       CoachMarkerSquareData(coordinate: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 50))]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCoachMarker()
    }
    
    func showCoachMarker() {
        coachMarker = CoachMarker(parentView: self.view, dataSource: self)
        coachMarker?.delegate = self
        coachMarker?.showCoachMarker()
    }
}
extension ViewController: CoachMarkerDataSource {
    func numberOfMarkers(in marker: CoachMarker) -> Int {
        return markerTexts.count
    }
    
    func coachMarker(_ coachMarker: CoachMarker, viewForItemAtIndex: Int) -> UIView {
        let tutorial = Tutorial(frame: view.bounds)
        tutorial.delegate = self
        tutorial.infoText.text = markerTexts[viewForItemAtIndex]
        return tutorial
    }
    
    func coachMarker(_ coachMarker: CoachMarker, markerForItemAtIndex: Int) -> CoachMarkerData {
        return markerData[markerForItemAtIndex]
    }
    
}
extension ViewController: CoachMarkerDelegate {
    func coachMarkerDidShow(_ coachMarker: CoachMarker) {
        print(#function)
    }
}
extension ViewController: TutorialDelegate {
    func tutorialDidSkipTapped(tutorial: Tutorial) {
        coachMarker?.skipCoachMarker()
    }
    
    func tutorialDidNextTapped(tutorial: Tutorial) {
        coachMarker?.nextCoachMarker()
    }
}

