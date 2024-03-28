//
//  GifCollectionViewCell.swift
//  FunnyGif
//
//  Created by Appnap Mahfuj on 28/3/24.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    lazy var gifView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        view.addSubview(indicatorView)
        indicatorView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        view.layer.borderWidth = 0.5
        
        return view
    }()
    var gifViewModel = GifViewModel()
    
    override init(frame: CGRect) {
        // Initialize your cell as usual
        super.init(frame: frame)
        contentView.addSubview(gifView)
        gifView.anchorView(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
    }
    
    func update(){
        indicatorView.startAnimating()
        gifViewModel.gettingImageFromPath(completion: {[weak self] image, success in
            DispatchQueue.main.async {
                self?.gifView.image = image
                self?.indicatorView.stopAnimating()
            }
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
