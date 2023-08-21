//
//  ReviewsTableViewCell.swift
//  Laza
//
//  Created by Perdi Yansyah on 03/08/23.
//

import UIKit
import Cosmos
class ReviewsTableViewCell: UITableViewCell {
    
      
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
