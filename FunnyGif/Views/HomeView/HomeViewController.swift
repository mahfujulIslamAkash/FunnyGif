//
//  ViewController.swift
//  FunnyGif
//
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: UI Component
    lazy var searchField: CustomSearchField = {
        let field = CustomSearchField(motherSize: CGSize(width: view.frame.width, height: 65))
        field.textFieldView.delegate = self
        field.seachButton.addTarget(self, action: #selector(searchTapped), for: .touchDown)
        return field
    }()
    
    lazy var gifCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.showsVerticalScrollIndicator = false
        view.addSubview(indicatorView)
        indicatorView.centerX(inView: view)
        indicatorView.centerY(inView: view)
        return view
        
    }()
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.transform = view.transform.scaledBy(x: 10, y: 10)
        view.tintColor = .white
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
        return stack
    }()
    
    //MARK: View Model
    let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        stackView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingTop: 60)
        setupBinders()
        
    }
    
    //MARK: Setup Binders
    private func setupBinders(){
        setupLoadedBinder()
        setupIsLoadingBinder()
        setupErrorBinder()
        homeViewModel.callApi(nil)
    }
    
    //This binder will trigger after fetching online data
    private func setupLoadedBinder(){
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
    
    //This binder will trigger when loading need to change its state
    private func setupIsLoadingBinder(){
        homeViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    //This binder will trigger after fetching online data
    private func setupErrorBinder(){
        homeViewModel.error.binds({[weak self] error in
            if let error = error{
                //error handle
                self?.homeViewModel.showingErrorToast()
            }
        })
    }
    
    
    //MARK: Loading View
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
    
    //MARK: Search Tap Action
    @objc func searchTapped(){
        homeViewModel.callApi(searchField.textFieldView.text)
        view.endEditing(true)
    }
}

//MARK: CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.countOfGifsResult()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GifCollectionViewCell
        cell.gifViewModel = homeViewModel.viewModelOfGif(indexPath)
        cell.setupBinders()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homeViewModel.sizeOfCell(collectionView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewModel.copyToClipboard(indexPath)
    }
    
    
}

//MARK: Text Field Delegate
extension HomeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        homeViewModel.callApi(textField.text)
        return textField.resignFirstResponder()
    }
}
