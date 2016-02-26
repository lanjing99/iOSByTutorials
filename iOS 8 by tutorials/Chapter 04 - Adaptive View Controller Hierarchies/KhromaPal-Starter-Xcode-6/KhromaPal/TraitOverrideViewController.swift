//
//  TraitOverrideViewController.swift
//  KhromaPal
//
//  Created by lanjing on 2/26/16.
//  Copyright © 2016 RayWenderlich. All rights reserved.
//

import UIKit

class TraitOverrideViewController: UIViewController {

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        var traintOveride: UITraitCollection? = nil
        if size.width > 320 {
            traintOveride = UITraitCollection(horizontalSizeClass: .Regular)
        }
        setOverrideTraitCollection(traintOveride, forChildViewController: childViewControllers.first!)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

}
