//
//  ConverterController.swift
//  CurrencyCourses
//
//  Created by Рома on 28.01.2020.
//  Copyright © 2020 Рома. All rights reserved.
//

import UIKit

class ConverterController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var labelCoursesForDate: UILabel!
   
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    
    
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        textFrom.delegate = self
    }
    
    //когда view начинает появляться
    override func viewWillAppear(_ animated: Bool) {
        //каждый раз обновляем кнопки
        refreshButtons()
        textFromEditingChanged(self)
        labelCoursesForDate.text = "Курсы на \(Model.shared.currentDate)"
        navigationItem.rightBarButtonItem = nil
    }
    
    
    //MARK: - Actions 
    @IBAction func pushFromAction(_ sender: Any) {
       
        let nc =  storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectController).flagCurrency = .from
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    @IBAction func pushToAction(_ sender: Any) {
       let nc =  storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectController).flagCurrency = .to
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    
    @IBAction func textFromEditingChanged(_ sender: Any) {
        let amount = Double(textFrom.text!)
        if amount != nil {
            textTo.text = Model.shared.convert(amount: amount)
        }
    }
    
    @IBAction func pushDoneAction(_ sender: Any) {
        textFrom.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    
    //MARK: - Methods
    func refreshButtons() {
        buttonTo.setTitle(Model.shared.toCurrency.CharCode, for: .normal)
        
        buttonFrom.setTitle(Model.shared.fromCurrency.CharCode, for: .normal)
    }
    

}

extension ConverterController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = buttonDone
        return true
    }
}
