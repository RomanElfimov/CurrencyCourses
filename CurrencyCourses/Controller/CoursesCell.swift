//
//  CoursesCell.swift
//  CurrencyCourses
//
//  Created by Рома on 29.01.2020.
//  Copyright © 2020 Рома. All rights reserved.
//

import UIKit

class CoursesCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var labelCurrencyName: UILabel!
    @IBOutlet weak var labelCourse: UILabel!    
    
    //MARK: - Method
    func initCell(currency: Currency) {
        imageFlag.image = currency.imageFlag
        labelCurrencyName.text = currency.Name
        labelCourse.text = currency.Value
    }

}
