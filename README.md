# CoachMarker

<p align="left">
<img src="images/coachMarker-tutorial.gif" />
</p>

`CoachMarker` is a helper to simplify onboarding tutorials

## System Requirements
iOS 8.0 or above

## Installation

#### As a CocoaPods Dependency

##### Swift

Add the following to your Podfile:
``` ruby
pod 'CoachMarker', '~> 1.0'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate CoachMarker into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "vicaren/CoachMarker" "master"
```

## Examples
Using `CoachMaker` is very simple.

### Basic Implementation

#### Swift
```swift
import CoachMarker

class ViewController: UIViewController {
    
    private var coachMarker: CoachMarker?
    
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
        // TODO: When CoachMarker finished
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

```

## License
CoachMarker is licensed under the MIT License, please see the [LICENSE](LICENSE) file.
