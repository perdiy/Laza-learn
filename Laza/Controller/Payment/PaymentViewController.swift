//
//  PaymentViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit
import SnackBar


class PaymentViewController: UIViewController, UITextFieldDelegate {
    var cardModels = [CreditCard]()
    var coreDataManage = CoreDataM()
    var selectedCellIndex: IndexPath?
    var numberCardChoose: String?
    
    // Outlet untuk elemen tampilan
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberCardTf: UITextField!
    @IBOutlet weak var ownerCardTf: UITextField!
    @IBOutlet weak var ExpTF: UITextField!
    
    @IBOutlet weak var cvvTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // snackBar
        SnackBar.make(in: self.view, message: "Anda Menggunakan Payment Creditcard", duration: .lengthLong).show()
        
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
        collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCard()
        collectionView.reloadData()
    }
    
    func retrieveCard() {
        cardModels.removeAll()
        coreDataManage.retrieve { [weak self] creditCard in
            self?.cardModels.append(contentsOf: creditCard)
            self?.collectionView.reloadData()
        }
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

extension PaymentViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("total card \(cardModels.count)")
        return cardModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listPayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCardCollectionViewCell.identifier, for: indexPath) as? CreditCardCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let card = cardModels[indexPath.item]
        
        listPayCell.fillCardDataFromCoreData(card: card)
        return listPayCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performCardInTextfield(indexPath: indexPath)
    }
    //Func untuk menampilkan informasi crad di tetfield
    func performCardInTextfield(indexPath: IndexPath){
        selectedCellIndex = indexPath
        let card = cardModels[indexPath.item]
        self.numberCardChoose = card.cardNumber
        ownerCardTf.text = card.cardOwner
        numberCardTf.text = card.cardNumber
        ExpTF.text = card.cardExpYear + "/" + card.cardExpMonth
        cvvTf.text = card.cardCvv
        
        collectionView.reloadData()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let selectedIndexPath = selectedCellIndex else { return }
        let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        
        let selectedSection = selectedIndexPath.section
        
        let newIndexPath = IndexPath(item: currentIndex, section: selectedSection)
        
        performCardInTextfield(indexPath: newIndexPath)
        
        if currentIndex != selectedIndexPath.row {
            // Melakukan tindakan yang sesuai jika currentIndex berbeda
            print("Indeks terpilih setelah berhenti: \(currentIndex)")
        }
    }
    
    
}
