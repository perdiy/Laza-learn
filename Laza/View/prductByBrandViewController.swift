//
//  prductByBrandViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 22/08/23.
//

import UIKit

class prductByBrandViewController: UIViewController {
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var jumlahProduct: UILabel!
    @IBOutlet weak var imgBrand: UIImageView!
    
    var products: [prodByIdBrandEntry] = []
    var brandName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProductByBrandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductByBrandCollectionViewCell")
        
        loadDataFromAPI()
    }
    
    func loadDataFromAPI() {
        let apiURLString = "https://lazaapp.shop/products/brand?name=\(brandName)"
        
        if let apiURL = URL(string: apiURLString) {
            URLSession.shared.dataTask(with: apiURL) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let productsResponse = try decoder.decode(prudctByIdBrandResponse.self, from: data)
                        self.products = productsResponse.data
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.jumlahProduct.text = "Total Products: \(self.products.count)"
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}

extension prductByBrandViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductByBrandCollectionViewCell", for: indexPath) as! ProductByBrandCollectionViewCell
        
        let product = products[indexPath.row]
        cell.nameProduct.text = product.name
        cell.priceProduct.text = "\(product.price) USD"
        
        if let imageURL = URL(string: product.imageURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        cell.imgProduct.image = UIImage(data: data)
                    }
                }
            }
        }
        
        return cell
    }
}

extension prductByBrandViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.item]
        navigateToDetailViewController(with: selectedProduct)
    }
    
    func navigateToDetailViewController(with product: prodByIdBrandEntry) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.productId = product.id
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
