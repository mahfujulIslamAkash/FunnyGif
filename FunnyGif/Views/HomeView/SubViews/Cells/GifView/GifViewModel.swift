//
//  GifViewModel.swift
//  FunnyGif
//
//  Created by Appnap Mahfuj on 28/3/24.
//

import Foundation
import UIKit

final class GifViewModel{
    var path: String?
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
    
    private func gettingGifDataOf(_ gifDataUrl: URL?, completion: @escaping(Data?, Bool)->Void){
        if let url = gifDataUrl{
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
        
        
    }
    
    private func gettingImageFromUrl(_ gifDataUrl: URL, completion: @escaping(UIImage?, Bool)->Void){
        gettingGifDataOf(gifDataUrl, completion: {data, success in
            if let data = data{
                if let image = UIImage.gifImageWithData(data){
                    //success here
                    completion(image, true)
                }else{
                    completion(nil, false)
                }
            }else{
                completion(nil, false)
            }
        })
    }
    
    func gettingImageFromPath(completion: @escaping(UIImage?, Bool)->Void){
        gettingGifDataOf(completion: {data, success in
            if let data = data{
                if let image = UIImage.gifImageWithData(data){
                    completion(image, true)
                }else{
                    completion(nil, false)
                }
            }else{
                completion(nil, false)
            }
        })
    }
}
