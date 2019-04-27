//
//  LedController.swift
//  LedControl
//
//  Created by lim on 4/25/19.
//  Copyright © 2019 lim. All rights reserved.
//

import UIKit

protocol LedController {
    
    func length() -> Int
    func setPixel(index: Int, color: UIColor)
    func getPixel(index: Int) -> UIColor
    func sync(completionHandler: @escaping (Bool) -> Void)

}

