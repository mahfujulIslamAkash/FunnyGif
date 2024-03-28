//
//  NetworkService.swift
//  FunnyGif
//
//  Created by Appnap Mahfuj on 27/3/24.
//

import Foundation
import UIKit

final class NetworkService{
    static var shared = NetworkService()
    private let baseUrl: String = "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=25&offset=0&rating=G&lang=en&q="
    private let searchText: String = "Trending"
    private var result: [Gif]?
    
    
    private func getUrl(_ searchText: String?) -> String{
        if let text = searchText{
            return baseUrl+text
        }
        else{
            return baseUrl+self.searchText
        }
        
    }
    private func getResponse(_ searchFor: String?, completion: @escaping(_ success: Bool)-> Void){
        guard let url = URL(string: getUrl(searchFor)) else{
            return
        }
        let ulrRequest = URLRequest(url: url)
        let urlSession = URLSession.shared.dataTask(with: ulrRequest, completionHandler: { [weak self] data, response, error in
            
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Accessing the entire JSON dictionary
                    if let dataArray = json["data"] as? [[String: Any]] {
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
                        self?.result = gifs
                        completion(true)
                        
                    }
                } else {
                    print("Invalid JSON format")
                    completion(false)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(false)
            }
        })
        
        urlSession.resume()
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
                if let error = error{
                    print(error)
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
            if let error = error{
                print(error)
            }else{
                if let data = data{
                    completion(data)
                }else{
                    completion(nil)
                }
                
            }
        }).resume()
    }
}
