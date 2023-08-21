//
//  BrandAllViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 21/08/23.
//
 
import UIKit

class BrandAllViewController: UIViewController {
  
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var jumlahBrand: UILabel!
    
    var receivedData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jumlahBrand.text = "Total Categories: \(receivedData.count)"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "BrandAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandAllCollectionViewCell")
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
        // Set the spacing between cells vertically
        return 10 // Adjust as needed
    }
}

extension BrandAllViewController: UICollectionViewDelegate {
    // Implement delegate methods as needed
}
