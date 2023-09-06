//
//  BrandAllViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 21/08/23.
//

import UIKit

class BrandAllViewController: UIViewController {
    
    // Data yang akan diterima dan ditampilkan di koleksi
    var receivedData: [String] = []
    
    // Outlet untuk elemen-elemen tampilan
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var jumlahBrand: UILabel!
    
    // Aksi yang akan dipanggil saat tombol kembali ditekan
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Fungsi yang dipanggil saat tampilan dimuat
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mengatur sudut lengkungan untuk latar belakang
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        // Mengatur teks jumlah merek yang akan ditampilkan
        jumlahBrand.text = "\(receivedData.count) Items"
        
        // Mengatur dataSource dan delegate untuk koleksi
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Mendaftarkan sel yang akan digunakan dalam koleksi
        collectionView.register(UINib(nibName: "BrandAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandAllCollectionViewCell")
    }
    
    // Fungsi untuk navigasi ke tampilan produk berdasarkan merek
    func navigateToProductByBrand(with brandName: String) {
        let storyboard = UIStoryboard(name: "ProductByBrand", bundle: nil)
        if let productByBrandVC = storyboard.instantiateViewController(withIdentifier: "prductByBrandViewController") as? prductByBrandViewController {
            productByBrandVC.brandName = brandName
            navigationController?.pushViewController(productByBrandVC, animated: true)
        }
    }
}

// Ekstensi untuk mengimplementasikan UICollectionViewDataSource
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

// Ekstensi untuk mengatur tata letak sel dalam koleksi
extension BrandAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 100
    }
}

// Ekstensi untuk menangani pemilihan item dalam koleksi
extension BrandAllViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBrand = receivedData[indexPath.item]
        navigateToProductByBrand(with: selectedBrand)
    }
}
