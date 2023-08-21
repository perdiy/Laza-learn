//
//  DetailModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 17/08/23.
// 

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func updateSizes(_ sizes: [SizeDetailProd])
}

class DetailViewModel {
    weak var delegate: DetailViewModelDelegate?
    
    func fetchSizes(for productId: Int) {
        getDataDetailProduct(id: productId) { [weak self] productDetail in
            guard let sizes = productDetail?.data.size else {
                print("Sizes not found")
                return
            }
            self?.delegate?.updateSizes(sizes)
        }
    }
    
    func getDataDetailProduct(id: Int, completion: @escaping (DetailProduct?) -> ()) {
        let urlString = "https://lazaapp.shop/products/\(id)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let productList = try JSONDecoder().decode(DetailProduct.self, from: data)
                completion(productList)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
