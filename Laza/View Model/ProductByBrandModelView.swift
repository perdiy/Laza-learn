//
//  ProductByBrandModelView.swift
//  Laza
//
//  Created by Perdi Yansyah on 06/09/23.
//

import Foundation

class CategoryBrandModel{
    func getDataBrandProductApi(name: String,completion: @escaping (productByIdBrandIndex) -> ()) {
        
        guard let url = URL(string: Endpoints.Gets.brandProduct(nameBrand: name).url) else {return}

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let productList = try JSONDecoder().decode(productByIdBrandIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(productList)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}
