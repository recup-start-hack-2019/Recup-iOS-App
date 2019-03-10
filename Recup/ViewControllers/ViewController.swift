//
//  ViewController.swift
//  Recup
//
//  Created by Daniel Montano on 08.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import UIKit
import BitcoinKit

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var logoView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoView.alpha = 0.0
        let animationDuration = 0.5
        
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.logoView.alpha = 1
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                self.performSegue(withIdentifier: "MainSegue", sender: nil)
            })
            
        })
    }
    
   
}

