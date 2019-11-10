//
//  Tutorial.swift
//  CoachMarkerApp
//
//  Created by Ahmet Doğu on 13.02.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit

protocol TutorialDelegate: class {
  func tutorialDidNextTapped(tutorial: Tutorial)
  func tutorialDidSkipTapped(tutorial: Tutorial)
}

class Tutorial: UIView {

  @IBOutlet var view: UIView!
  @IBOutlet weak var infoText: UILabel!

  private let nibName: String = "Tutorial"
  weak var delegate: TutorialDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    view = loadViewFromNib(nibName)
    addSubview(view)
  }

  @IBAction func nextTapped(_ sender: UIButton) {
    delegate?.tutorialDidNextTapped(tutorial: self)
  }

  @IBAction func skipTapped(_ sender: UIButton) {
    delegate?.tutorialDidSkipTapped(tutorial: self)
  }
}
