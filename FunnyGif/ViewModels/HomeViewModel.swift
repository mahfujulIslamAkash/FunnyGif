//
//  HomeViewModel.swift
//  FunnyGif
//
//

import Foundation
import UIKit

class HomeViewModel{
    
    static var shared = NetworkService()
    init(_ searchText: String?){
        callApi(searchText)
    }
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    // Array to hold the search results
    private var results: [Gif]?
    
    private var lastSearch: String = "Trending"
    func countOfGifsResult() -> Int{
        guard let gifs = results else{
            return 0
        }
        return gifs.count
        
    }
    
    func havingGifsResult() -> Bool{
        return false
    }
    func sizeOfCell(_ parentWidget: CGFloat) -> CGSize{
        let width = (parentWidget-40)/3
        return CGSize(width: width, height: width)
    }
    
    func SearchAction(_ textField: UITextField) -> Bool{
        if textField.text != "" {
            callApi(textField.text)
        }
        return textField.resignFirstResponder()
    }
    
    func callApi(_ searchedText: String?){
        checkInternet(completion: {[weak self] success in
            if success{
                self?.fetchingData(searchedText)
            }
        })
    }
    
    private func clearResult(_ searchedText: String?){
        
        if searchedText != lastSearch{
            self.results = []
        }
    }
    
    private func updateSearchedText(_ searchedText: String?){
        if let searchedText = searchedText{
            lastSearch = searchedText
        }else{
            lastSearch = "Trending"
        }
        
    }
    
    private func fetchingData(_ searchedText: String?, _ limit: Int = 30, _ offset: Int = 0){
        isLoading.value = true
        
        
        clearResult(searchedText)
        updateSearchedText(searchedText)
        
        HomeViewModel.shared.getSearchedGifs(searchedText, completion: {[weak self] success, results  in
            
            
            if success{
                self?.isLoaded.value = success
                self?.isLoading.value = false
                self?.results?.append(contentsOf: results!)
                
            }else{
                self?.error.value = true
                self?.isLoading.value = false
            }
        })
    }
    
    private func checkInternet(completion: @escaping(Bool)->Void){
        HomeViewModel.shared.checkConnectivity(completion: {[weak self] havingInternet in
            if havingInternet{
                completion(true)
            }else{
                self?.error.value = true
            }
        })
    }
    
    private func getPreviewGifPath(_ indexPath: IndexPath) -> String{
        guard let gifs = results else{
            return ""
        }
        guard let path = gifs[indexPath.row].placeHolder else { return "" }
        return path
    }
    
    private func getOriginalGifPath(_ indexPath: IndexPath) -> String{
        guard let gifs = results else{
            return ""
        }
        guard let path = gifs[indexPath.row].original else { return "" }
        return path
    }
    
    func viewModelOfGif(_ indexPath: IndexPath) -> GIFViewModel{
        let path = getPreviewGifPath(indexPath)
        return GIFViewModel(path: path)
    }
    
    //MARK: testing purpose for mine
    func copyToClipboard(_ indexPath: IndexPath) {
        let path = getOriginalGifPath(indexPath)
        UIView.shared.copyToClipboard(path)
    }
    
    func showingErrorToast(){
        DispatchQueue.main.async {
            UIView.shared.showingToast("Error")
        }
        
    }
    func getCell(_ collectionView: UICollectionView, _ indexPath: IndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GIFCollectionViewCell
        cell.gifViewModel = viewModelOfGif(indexPath)
        cell.setupBinders()
        return cell
    }
    
    func isThisLastCell(indexPath: IndexPath) -> Bool{
        if indexPath.row == countOfGifsResult()-1{
            return true
        }else{
            return false
        }
    }
    func searchForNextOffset(){
        HomeViewModel.shared.goToNextPage()
        fetchingData(lastSearch)
    }
}
