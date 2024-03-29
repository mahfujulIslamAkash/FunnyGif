//
//  GifCollectionViewCell.swift
//  FunnyGif
//
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.tintColor = .white
        return view
    }()
    
    lazy var gifView: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.addSubview(indicatorView)
        indicatorView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        return view
    }()
    
    var gifViewModel = GifViewModel()
    
    override init(frame: CGRect) {
        // Initialize your cell as usual
        super.init(frame: frame)
        contentView.addSubview(gifView)
//        contentView.layer.borderWidth = 0.5
//        contentView.layer.cornerRadius = 4
//        contentView.layer.masksToBounds = true
//        contentView.clipsToBounds = true
        gifView.anchorView(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
    }
    
    func setupBinders(){
        setupLoadedBinder()
        setupIsLoadingBinder()
        gifViewModel.fetchGifImage()
    }
    
    private func setupLoadedBinder(){
        gifViewModel.isLoaded.binds({[weak self] success in
            self?.update()
        })
    }
    
    private func setupIsLoadingBinder(){
        gifViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    private func update(){
        
        DispatchQueue.main.async {[weak self] in
            self?.gifView.image = self?.gifViewModel.getGifImage()
            self?.indicatorView.stopAnimating()
        }
        
    }
    private func loadingAnimation(_ isLoading: Bool){
        if isLoading{
            DispatchQueue.main.async {[weak self] in
                self?.indicatorView.startAnimating()
            }
        }else{
            DispatchQueue.main.async {[weak self] in
                self?.indicatorView.stopAnimating()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
