//
//  GetDataFile.swift
//  CafeNomad
//
//  Created by Albert on 2019/1/20.
//  Copyright © 2019 Albert.C. All rights reserved.
//

import Foundation

//enum Citys: String {
//    case
//    case taipei = "Taipei"
//}

struct GetData {
    static func getData(callBack: @escaping ([CafeAPI]) -> Void){
        let url = URL(string: "https://cafenomad.tw/api/v1.2/cafes/")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            do {
                let shopData = try JSONDecoder().decode([CafeAPI].self, from: data)
                callBack(shopData)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
