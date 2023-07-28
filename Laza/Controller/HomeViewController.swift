//
//  HomeViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 27/07/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the API function here
        fetchDataFromAPI()
        
        // Set up the collection view delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register the custom cell
        let cellNib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
    
    func fetchDataFromAPI() {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                // Handle the response data here
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let productsArray = jsonResponse as? [[String: Any]] {
                        self.products = productsArray
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        let product = products[indexPath.item]
        if let title = product["title"] as? String,
           let price = product["price"] as? Double,
           let imageString = product["image"] as? String,
           let imageUrl = URL(string: imageString) {
            cell.titleLabel.text = title
            cell.priceLabel.text = "$ \(price)"
            
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.productImageView.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 300)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    // UICollectionViewDelegate method for handling cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.product = product
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
