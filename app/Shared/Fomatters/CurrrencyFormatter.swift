//
//  CurrrencyFormatter.swift
//  app
//
//  Created by Danilo Felipe Araujo on 05/04/24.
//

import SwiftUI

class CurrrencyFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return formattedAddress(mac: string)
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as AnyObject?
        return true
    }
    
    func formattedAddress(mac: String?) -> String? {
        guard let number = mac, let value: Double = Double(number) else { return nil }
        return "\(value.formatted(.currency(code: "brl")))"
        
    }
}
