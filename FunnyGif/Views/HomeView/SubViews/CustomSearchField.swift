//
//  CustomSearchField.swift
//  FunnyGif
//
//  Created by Appnap Mahfuj on 27/3/24.
//

import UIKit

class CustomSearchField: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    lazy var statckView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 5
        stack.addArrangedSubview(fieldIcon)
        stack.addArrangedSubview(textField)
        stack.addArrangedSubview(seachButton)
        stack.layer.borderWidth = 0.5
        return stack
    }()
    
    lazy var fieldIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "shippingbox")?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
        view.widthAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        view.tintColor = .white
        view.layer.borderWidth = 0.5
        
        return view
    }()
    
    let textField: UIView = {
        let view = UIView()
        let textField = UITextField()
        textField.layer.borderWidth = 0.5
        textField.placeholder = "Search Gif"
        view.addSubview(textField)
        textField.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        return view
    }()
    
    lazy var seachButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        view.layer.borderWidth = 0.5
        view.tintColor = .white
        view.widthAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        view.backgroundColor = UIColor(hexString: "FF2DAF")
        return view
    }()
    
    var motherSize: CGSize = .zero
    
    init(motherSize: CGSize){
        super.init(frame: .zero)
        self.motherSize = motherSize
        setupUI(motherSize: motherSize)
        
    }
    
    func setupUI(motherSize: CGSize){
        addSubview(statckView)
        statckView.anchorView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        heightAnchor.constraint(equalToConstant: motherSize.height).isActive = true
        widthAnchor.constraint(equalToConstant: motherSize.width).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
