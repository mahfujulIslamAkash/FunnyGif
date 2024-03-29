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
    private let providerType: ProviderType = .tenor
    private lazy var baseUrl: String = providerType == .gify ? "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=25&offset=0&rating=G&lang=en&q=" : "https://g.tenor.com/v1/search?q="
    private let searchText: String = "Trending"
    private var result: [Gif]?
    
    
    private func getUrl(_ searchText: String?) -> String{
        if let text = searchText{
            if providerType == .gify{
                return baseUrl+text
            }else{
                return baseUrl+text+"&key=LIVDSRZULELA"
            }
            
        }
        else{
            if providerType == .gify{
                return baseUrl+self.searchText
            }else{
                return baseUrl+self.searchText+"&key=LIVDSRZULELA"
            }
            
        }
        
        
        
    }
    private func getResponse(_ searchFor: String?, completion: @escaping(_ success: Bool)-> Void){
        guard let url = URL(string: getUrl(searchFor)) else{
            return
        }
        let ulrRequest = URLRequest(url: url)
        let urlSession = URLSession.shared.dataTask(with: ulrRequest, completionHandler: { [weak self] data, response, error in
            
            if let error = error{
                completion(false)
            }else{
                if self?.providerType == .gify{
                    self?.parsingForGify(data: data, completion: {result in
                        completion(result)
                    })
                }else{
                    self?.parsingForTenor(data: data, completion: {result in
                        completion(result)
                    })
                }
            }

            
            
        })
        
        urlSession.resume()
    }
    
    private func parsingForGify(data: Data?, completion: @escaping(_ success: Bool)-> Void){
        if let data = data{
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Accessing the entire JSON dictionary
                    if let dataArray = json["data"] as? [[String: Any]] {
                        if dataArray.isEmpty{
                            completion(false)
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
                            result = gifs
                            completion(true)
                        }
                        
                        
                    }else {
                        // invalid data
                        completion(false)
                    }
                } else {
//                    print("Invalid JSON format")
                    completion(false)
                }
            } catch {
//                print("Error parsing JSON: \(error)")
                completion(false)
            }
        }
    }
    
    private func parsingForTenor(data: Data?, completion: @escaping(_ success: Bool)-> Void){
        if let data = data{
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Accessing the entire JSON dictionary
                    if let dataArray = json["results"] as? [[String: Any]] {
                        if dataArray.isEmpty{
                            completion(false)
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
                            result = gifs
                            completion(true)
                        }
                        
                        
                    }else {
                        // invalid data
                        completion(false)
                    }
                } else {
//                    print("Invalid JSON format")
                    completion(false)
                }
            } catch {
//                print("Error parsing JSON: \(error)")
                completion(false)
            }
        }
    }
    
    func getTrendingGifs(completion: @escaping(_ success: Bool)-> Void){
        getResponse(nil, completion: {success in
            completion(success)
        })
    }
    
    func getSearchedGifs(_ searchFor: String?, completion: @escaping(_ success: Bool)-> Void){
        getResponse(searchFor, completion: {success in
            completion(success)
        })
    }
    func getGifResults()->[Gif]?{
        return result
    }
    
    func gettingDataOf(_ dataPath: String, completion: @escaping(Data?)->Void){
        if let url = URL(string: dataPath){
            URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
                if let _ = error{
                    completion(nil)
//                    print(error)
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
    
    func gettingDataOf(_ dataUrl: URL, completion: @escaping(Data?)->Void){
        URLSession.shared.dataTask(with: dataUrl, completionHandler: {data, response, error in
            if let _ = error{
//                print(error)
                completion(nil)
            }else{
                if let data = data{
                    completion(data)
                }else{
                    completion(nil)
                }
                
            }
        }).resume()
    }
    
    static func checkConnectivity(completion: @escaping (Bool) -> Void) {
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

enum ProviderType{
    case gify
    case tenor
}
