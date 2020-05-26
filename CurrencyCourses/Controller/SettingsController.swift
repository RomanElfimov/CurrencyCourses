//
//  SettingsController.swift
//  CurrencyCourses
//
//  Created by Рома on 28.01.2020.
//  Copyright © 2020 Рома. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var datePicker: UIDatePicker!

 
    //MARK: - Actions
    @IBAction func pushCancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushShowCourses(_ sender: Any) {
        Model.shared.loadXMLFile(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
}
