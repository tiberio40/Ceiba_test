//
//  EmptyView.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 29/04/23.
//

import UIKit

class EmptyView: UIView {
    
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "List is empty"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.gray
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        label.center = self.center
    }
}
