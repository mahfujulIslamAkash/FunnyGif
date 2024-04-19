//
//  HomeViewModel.swift
//  FunnyGif
//
//

import Foundation
import UIKit

class HomeViewModel {
    
    // MARK: - Properties
    init(_ searchText: String?){
        callApi(searchText)
    }
    static var shared = NetworkService()
    
    // Array to hold the search results
    private var results: [Gif]?
    
    private var lastSearch: String = "Trending"
    private var currentOffset: Int = 0
    private var limit: Int = 42
    
    // MARK: - Observable Properties
    
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    // MARK: - Methods
    
    /// Returns the count of GIFs in the search results
    func countOfGifsResult() -> Int {
        guard let gifs = results else {
            return 0
        }
        return gifs.count
    }
    func reloadPoint()->Int{
        guard let gifs = results else {
            return 0
        }
        return gifs.count
    }
    func fullReload() -> Bool{
        if let gifs = results{
            if gifs.count <= limit{
                return true
            }else{
                return false
            }
        }
        return false
    }
    func reloadIndexes() ->[IndexPath]?{
        
        var indexPathsOfNewItems: [IndexPath]?
        if let gifs = results{
            if gifs.count > 0{
                indexPathsOfNewItems = []
                for i in gifs.count-limit..<gifs.count{
                    let indexPath = IndexPath(row: i, section: 0)
                    indexPathsOfNewItems?.append(indexPath)
                }
            }
        }
        return indexPathsOfNewItems
    }
    /// Calculates the size of the collection view cell based on the parent widget's width
    func sizeOfCell(_ parentWidget: CGFloat) -> CGSize {
        let width = (parentWidget - 40) / 3
        return CGSize(width: width, height: width)
    }
    
    /// Initiates a search action based on the text entered in the search field
    func SearchAction(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            callApi(textField.text)
        }
        return textField.resignFirstResponder()
    }
    
    /// Calls the API to fetch search results based on the provided text
    func callApi(_ searchedText: String?) {
        checkInternet(completion: { [weak self] success in
            if success {
                self?.fetchingData(searchedText, self?.limit ?? 5, self?.currentOffset ?? 0)
            }
        })
    }
    
    /// Clears the search results if the searched text is different from the last search
    private func clearResult(_ searchedText: String?) {
        if searchedText != lastSearch {
            self.results = []
            isLoading.value = true
        }
    }
    
    /// Updates the last searched text
    private func updateSearchedText(_ searchedText: String?) {
        if let searchedText = searchedText {
            lastSearch = searchedText
        } else {
            lastSearch = "Trending"
        }
    }
    
    /// Fetches data from the API based on the searched text, limit, and offset
    private func fetchingData(_ searchedText: String?, _ limit: Int = 30, _ offset: Int = 0) {
        clearResult(searchedText)
        updateSearchedText(searchedText)
        
        HomeViewModel.shared.getSearchedGifs(searchedText, limit, offset, completion: { [weak self] success, results in
            if success {
                self?.isLoaded.value = success
                self?.isLoading.value = false
                self?.results?.append(contentsOf: results!)
            } else {
                self?.error.value = true
                self?.isLoading.value = false
            }
        })
    }
    
    /// Checks for internet connectivity before making API calls
    private func checkInternet(completion: @escaping (Bool) -> Void) {
        HomeViewModel.shared.checkConnectivity(completion: { [weak self] havingInternet in
            if havingInternet {
                completion(true)
            } else {
                self?.error.value = true
            }
        })
    }
    
    /// Retrieves the path of the preview GIF based on the indexPath
    private func getPreviewGifPath(_ indexPath: IndexPath) -> String {
        guard let gifs = results else {
            return ""
        }
        guard let path = gifs[indexPath.row].placeHolder else { return "" }
        return path
    }
    
    /// Retrieves the path of the original GIF based on the indexPath
    private func getOriginalGifPath(_ indexPath: IndexPath) -> String {
        guard let gifs = results else {
            return ""
        }
        guard let path = gifs[indexPath.row].original else { return "" }
        return path
    }
    
    /// Navigates to the next page of search results
    private func goToNextPage() {
        self.currentOffset += limit
        fetchingData(lastSearch, limit, currentOffset)
    }
    
    /// Returns the view model of the GIF at the given indexPath
    func viewModelOfGif(_ indexPath: IndexPath) -> GIFViewModel {
        let path = getPreviewGifPath(indexPath)
        return GIFViewModel(path: path)
    }
    
    // MARK: - Testing Methods
    
    /// Copies the original GIF URL to the clipboard based on the indexPath (For testing purposes)
    func copyToClipboard(_ indexPath: IndexPath) {
        let path = getOriginalGifPath(indexPath)
        UIView.shared.copyToClipboard(path)
    }
    
    // MARK: - Error Handling
    
    /// Shows an error toast message
    func showingErrorToast() {
        DispatchQueue.main.async {
            UIView.shared.showingToast("Error")
        }
    }
    
    // MARK: - Collection View Methods
    
    /// Returns the configured cell for the collection view
    func getCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GIFCollectionViewCell
        cell.gifViewModel = viewModelOfGif(indexPath)
        cell.setupBinders()
        return cell
    }
    
    /// Checks if the given indexPath represents the last cell in the collection view
    func endOfCollectionView(_ scrollView: UIScrollView) -> Bool {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        // Check if the user has scrolled to the bottom of the collection view
        if offsetY > contentHeight - screenHeight {
            return true
        } else {
            return false
        }
    }
    
    /// Initiates a search for the next offset of search results
    func searchForNextOffset() {
        goToNextPage()
    }
}
