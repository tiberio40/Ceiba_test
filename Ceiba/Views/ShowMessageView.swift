//
//  EmptyView.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 29/04/23.
//

import UIKit

class ShowMessageView: UIView {
    
    var presenter: LoadDataProtocol?
    let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor(named: "Blue Color")
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        return label
    }()
    var controller: AnyClass?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("  Recargar Lista  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "Blue Color")!
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(reloadAPIData), for: .touchUpInside)
        return button
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
        self.stackView.addArrangedSubview(self.button)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(self.stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 150 ).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5 ).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5 ).isActive = true
        
    }
    
    func setMenssageType(messageType: MenssageEnum){
        switch(messageType){
        case .noFound:
            self.setMessage(messageText: "No se ha encontrado algún resultado", nameOfimage: "Search Icon")
            break
        case .withoutConnection:
            self.setMessage(messageText: "Sin conexión a internet", nameOfimage: "No Wifi Icon")
        }
    }
    
    func setPresenter(presenter: LoadDataProtocol){
        self.presenter = presenter
    }
    
    private func setMessage(messageText: String, nameOfimage: String){
        self.label.text = messageText
        let image = UIImage(named: nameOfimage)
        self.imageView.image = image
    }
    
    @objc func reloadAPIData(_ sender: UIButton) {
        guard let presenter = self.presenter else {
            return
        }
        
        presenter.loadAPIData()
    }
}
