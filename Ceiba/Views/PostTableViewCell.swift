//
//  PostTableViewCell.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 29/04/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(userPost: PostDTO){
        self.titleLabel.text = userPost.title
        self.bodyLabel.numberOfLines = 0
        self.bodyLabel.text = userPost.body.replacingOccurrences(of: "\n", with: " ")
    }

}
