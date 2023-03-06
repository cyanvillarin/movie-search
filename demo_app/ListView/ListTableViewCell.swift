//
//  ListTableViewCell.swift
//  demo_app
//
//  Created by Villarin, Cyan on 2023/03/04.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var voteLabel: UILabel!
    
    // Code written by Xcode
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Code written by Xcode
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Code written by us
    func setup(movie: Movie) {
        titleLabel.text = movie.title
        voteLabel.text = String(movie.voteCount)
    }
    
}
