//
//  ResultsListViewCell.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 1/29/23.
//

import UIKit

class ResultsListViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
