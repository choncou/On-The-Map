//
//  UIRoundedButton.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class UIRoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }
    
}
