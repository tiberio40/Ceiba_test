//
//  UsersTableViewCell.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 27/04/23.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    var user: UserDTO?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var publicationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(user: UserDTO){
        self.titleLabel.text = user.name
        self.phoneLabel.text = user.phone
        self.emailAddressLabel.text = user.email
        
        self.user = user
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
