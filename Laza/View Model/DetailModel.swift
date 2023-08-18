//
//  DetailModel.swift
//  Laza
//
//  Created by Perdi Yansyah on 17/08/23.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func updateSizes(_ sizes: [DatumSize])
}

class DetailViewModel {
    weak var delegate: DetailViewModelDelegate?
    
    func fetchSizes() {
        guard let sizeURL = URL(string: "https://lazaapp.shop/size") else { return }
        
        let sizeTask = URLSession.shared.dataTask(with: sizeURL) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let sizeResponse = try decoder.decode(Size.self, from: data)
                self.delegate?.updateSizes(sizeResponse.data)
            } catch {
                print("Error fetching sizes: \(error.localizedDescription)")
            }
        }
        
        sizeTask.resume()
    }
}

 
