//
//  CountryListModelClass.swift
//  CoreDataTask
//
//  Created by ios1 on 24/10/18.
//  Copyright © 2018 ios. All rights reserved.
//

import Foundation

class CountryListModelClass{
    var countryDetails : [CountryDetails] = []
    func parseJSON(completion: @escaping ((_ data: [CountryDetails]) -> Void)){
        let url = URL(string: "")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let str = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                self.countryDetails = []
               
                for anitem in str as! [[String: Any]]{
                self.countryDetails.append(CountryDetails(dict: anitem))
                }
                completion(self.countryDetails)
            } catch {
                print("json error: \(error)")
            }
        }
        task.resume()
        
    }
}

    struct CountryDetails{
        var alpha2Code: String = ""
        var alpha3Code: String = ""
        var area: String = ""
        var capital: String = ""
        var gini: String = ""
        var name: String = ""
        var nativeName: String = ""
        var numericCode: String = ""
        var population: String = ""
        var region : String = ""
        var relevance: String = ""
        var subregion: String = ""
        
        init(dict: [String: Any]) {
            checkforNull(variable: &self.alpha2Code, key: dict["alpha2Code"] as Any, dict: dict)
            checkforNull(variable: &self.alpha3Code, key: dict["alpha3Code"] as Any, dict: dict)
            checkforNull(variable: &self.area, key: dict["area"] as Any, dict: dict)
            checkforNull(variable: &self.capital, key: dict["capital"] as Any, dict: dict)
            checkforNull(variable: &self.gini, key: dict["gini"] as Any, dict: dict)
            checkforNull(variable: &self.name, key: dict["name"] as Any, dict: dict)
            checkforNull(variable: &self.nativeName, key: dict["nativeName"] as Any, dict: dict)
            checkforNull(variable: &self.numericCode, key: dict["numericCode"] as Any, dict: dict)
            checkforNull(variable: &self.population, key: dict["population"] as Any, dict: dict)
            checkforNull(variable: &self.region, key: dict["region"] as Any, dict: dict)
            checkforNull(variable: &self.subregion, key: dict["subregion"]as Any, dict: dict)
            checkforNull(variable: &self.relevance, key: dict["relevance"] as Any, dict: dict)
       
        }
    }
    func checkforNull( variable : inout String, key : Any, dict : [ String:Any]){
        if(key as? String != nil){
            
            if(nullToNil(value: key as AnyObject)) != nil{
                variable = key as! String}
        }
        
    }
    
    func nullToNil(value : AnyObject?) -> String? {
        if value is NSNull {
            return ""
        } else {
            return "\(value!)"
    }
}
