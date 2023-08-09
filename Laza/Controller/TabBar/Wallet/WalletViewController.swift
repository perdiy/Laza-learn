//
//  WalletViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 08/08/23.
//

import UIKit
import Stripe
import CreditCardForm

class WalletViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cardCreditView: CreditCardFormView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItemImage()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Register custom cell nib
        let nib = UINib(nibName: "MyCardCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MyCardCollectionViewCell")
        
    }
    
    
    // MARK: Setup BarItem when Clicked Change into Text
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Wallet"
        label.textColor = UIColor(named: "PurpleButton")
        label.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }
    
}

extension WalletViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCardCollectionViewCell", for: indexPath) as! MyCardCollectionViewCell
        return cell
    }
    
    
    
}
