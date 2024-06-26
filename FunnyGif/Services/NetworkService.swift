//
//  NetworkService.swift
//  FunnyGif
//
//

import Foundation
import UIKit

#warning("Here I implemented 2 API providers because I was getting some warning from gify, thats why I added 2nd one for testing purposes")

final class NetworkService{
    static var shared = NetworkService()
    private let providerType: ProviderType = .gify
    private lazy var basePath: String = providerType == .gify ? "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=2&offset=1&rating=G&lang=en&q=" : "https://g.tenor.com/v1/search?q="
    
//    private let searchText: String = "Trending"

//    private var currentOffset: Int = 0
//    private var limit: Int = 30
//    func goToNextPage(){
//        self.currentOffset += limit
//        
//    }
    
    private func getBasePathByOffset(_ searchText: String?, _ limit: Int = 30, _ offset: Int = 0) -> String{
        guard let text = searchText else{
            let path = "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=\(limit)&offset=\(offset)&rating=G&lang=en&q=" + "Trending"
            return path
        }
        let path = "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=\(limit)&offset=\(offset)&rating=G&lang=en&q=" + text
        return path
    }
    
    
//    private func getPath(_ searchText: String?) -> String{
//        if let text = searchText{
//            if providerType == .gify{
//                return basePath+text
//            }else{
//                return basePath+text+"&key=LIVDSRZULELA"
//            }
//            
//        }
//        else{
//            //Default path
//            if providerType == .gify{
//                return basePath+self.searchText
//            }else{
//                return basePath+self.searchText+"&key=LIVDSRZULELA"
//            }
//            
//        }
//    }
    
    //MARK: Respose for gify, tenor
    private func getResponse(_ searchFor: String?, _ limit: Int = 30, _ offset: Int = 0, completion: @escaping(_ success: Bool, [Gif]?)-> Void){
        guard let url = URL(string: getBasePathByOffset(searchFor, limit, offset)) else {
            return
        }
        
        let ulrRequest = URLRequest(url: url)
        let urlSession = URLSession.shared.dataTask(with: ulrRequest, completionHandler: { [weak self] data, response, error in
            
            if let _ = error{
                completion(false, nil)
            }else{
                if self?.providerType == .gify{
                    self?.parsingForGify(data: data, completion: {success, result in
                        completion(success, result)
                    })
                }else{
                    self?.parsingForTenor(data: data, completion: {success, result in
                        completion(success, result)
                    })
                }
            }

            
            
        })
        
        urlSession.resume()
    }
    
    //MARK: Gify Data fetch using JSONSerialization
    private func parsingForGify(data: Data?, completion: @escaping(_ success: Bool, [Gif]?)-> Void){
        if let data = data{
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Accessing the entire JSON dictionary
                    if let dataArray = json["data"] as? [[String: Any]] {
                        if dataArray.isEmpty{
                            completion(false, nil)
                        }else{
                            var gifs: [Gif] = []
                            for data in dataArray {
                                var gif = Gif()
                                if let id = data["id"] as? String{
                                    gif.id = id
                                }
                                if let url = data["url"] as? String{
                                    gif.url = url
                                }
                                if let image = data["images"] as? [String: Any]{
                                    if let original = image["original"] as? [String: Any]{
                                        if let url = original["url"] as? String{
                                            gif.original = url
                                        }
                                    }
                                    
                                    if let preview = image["preview_gif"] as? [String: Any]{
                                        if let url = preview["url"] as? String{
                                            gif.placeHolder = url
                                        }
                                    }
                                    
                                    
                                }
                                gifs.append(gif)
                            }
                            
                            completion(true, gifs)
                        }
                        
                        
                    }else {
                        //invalid data
                        completion(false, nil)
                    }
                } else {
                    //print("Invalid JSON format")
                    completion(false, nil)
                }
            } catch {
                //print("Error parsing JSON: \(error)")
                completion(false, nil)
            }
        }
    }
    
    //MARK: Tenor Data fetch using JSONSerialization
    private func parsingForTenor(data: Data?, completion: @escaping(_ success: Bool, [Gif]?)-> Void){
        if let data = data{
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Accessing the entire JSON dictionary
                    if let dataArray = json["results"] as? [[String: Any]] {
                        if dataArray.isEmpty{
                            completion(false, nil)
                        }else{
                            var gifs: [Gif] = []
                            for data in dataArray {
                                var gif = Gif()
                                if let id = data["id"] as? String{
                                    gif.id = id
                                }
                                if let url = data["url"] as? String{
                                    gif.url = url
                                }
                                if let medias = data["media"] as? [[String: Any]]{
                                    for media in medias{
                                        if let nanoGif = media["nanogif"] as? [String: Any]{
                                            if let previewUrl = nanoGif["url"] as? String{
                                                gif.placeHolder = previewUrl
                                            }
                                        }
                                        
                                        if let gifObjc = media["gif"] as? [String: Any]{
                                            if let originalUrl = gifObjc["url"] as? String{
                                                gif.original = originalUrl
                                            }
                                        }
                                    }
                                    
                                    
                                }
                                gifs.append(gif)
                            }
                            
                            completion(true, gifs)
                        }
                        
                        
                    }else {
                        //invalid data
                        completion(false, nil)
                    }
                } else {
                    //print("Invalid JSON format")
                    completion(false, nil)
                }
            } catch {
                //print("Error parsing JSON: \(error)")
                completion(false, nil)
            }
        }
    }
    
    //This func will be called by the VM
    func getSearchedGifs(_ searchFor: String?, _ limit: Int = 30, _ offset: Int = 0, completion: @escaping(_ success: Bool, [Gif]?)-> Void){
        getResponse(searchFor,limit, offset, completion: {success, result in
            completion(success, result)
        })
    }
    
    //This func will be called by the VM
//    func getGifResults()->[Gif]?{
//        return result
//    }
//    func clearResult(){
//        result = []
//    }
    
    //This function fetch the data from URL_path
    //Using for fetching gif file data
    //This func will be called by the VM
    func gettingDataOf(_ dataPath: String, completion: @escaping(Data?)->Void){
        if let url = URL(string: dataPath){
            URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
                if let _ = error{
                    completion(nil)
                }else{
                    if let data = data{
                        completion(data)
                    }else{
                        completion(nil)
                    }
                    
                }
            }).resume()
        }else{
            completion(nil)
        }
    }
    
    //This func is helping to detect internet connection
    func checkConnectivity(completion: @escaping (Bool) -> Void) {
            guard let url = URL(string: "https://www.apple.com") else {
                completion(false) // Invalid URL
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    // Error occurred, indicating no internet connection
                    completion(false)
                } else {
                    // No error, internet connection is available
                    completion(true)
                }
            }
            task.resume()
        }
     
}

//MARK: Provider Type
enum ProviderType{
    case gify
    case tenor
}
