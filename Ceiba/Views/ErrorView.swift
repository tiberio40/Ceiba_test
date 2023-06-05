//
//  ErrorView.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 4/06/23.
//

import Foundation
import UIKit

class ErrorView: UIView{
    let label: UILabel = {
        let label = UILabel()
        label.text = "No se ha encontrado algún resultado"
        label.textAlignment = .center
        label.textColor = UIColor(named: "Blue Color")
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImage(named: "Search Icon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.backgroundColor = .white
//        addSubview(self.label)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.stackView.addArrangedSubview(self.imageView)
        self.stackView.addArrangedSubview(self.label)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(self.stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 150 ).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5 ).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5 ).isActive = true
        
    }
    
    
}
