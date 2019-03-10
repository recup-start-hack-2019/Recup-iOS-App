//
//  CustomErrors.swift
//  Recup
//
//  Created by Daniel Montano on 09.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import Foundation

struct CustomError: LocalizedError {
    
    var title: String?
    var code: Int
    var errorDescription: String { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
    
    func append(str: String) -> CustomError {
        return CustomError(title: self.title, description: "\(self._description): \(str)", code: self.code)
    }
}

class CustomErrors {
    
    static let functionCallFailed = CustomError(title: "Function Error", description: "An error ocurred", code: 102)
    
    
}
