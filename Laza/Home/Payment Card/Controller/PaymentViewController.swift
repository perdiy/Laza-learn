//
//  PaymentViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit
import SnackBar

protocol choosePaymentProtocol: AnyObject{
    func delegatCardPayment(cardNumber: String, bankName: String)
}

class PaymentViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate {
    var cardModels = [CreditCard]()
    var coreDataManage = CoreDataM()
    var selectedCellIndex: IndexPath?
    var numberCardChoose: String?
    weak var delegate: choosePaymentProtocol?
    var bank: String = "BNI"
    
    // view add + Back
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var addView: UIView!
    
    // collection Card
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Text Field
    @IBOutlet weak var numberCardTf: UITextField! {
        didSet{
            numberCardTf.isEnabled = false
        }
    }
    @IBOutlet weak var ownerCardTf: UITextField!{
        didSet{
            ownerCardTf.isEnabled = false
        }
    }
    @IBOutlet weak var ExpTF: UITextField!{
        didSet{
            ExpTF.isEnabled = false
        }
    }
    @IBOutlet weak var cvvTf: UITextField!{
        didSet{
            cvvTf.isEnabled = false
        }
    }
    @IBOutlet weak var empyLb: UILabel!
    
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
        
        addView.layer.cornerRadius = addView.bounds.height / 2.0
        addView.clipsToBounds = true
        // Konfigurasi tata letak koleksi (collection layout)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.minimumLineSpacing = 30
        collectionView.collectionViewLayout = layout
        // reload collection
        collectionView.reloadData()
        
        collectionView.delegate = self
        
        empyLb.isHidden = true
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCard()
        
    } 
    
    func retrieveCard() {
        cardModels.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.coreDataManage.retrieve { creditCard in
                self?.cardModels.append(contentsOf: creditCard)
                // Set first item as selected
                if self?.cardModels.count ?? 0 > 0{
                    let indexPath = IndexPath(item: 0, section: 0)
                    self?.performCardInTextfield(indexPath: indexPath)
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    // Aksi saat tombol kembali ditekan
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseCard(_ sender: Any) {
        guard let chooseCardNumber = numberCardTf.text else {return}
        let chooseBank = bank
        print("nomer kartu: \(chooseCardNumber), \(chooseBank)")
        self.delegate?.delegatCardPayment(cardNumber: chooseCardNumber, bankName: chooseBank)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func deleteCard(_ sender: Any) {
        guard let selectedCell = selectedCellIndex else {return}
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure want to delete this cards?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            self?.deleteCard(indexPath: selectedCell)
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteCard(indexPath: IndexPath) {
        // Mendapatkan kartu yang akan dihapus dari cardModels berdasarkan indexPath
        let card = cardModels[indexPath.item]
        
        // Menghapus kartu dari CoreData menggunakan coreDataManage
        coreDataManage.delete(card) { [weak self] in
            guard let self = self else { return }
            
            // hapus kartu dari array cardModels
            self.cardModels.remove(at: indexPath.item)
            
            // periksa apakah array cardModels sekarang kosong
            if self.cardModels.isEmpty {
                // Jika array sekarang kosong, tangani sesuai
                DispatchQueue.main.async {
                    // Menampilkan tampilan default karena tidak ada kartu tersisa
                    self.performCardInTextfield(indexPath: nil)
                    
                    // Memuat ulang koleksi kartu pembayaran
                    self.collectionView.reloadData()
                }
            } else {
                // Jika masih ada kartu yang tersisa, perbarui tampilan dan pilih item baru
                DispatchQueue.main.async {
                    // hapus item kartu yang dihapus dari tampilan koleksi
                    self.collectionView.deleteItems(at: [indexPath])
                    
                    // Memeriksa jika ada item terakhir yang terlihat dalam tampilan koleksi
                    if let lastRow = self.collectionView.indexPathsForVisibleItems.last {
                        // Membuat indeks baru untuk item yang akan dipilih
                        let newIndex = IndexPath(item: min(lastRow.item, self.cardModels.count - 1), section: 0)
                        
                        // panggil func performCardInTextfield untuk menampilkan kartu yang baru dipilih
                        self.performCardInTextfield(indexPath: newIndex)
                        
                        // pilih item yang baru dipilih dalam tampilan koleksi
                        self.collectionView.selectItem(at: newIndex, animated: true, scrollPosition: .centeredHorizontally)
                    }
                    print("Berhasil menghapus kartu")
                }
            }
        }
    }
    
    @IBAction func editCard(_ sender: Any) {
        guard let editCardBtn = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "EditCardViewController") as? EditCardViewController else { return }
        guard let numberCard = numberCardTf.text else {return}
        guard let nameCard = ownerCardTf.text else {return}
        editCardBtn.editCardOwner = nameCard
        editCardBtn.editCardNumber = numberCard
        editCardBtn.indexPathCardNumber = self.numberCardChoose
        self.navigationController?.pushViewController(editCardBtn, animated: true)
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let addPaymentVC = storyboard.instantiateViewController(withIdentifier: "AddPaymentViewController") as? AddPaymentViewController {
            self.navigationController?.pushViewController(addPaymentVC, animated: true)
        }
    }
}

extension PaymentViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("total card \(cardModels.count)")
        if cardModels.count == 0 {
            empyLb.isHidden = false
        } else {
            empyLb.isHidden = true
        }
        return cardModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        print("Screen width: \(width)")
        let heightToWidthRatio: Double = Double(200) / Double(300)
        let height = width * heightToWidthRatio
        print(width, height, separator: " - ")
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listPayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCardCollectionViewCell.identifier, for: indexPath) as? CreditCardCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let card = cardModels[indexPath.item]
        
        // untuk langsung menampilkan card semua 
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            listPayCell.fillCardDataFromCoreData(card: card)
        }
       
        return listPayCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performCardInTextfield(indexPath: indexPath)
        
    }
    //Func untuk menampilkan informasi crad di tetfield
    // MARK: - Fungsi Tampilkan Kartu di TextField
    // Fungsi untuk menampilkan informasi kartu dalam teks field
    func performCardInTextfield(indexPath: IndexPath?) {
        // Periksa apakah indexPath tidak nil dan berada dalam rentang valid cardModels
        if let indexPath = indexPath, indexPath.item < cardModels.count {
            // Atur selectedCellIndex ke indexPath yang diberikan
            selectedCellIndex = indexPath
            
            // Akses data kartu berdasarkan indexPath
            let card = cardModels[indexPath.item]
            self.numberCardChoose = card.cardNumber
            ownerCardTf.text = card.cardOwner
            numberCardTf.text = card.cardNumber
            ExpTF.text = "\(card.cardExpYear)/\(card.cardExpMonth)"
            cvvTf.text = String(card.cardCvv)
        } else {
            // Hapus selectedCellIndex karena tidak ada pilihan yang valid
            selectedCellIndex = nil
            self.numberCardChoose = nil
            ownerCardTf.text = ""
            numberCardTf.text = ""
            ExpTF.text = ""
            cvvTf.text = ""
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let selectedIndexPath = selectedCellIndex else { return }
        let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        let selectedSection = selectedIndexPath.section
        let newIndexPath = IndexPath(item: currentIndex, section: selectedSection)
        performCardInTextfield(indexPath: newIndexPath)
        if currentIndex != selectedIndexPath.row {
            print("Indeks terpilih: \(currentIndex)")
        }
    }
}
