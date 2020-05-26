//
//  Currency.swift
//  CurrencyCourses
//
//  Created by Роман Елфимов on 25.05.2020.
//  Copyright © 2020 Рома. All rights reserved.
//

import UIKit

//MARK: - Currency

class Currency {
    
    //MARK: - Properties
    var NumCode: String?
    var CharCode: String?
    
    var Nominal: String?
    var nominalDouble: Double?
    
    var Name: String?
    
    var Value: String?
    var valueDouble: Double?
    
    var imageFlag: UIImage? {
        if let CharCode = CharCode {
            return UIImage(named: CharCode)
        }
        return nil
    }
    
    //MARK: - Class Method
    //инициализирует рубль
    class func rouble() -> Currency {
        let r = Currency()
        r.CharCode = "RUR"
        r.Name = "Российский рубль"
        r.Nominal = "1"
        r.nominalDouble = 1
        r.Value = "1"
        r.valueDouble = 1
        
        return r
    }
}
