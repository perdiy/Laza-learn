//
//  CartTableViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func cartCellDidTapDelete(_ cell: CartTableViewCell)
    func cartCellDidTapIncrease(cell: CartTableViewCell, completion: @escaping (Int)-> Void)
    func cartCellDidTapDecrease(cell: CartTableViewCell, completion: @escaping (Int)-> Void)
    func updateCountProduct(cell: CartTableViewCell, completion: @escaping (Int)->Void)
}


class CartTableViewCell: UITableViewCell {
    var quantityProduct: Int = 0
    weak var delegate: CartTableViewCellDelegate?

    
    @IBOutlet weak var sizeProductLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var jumlahLabel: UILabel!
    func updateQuantityLabel(){
            jumlahLabel.text = String(quantityProduct)
        }

    
    @IBAction func deletCart(_ sender: Any) {
        delegate?.cartCellDidTapDelete(self)
        print("ini button delete")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateQuantityLabel()
    }
    
    @IBAction func increaseBtnTapped(_ sender: Any) {
        quantityProduct += 1
        updateQuantityLabel()
        delegate?.cartCellDidTapIncrease(cell: self, completion: {
            currentNumber in
            self.quantityProduct = currentNumber
        })
    }
    
    @IBAction func decreaseBtnTapped(_ sender: Any) {
        if quantityProduct > 0 {
            quantityProduct -= 1
            updateQuantityLabel()
            
            delegate?.cartCellDidTapDecrease(cell: self, completion: { currentNumber in
                self.quantityProduct = currentNumber
            })
        }
    }

    
    func UpdateLabelQuantityProduct() {
        delegate?.updateCountProduct(cell: self, completion: {
            currentNumber in
            self.quantityProduct = currentNumber
        })
        jumlahLabel.text = "\(quantityProduct)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
 
