//
//  pictureViewModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import Alamofire

class MaxPageCount  {
    var count : Int = 0
    var callback : (_ :Int)->()
    init(_ callback : @escaping (_ : Int)->()) {
        self.callback = callback
        getPage()
    }
    func getPage() {
        let url = "\(serverUrl)/maxPageCount"
        AF.request(url).responseString{ response in
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
