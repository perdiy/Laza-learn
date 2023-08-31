//
//  BrandAllViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 21/08/23.
//

import UIKit

class BrandAllViewController: UIViewController {
    
    var receivedData: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var jumlahBrand: UILabel!
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jumlahBrand.text = "Total Categories: \(receivedData.count)"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "BrandAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandAllCollectionViewCell")
    }
    
    func navigateToProductByBrand(with brandName: String) {
        let storyboard = UIStoryboard(name: "ProductByBrand", bundle: nil)
        if let productByBrandVC = storyboard.instantiateViewController(withIdentifier: "prductByBrandViewController") as? prductByBrandViewController {
            productByBrandVC.brandName = brandName
            navigationController?.pushViewController(productByBrandVC, animated: true)
        }
    }
}

extension BrandAllViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receivedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandAllCollectionViewCell", for: indexPath) as? BrandAllCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = receivedData[indexPath.item]
        cell.nameBrand.text = data
        
        return cell
    }
}

extension BrandAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 100
    }
}

extension BrandAllViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBrand = receivedData[indexPath.item]
        navigateToProductByBrand(with: selectedBrand)
    }
}
