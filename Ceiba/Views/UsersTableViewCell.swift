//
//  UsersTableViewCell.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 27/04/23.
//

import UIKit
import SkeletonView

class UsersTableViewCell: UITableViewCell {
    
    var user: UserDTO?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var publicationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [titleLabel, phoneLabel, emailAddressLabel, publicationButton].forEach{
            $0?.showAnimatedSkeleton()
        }
        
        titleLabel.skeletonPaddingInsets = .zero
        phoneLabel.lastLineFillPercent = 100
        // Initialization code
    }
    
    func setValues(user: UserDTO){
        self.titleLabel.text = user.name
        self.phoneLabel.text = self.cleanPhoneNumber(phoneNumber: user.phone)
        self.emailAddressLabel.text = user.email.lowercased()
        self.hideAnimation()
        
        self.user = user
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func cleanPhoneNumber(phoneNumber: String) -> String{
        let charactersToRemove: Set<Character> = [" ", "(", ")", "-", "."]
        var phoneNumberCleaned = phoneNumber
        
        phoneNumberCleaned.removeAll { charactersToRemove.contains($0) }
        let phoneSplit = phoneNumberCleaned.split(separator: "x")
        phoneNumberCleaned = String(phoneSplit[0])
        return self.formatPhoneNumber(phoneNumberCleaned)
    }
 
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let length = cleanPhoneNumber.count
        let hasLeadingOne = length > 10
        
        var index = 0
        let formattedString = NSMutableString()
        
        if hasLeadingOne {
            formattedString.append("1 ")
            index += 1
        }
        
        if (length - index) > 3 {
            let areaCodeRange = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: index)..<cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: index + 3)
            let areaCode = cleanPhoneNumber[areaCodeRange]
            formattedString.appendFormat("(%@) ", areaCode as CVarArg)
            index += 3
        }
        
        if (length - index) > 3 {
            let prefixRange = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: index)..<cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: index + 3)
            let prefix = cleanPhoneNumber[prefixRange]
            formattedString.appendFormat("%@-", prefix as CVarArg)
            index += 3
        }
        
        let remainingDigits = cleanPhoneNumber.suffix(from: cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: index))
        formattedString.append(String(remainingDigits))
        
        return formattedString as String
    }
    
    func hideAnimation() {
        [titleLabel, phoneLabel, emailAddressLabel, publicationButton].forEach{
            $0?.hideSkeleton()
        }
    }

}
