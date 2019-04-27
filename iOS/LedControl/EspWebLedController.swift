//
//  EspWebLedController.swift
//  LedControl
//
//  Created by lim on 4/25/19.
//  Copyright © 2019 lim. All rights reserved.
//

import UIKit

class EspWebLedController: LedController {
    
    var ledColors: [UIColor]
    let urlString: String
    let ledCount: Int = 16
    
    init(urlString: String) {
        self.urlString = urlString
        self.ledColors = [UIColor](repeating: UIColor.black, count: self.ledCount)
    }
    
    func length() -> Int {
        return self.ledCount;
    }
    
    func setPixel(index: Int, color: UIColor) {
        self.ledColors[index] = color
    }
    
    func getPixel(index: Int) -> UIColor {
        return self.ledColors[index]
    }
    
    func sync(completionHandler: @escaping (Bool) -> Void) {
        var bytes = [UInt8]()
        for color in self.ledColors {
            var fr: CGFloat = 0
            var fg: CGFloat = 0
            var fb: CGFloat = 0
            var fa: CGFloat = 0
            if color.getRed(&fr, green: &fg, blue: &fb, alpha: &fa) {
                let ir = Int(fr * 255.0)
                let ig = Int(fg * 255.0)
                let ib = Int(fb * 255.0)
                bytes.append(UInt8(ir))
                bytes.append(UInt8(ig))
                bytes.append(UInt8(ib))
            } else {
                // Could not extract RGBA components:
            }
        }
        
        var urlStr = self.urlString + "/M"
        for b in bytes {
            let i: Int = (Int(b) * 9) / 255
            urlStr = urlStr + String(i)
        }
        
        let urlOn = URL(string: urlStr)!
//        let urlOff = URL(string: self.urlString + "/R")!
        URLSession.shared.dataTask(with: urlOn) { (
            data: Data?, response: URLResponse?, error: Error?) in
//            URLSession.shared.dataTask(with: urlOff) { (
//                data: Data?, response: URLResponse?, error: Error?) in
//
//                }.resume()
            if error != nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }.resume()
    }
    

}
