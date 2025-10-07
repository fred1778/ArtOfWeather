//
//  ImageLoader.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import Foundation
import SwiftUI
import Combine


class ImageLoader : ObservableObject{
    
    @Published var artImage : Image = Image(systemName: "globe")
    
    func getImageForURL(url: String){
        
        guard let imgURL = URL(string: url) else {
            print("url error")
            return}
        
        URLSession.shared.dataTask(with: URLRequest(url: imgURL), completionHandler: { (data, response, error) -> Void in
            print("img sesh")
            if let error = error{
                print(error)
            }
            if let data = data{
                print("img fetch8")

                DispatchQueue.main.async {
                    print("img fetch")
                    
                    self.artImage = Image(uiImage: UIImage(data: data) ?? UIImage(imageLiteralResourceName: "default"))
                    
                }
            }
            
        })
        .resume()
    
        
    }
    
    
}
