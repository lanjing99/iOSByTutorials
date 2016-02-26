//
//  PaddedLabel.swift
//  KhromaLike
//
//  Created by lanjing on 2/26/16.
//  Copyright © 2016 RayWenderlich. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
    
    var verticalPadding = 0
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .Compact {
            verticalPadding = 0
        }else{
            verticalPadding = 20
        }
        invalidateIntrinsicContentSize()
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = super.intrinsicContentSize()
        size.height += CGFloat(verticalPadding)
        return size
    }
}
