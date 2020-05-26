//
//  SelectController.swift
//  CurrencyCourses
//
//  Created by Рома on 28.01.2020.
//  Copyright © 2020 Рома. All rights reserved.
//

import UIKit

//MARK: - Enum FlagCurrencySelected
enum FlagCurrencySelected {
    case from
    case to
}

 
//MARK: - SelectController
class SelectController: UITableViewController {

    //MARK: - Property
    var flagCurrency: FlagCurrencySelected = .from
    

    //MARK: - Action
    @IBAction func pushCancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Model.shared.currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let currentCurrency: Currency = Model.shared.currencies[indexPath.row]
        cell.textLabel?.text = currentCurrency.Name
        cell.textLabel?.textColor = .white
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency: Currency = Model.shared.currencies[indexPath.row]
        if flagCurrency == .from {
            Model.shared.fromCurrency = selectedCurrency
        }
        if flagCurrency == .to {
            Model.shared.toCurrency = selectedCurrency
        }
        dismiss(animated: true, completion: nil)
        w
    }
}
