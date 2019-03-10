//
//  Utils.swift
//  Recup
//
//  Created by Daniel Montano on 09.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static var nib: UINib {
        
        return UINib(nibName: "\(self)", bundle: nil)
    }
}

extension UINib {
    
    func instantiate() -> Any? {
        
        return self.instantiate(withOwner: nil, options: nil).first
    }
}

extension UIView {
    
    static func instantiateFromNib() -> Self? {
        
        func instanceFromNib<T: UIView>() ->T? {
            
            return nib.instantiate() as? T
        }
        
        return instanceFromNib()
    }
}
