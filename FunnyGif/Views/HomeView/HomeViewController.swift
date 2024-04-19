//
//  ViewController.swift
//  FunnyGif
//
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    
    /// Custom search field for user input
    lazy var customSearchField: CustomSearchField = {
        let field = CustomSearchField(motherSize: CGSize(width: view.frame.width, height: 65))
        field.textFieldView.delegate = self
        field.seachButton.addTarget(self, action: #selector(searchTapped), for: .touchDown)
        return field
    }()
    
    /// Collection view to display GIFs
    lazy var GIFCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(GIFCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    /// Activity indicator to show loading state
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.transform = view.transform.scaledBy(x: 10, y: 10)
        view.tintColor = .white
        return view
    }()
    
    /// Stack view to organize UI components
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 15
        stack.addArrangedSubview(customSearchField)
        stack.addArrangedSubview(GIFCollection)
        stack.layer.borderWidth = 0.5
        stack.addSubview(indicatorView)
        indicatorView.centerX(inView: stack)
        indicatorView.centerY(inView: stack)
        return stack
    }()
    
    // MARK: - View Model
    
    let homeViewModel = HomeViewModel(nil)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        stackView.anchorView(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingTop: 60)
        setupObservers()
    }
    
    // MARK: - Setup Binders
    
    /// Set up observers for view model properties
    private func setupObservers() {
        setupLoadedObserver()
        setupIsLoadingObserver()
        setupErrorObserver()
    }
    
    /// Set up observer for data loaded state
    private func setupLoadedObserver() {
        homeViewModel.isLoaded.binds({[weak self] success in
            if let _ = success {
                DispatchQueue.main.async {
                    self?.GIFCollection.reloadData()
                }
            }
        })
    }
    
    /// Set up observer for loading state
    private func setupIsLoadingObserver() {
        homeViewModel.isLoading.binds({[weak self] isLoading in
            self?.loadingAnimation(isLoading)
        })
    }
    
    /// Set up observer for error state
    private func setupErrorObserver() {
        homeViewModel.error.binds({[weak self] error in
            if let _ = error {
                self?.loadingAnimation(false)
                self?.homeViewModel.showingErrorToast()
            }
        })
    }
    
    // MARK: - Loading View
    
    /// Handle loading animation
    private func loadingAnimation(_ isLoading: Bool) {
        if isLoading {
            DispatchQueue.main.async {[weak self] in
                self?.GIFCollection.layer.opacity = 0
                self?.indicatorView.startAnimating()
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.GIFCollection.layer.opacity = 1
                self?.indicatorView.stopAnimating()
            }
        }
    }
    
    // MARK: - Search Tap Action
    
    /// Action when search button is tapped
    @objc func searchTapped() {
        let _ = homeViewModel.SearchAction(customSearchField.textFieldView)
    }
}


//MARK: CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.countOfGifsResult()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return homeViewModel.getCell(collectionView, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homeViewModel.sizeOfCell(collectionView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        homeViewModel.copyToClipboard(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if homeViewModel.isThisLastCell(indexPath: indexPath){
            //need to call new offset data
            homeViewModel.searchForNextOffset()
        }else{
            //ignore
        }
    }
    
    
    
}

//MARK: Text Field Delegate
extension HomeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return homeViewModel.SearchAction(customSearchField.textFieldView)
    }
}
