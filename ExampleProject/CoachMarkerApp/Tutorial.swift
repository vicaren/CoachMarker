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
    private let nibName: String = "Tutorial"
    
    @IBOutlet weak var infoText: UILabel!
    
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
    
    func didLoad(selectedIndex: Int, delegate: TutorialDelegate) {
        self.delegate = delegate
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        delegate?.tutorialDidNextTapped(tutorial: self)
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        delegate?.tutorialDidSkipTapped(tutorial: self)
    }

}
extension UIView {
    func loadViewFromNib(_ nibName: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { return UIView() }
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        return view
    }
}
