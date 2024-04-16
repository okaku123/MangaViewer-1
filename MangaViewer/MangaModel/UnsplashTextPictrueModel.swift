//
//  UnsplashTextPictrueModel.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/5/31.
//

import Foundation
import Alamofire

class UnsplashTextPictrueModel {
    
    var callback : ([String])->()
    init(_ callback:  @escaping ([String])->()) {
        self.callback = callback
        loadData()
    }
    
    func loadData() {
        let key = "giOJHDt4_OaivQHyBg6X_TpQ_mLXGWCpq2p9AlpKkNU"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        AF.request(url).responseDecodable(of : [Picture].self ){  response in
            print(url)
            guard let array = try? response.result.get() else {
                print("UnsplashTextPictrueModel loadData() Error :\(response.error)")
                return
            }
            let result = array.map{
                $0.urls.small
            }
            self.callback(result)
        }
    }
    
   
    
}
