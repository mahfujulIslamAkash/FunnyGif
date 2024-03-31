//
//  GifViewModel.swift
//  FunnyGif
//
//  Created by Appnap Mahfuj on 28/3/24.
//

import Foundation
import UIKit

final class GifViewModel{
    var isLoaded: ObservableObject<Bool> = ObservableObject(false)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    private var image: UIImage?
    private var path: String?
    init(path: String? = nil) {
        self.path = path
    }
    
    private func gettingGifDataOf(completion: @escaping(Data?, Bool)->Void){
        if let path = path{
            if let url = URL(string: path){
                NetworkService.shared.gettingDataOf(url, completion: {data in
                    if let data = data{
                        //success here
                        completion(data, true)
                    }else{
                        completion(nil, false)
                    }
                })
            }else{
                completion(nil, false)
            }
        }else{
            completion(nil, false)
        }
        
    }
    
//    private func gettingGifDataOf(_ gifDataUrl: URL?, completion: @escaping(Data?, Bool)->Void){
//        if let url = gifDataUrl{
//            NetworkService.shared.gettingDataOf(url, completion: {data in
//                if let data = data{
//                    //success here
//                    completion(data, true)
//                }else{
//                    completion(nil, false)
//                }
//            })
//        }else{
//            completion(nil, false)
//        }
//        
//        
//    }
    
//    private func gettingImageFromUrl(_ gifDataUrl: URL, completion: @escaping(UIImage?, Bool)->Void){
//        gettingGifDataOf(gifDataUrl, completion: {data, success in
//            if let data = data{
//                if let image = UIImage.gifImageWithData(data){
//                    //success here
//                    completion(image, true)
//                }else{
//                    completion(nil, false)
//                }
//            }else{
//                completion(nil, false)
//            }
//        })
//    }
    
    private func gettingImageFromPath(completion: @escaping(Bool)->Void){
        gettingGifDataOf(completion: {[weak self] data, success in
            if let data = data{
                if let image = UIImage.gifImageWithData(data){
                    self?.isLoaded.value = true
                    self?.image = image
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                completion(false)
            }
        })
    }
    
    func fetchGifImage(){
        isLoading.value = true
        gettingImageFromPath(completion: {[weak self] _ in
            self?.isLoading.value = false
        })
    }
    
    func getGifImage() -> UIImage?{
        if let image = self.image{
            return image
        }else{
            return nil
        }
    }
}