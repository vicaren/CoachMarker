//
//  UIView+NibLoadable.swift
//  CoachMarkerApp
//
//  Created by Emre Çiftçi on 10.11.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit

public extension UIView {

  func loadViewFromNib(_ nibName: String) -> UIView {

    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)

    if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
      view.frame = self.bounds

      view.autoresizingMask = [
        UIView.AutoresizingMask.flexibleWidth,
        UIView.AutoresizingMask.flexibleHeight
      ]
      return view
    }

    return UIView()
  }
}
