//
//  PaymentViewController.swift
//  Laza
//
//  Created by Perdi Yansyah on 07/08/23.
//

import UIKit

class PaymentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numberCard: UILabel!
    @IBOutlet weak var nameCard: UILabel!
    @IBOutlet weak var viewBack: UIView!

    @IBOutlet weak var numberCardTf: UITextField!
    @IBOutlet weak var ownerCardTf: UITextField!

    var originalNumberText: String = ""
    var originalNameText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        viewBack.layer.cornerRadius = viewBack.bounds.height / 2.0
        viewBack.clipsToBounds = true

        numberCardTf.delegate = self
        ownerCardTf.delegate = self

        originalNumberText = numberCard.text ?? ""
        originalNameText = nameCard.text ?? ""
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberCardTf {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            numberCard.text = newText.isEmpty ? originalNumberText : newText
        } else if textField == ownerCardTf {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            nameCard.text = newText.isEmpty ? originalNameText : newText
        }
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Restore original texts when the view appears again
        numberCard.text = originalNumberText
        nameCard.text = originalNameText
    }

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addNewCardBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        if let addPaymentVC = storyboard.instantiateViewController(withIdentifier: "AddPaymentViewController") as? AddPaymentViewController {
            self.navigationController?.pushViewController(addPaymentVC, animated: true)
        }
    }
}
