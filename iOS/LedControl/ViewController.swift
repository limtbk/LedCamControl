//
//  ViewController.swift
//  LedControl
//
//  Created by lim on 4/25/19.
//  Copyright © 2019 lim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let ledController: LedController = EspWebLedController(urlString: "http://10.0.0.133")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func checkLedsPressed(_ sender: Any) {
        
        self.checkPixel(0)
    }
    
    func checkPixel(_ index: Int) {
        let i = index
        if index < ledController.length() {
            self.ledController.setPixel(index: i, color: UIColor(white: 1.0, alpha: 0.0))
            self.ledController.sync { (success) in
                if !success {
                    return
                }
                self.ledController.setPixel(index: i, color: UIColor(white: 0.0, alpha: 0.0))
                self.checkPixel(i + 1)
            }
        } else {
            self.ledController.sync { (success) in }
        }
    }
    
}

