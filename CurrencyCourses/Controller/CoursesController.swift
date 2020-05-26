//
//  CoursesController.swift
//  CurrencyCourses
//
//  Created by Рома on 27.01.2020.
//  Copyright © 2020 Рома. All rights reserved.
//

import UIKit

class CoursesController: UITableViewController {
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catchNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Model.shared.loadXMLFile(date: nil)
    }
    
    
    //MARK: - Action
    @IBAction func pushRedreshAction(_ sender: Any) {
        Model.shared.loadXMLFile(date: nil)
    }
    
    //MARK: - Private Method
    private func catchNotifications() {
        //ловим уведомления
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "startLoadingXML"), object: nil, queue: nil) { (notification) in
            
            //обновлять интерфейс нужно в основном потоке
            DispatchQueue.main.async {
                //делаем activity indicator вмето кнопки refresh
                let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.startAnimating()
                self.navigationItem.rightBarButtonItem?.customView = activityIndicator
            }
        }
        
        //ловим уведомления
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "dataRefreshed"), object: nil, queue: nil) { (notification) in
            
            //обновлять интерфейс нужно в основном потоке
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = Model.shared.currentDate
                
                //когда данные загружены, возвращаем кнопку refresh
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.pushRedreshAction(_:)))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ErrorWhenXMLLoading"), object: nil, queue: nil) { (notification) in
            
            
            DispatchQueue.main.async {
                //alert при ошибке загрузки
                let alertController = UIAlertController(title: "Ошибка при загрузке", message: "", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.pushRedreshAction(_:)))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
        navigationItem.title = Model.shared.currentDate
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Model.shared.currencies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CoursesCell
        
        let courseForCell = Model.shared.currencies[indexPath.row]
        
        cell.initCell(currency: courseForCell)
        
        return cell
    }
}
