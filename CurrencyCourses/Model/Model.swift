//
//  Model.swift
//  CurrencyCourses
//
//  Created by Рома on 26.01.2020.
//  Copyright © 2020 Рома. All rights reserved.
//
//http://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002

import Foundation

// MARK: - Model
class Model: NSObject, XMLParserDelegate {
    
    //singleton
    static let shared = Model()
    
    // MARK: - Properties
    var currencies: [Currency] = []
    var currentDate: String = ""
    
    var currentCurrency: Currency?
    var currentCharacters: String = ""
    
    //конвертация - property
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
    
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/data.xml"
        
        //проверяем, существует ли файл
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        //если файла не существует, берем загруженный
        return Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    var urlForXML: URL {
        return URL(fileURLWithPath: pathForXML)
    }
    
    
    // MARK: - Methods
    
    //загрузка XML с cbr.ru и сохранение его в каталоге приложения
    func loadXMLFile(date: Date?) {
        var strURL = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        if date != nil {
            //получаем текущую дату
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            //добавляем дату к адресу url
            strURL = strURL + dateFormatter.string(from: date!)
        }
        
        let url = URL(string: strURL)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
           
            var errrorGlobal: String?
            
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/data.xml"
                
                let urlForSave = URL(fileURLWithPath: path)
                
                do {
                    try data?.write(to: urlForSave)
                    print("Файл загружен")
                    //как только файл загружен, парсим
                    self.parseXML()
                } catch  {
                    print("Error when save data: \(error.localizedDescription)")
                    errrorGlobal = error.localizedDescription
                }
                
            } else {
                print("error when load xml file" + error!.localizedDescription)
                errrorGlobal = error?.localizedDescription
            }
            
            if let errrorGlobal = errrorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name("ErrorWhenXMLLoading"), object: self, userInfo: ["ErrorName": errrorGlobal])
            }
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
        
        task.resume()
    }
    
    //распарсить XML и положить его в в currencies, отправить уведомление приложению о том что данные обновились
    func parseXML() {
        //чтобы список не зацикливался
        currencies = [Currency.rouble()]
        
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        
        print("Данные обновлены")
        
        //уведомления - NotificationCenter
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
        //в контроллере нужно отловить это уведомление и обновить view
        
        //обновляем данные при конвертации
        for c in currencies {
            if c.CharCode == fromCurrency.CharCode {
                fromCurrency = c
            }
            if c.CharCode == toCurrency.CharCode {
                toCurrency = c
            }
        }
        
    }
    
    //конвертация -  Method
    func convert(amount: Double?) -> String {
        
        if amount == nil {
            return ""
        }
        
        let d = ((fromCurrency.nominalDouble! * fromCurrency.valueDouble!) / (toCurrency.nominalDouble! * toCurrency.valueDouble!)) * amount!
        
        return String(d)
        
    }
    
    //MARK: - XMLParserDelegate
    
    //когда элемент открываеся - "Value"
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "ValCurs" {
            if let currentDateString = attributeDict["Date"] {
                currentDate = currentDateString
            }
        }
        
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
        
    }
    
    //когда находит символы между "Value" и "/Value"
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
    }
    
    //когда элемент закрывается - "/Value"
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "NumCode" {
            currentCurrency?.NumCode = currentCharacters
        }
        
        if elementName == "CharCode" {
            currentCurrency?.CharCode = currentCharacters
        }
        
        if elementName == "Nominal" {
            currentCurrency?.Nominal = currentCharacters
            currentCurrency?.nominalDouble = Double(currentCharacters)
        }
        
        if elementName == "Name" {
            currentCurrency?.Name = currentCharacters
        }
        
        if elementName == "Value" {
            currentCurrency?.Value = currentCharacters
            currentCurrency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        if elementName == "Valute" {
            currencies.append(currentCurrency!)
        }
    }
}

