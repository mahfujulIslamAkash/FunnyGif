//
//  HomeViewModel.swift
//  FunnyGif
//
//  Created by Appnap Mahfuj on 27/3/24.
//

import Foundation

class HomeViewModel{
    
    init(){
        
    }
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    
    func getGifResults() -> [Gif]{
        return []
    }
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
    
    func callApi(){
        NetworkService.shared.getTrendingGifs(completion: {[weak self] success in
            self?.isLoaded.value = success
            
        })
    }
    func getPreviewUrl(_ indexPath: IndexPath) -> String{
        guard let gifs = NetworkService.shared.getGifResults() else{
            return ""
        }
        guard let url = gifs[indexPath.row].placeHolder else { return "" }
        return url
    }
}
