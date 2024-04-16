//
//  pictureViewModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import Alamofire

class PageSizeModel  {
    var count : Int = 0
    var callback : (_ :Int)->()
    init( name : String , _ callback : @escaping (_ : Int)->()) {
        print(name)
        self.callback = callback
        getPage(name:name)
    }
    func getPage(name : String) {
        let url = "\(serverUrl)/PageSize?name=\(name.urlEncoded())"
        print(url)
        AF.request(url).responseString{ response in
            
            print(response)
            
            switch response.result {
            case let .success(data):
                self.count = Int(data) ?? 0
                self.callback(self.count)
                break
            case let .failure(error):
                print(error)
                
            }
        }
    }
}
