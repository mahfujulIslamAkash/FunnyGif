//
//  HomeViewModel.swift
//  FunnyGif
//
//  Created by Appnap Mahfuj on 27/3/24.
//

import Foundation
import UIKit

class HomeViewModel{
    
    init(){
        
    }
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    func countOfGifsResult() -> Int{
        guard let gifs = NetworkService.shared.getGifResults() else{
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
    
//    func callApi(_ searchedText: String?){
//        isLoading.value = true
//        NetworkService.shared.getTrendingGifs(completion: {[weak self] success in
//            if success{
//                self?.isLoaded.value = success
//                self?.isLoading.value = false
//            }else{
//                self?.error.value = true
//                self?.isLoading.value = false
//            }
//            
//            
//        })
//    }
    
    func callApi(_ searchedText: String?){
        checkInternet(completion: {[weak self] success in
            if success{
                self?.fetchingData(searchedText)
            }
        })
    }
    
    private func fetchingData(_ searchedText: String?){
        isLoading.value = true
        NetworkService.shared.getSearchedGifs(searchedText, completion: {[weak self] success in
            if success{
                self?.isLoaded.value = success
                self?.isLoading.value = false
            }else{
                self?.error.value = true
                self?.isLoading.value = false
            }
        })
    }
    
    private func checkInternet(completion: @escaping(Bool)->Void){
        NetworkService.checkConnectivity(completion: {[weak self] havingInternet in
            if havingInternet{
                completion(true)
            }else{
                self?.error.value = true
            }
        })
    }
    
    private func getPreviewGifPath(_ indexPath: IndexPath) -> String{
        guard let gifs = NetworkService.shared.getGifResults() else{
            return ""
        }
        guard let path = gifs[indexPath.row].placeHolder else { return "" }
        return path
    }
    
    private func getOriginalGifPath(_ indexPath: IndexPath) -> String{
        guard let gifs = NetworkService.shared.getGifResults() else{
            return ""
        }
        guard let path = gifs[indexPath.row].original else { return "" }
        return path
    }
    
    func viewModelOfGif(_ indexPath: IndexPath) -> GifViewModel{
        let path = getPreviewGifPath(indexPath)
        return GifViewModel(path: path)
    }
    
    func copyToClipboard(_ indexPath: IndexPath) {
        let path = getOriginalGifPath(indexPath)
        UIView.shared.copyToClipboard(path)
    }
    
    func showingErrorToast(){
        DispatchQueue.main.async {
            UIView.shared.showingToast("Error")
        }
        
    }
}
