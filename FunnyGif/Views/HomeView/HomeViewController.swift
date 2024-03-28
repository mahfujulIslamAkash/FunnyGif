//
//  ViewController.swift
//  FunnyGif
//
//  Created by Appnap Mahfuj on 27/3/24.
//

import UIKit

class HomeViewController: UIViewController {

    lazy var searchField: CustomSearchField = {
        let field = CustomSearchField(motherSize: CGSize(width: view.frame.width, height: 65))
        return field
    }()
    
    lazy var gifCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .blue
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.showsVerticalScrollIndicator = false
        return view
        
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 15
        stack.addArrangedSubview(searchField)
        stack.addArrangedSubview(gifCollection)
        stack.layer.borderWidth = 0.5
        stack.widthAnchor.constraint(greaterThanOrEqualToConstant: self.view.width).isActive = true
        stack.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.height).isActive = true
        return stack
    }()
    
    let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        stackView.anchorView(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60)
        setupBinder()
        homeViewModel.callApi()
    }
    
    private func setupBinder(){
        homeViewModel.isLoaded.binds({[weak self] success in
            if let _ = success{
                //reload view
                //here we will reload collectionView
                DispatchQueue.main.async {
                    self?.gifCollection.reloadData()
                }
            }
        })
    }
    


}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.countOfGifsResult()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GifCollectionViewCell
        cell.backgroundColor = UIColor.random
        cell.gifViewModel = homeViewModel.viewModelOfGif(indexPath)
        cell.update()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homeViewModel.sizeOfCell(collectionView.frame.width)
    }
    
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
