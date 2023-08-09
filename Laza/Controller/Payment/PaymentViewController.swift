//
//  PaymentViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class PaymentViewController: UIViewController, UITextFieldDelegate {
    
    // Outlet untuk elemen tampilan
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberCardTf: UITextField!
    @IBOutlet weak var ownerCardTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom cell nib
        let nib = UINib(nibName: "CreditCardCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CreditCardCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Mengatur sudut melengkung untuk tampilan viewBack
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true
        
        // Konfigurasi tata letak koleksi (collection layout)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.minimumLineSpacing = 30
        collectionView.collectionViewLayout = layout
        
    }
    
    // Aksi saat tombol kembali ditekan
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Aksi saat tombol tambah kartu baru ditekan
    @IBAction func addNewCardBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let addPaymentVC = storyboard.instantiateViewController(withIdentifier: "AddPaymentViewController") as? AddPaymentViewController {
            self.navigationController?.pushViewController(addPaymentVC, animated: true)
        }
    }
}

extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreditCardCollectionViewCell", for: indexPath) as! CreditCardCollectionViewCell
        return cell
    }
    
    
    
}
