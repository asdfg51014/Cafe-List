//
//  File.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/31.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import Foundation

struct CallAPI2 {
    
    static func callApi(call: @escaping ([CafeAPI]) -> Void) {
        
        var callCafeApi = [CafeAPI]()
        
        let urlObj = URL(string: "https://cafenomad.tw/api/v1.2/cafes/")
        
        let task = URLSession.shared.dataTask(with: urlObj!) { (data, response, error) in
            guard let getData = data else { return }
            do {
                let dataInfo = try JSONDecoder().decode([CafeAPI].self, from: getData)
                call(dataInfo)
            } catch {
                print("error")
            }
            }.resume()
    }
}
