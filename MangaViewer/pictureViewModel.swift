//
//  pictureViewModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import Alamofire

class pictureViewModel: ObservableObject {
//    @Published var photoArray: [Picture] = []
    @Published var photoMap : [[Picture]] = []

    init() {
        loadData()
    }
    
    func loadData() {
        let key = "giOJHDt4_OaivQHyBg6X_TpQ_mLXGWCpq2p9AlpKkNU"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        print(url)
        AF.request(url).responseDecodable(of : [Picture].self ){  response in
            switch response.result {
                case let .success(data):
//                    self.photoArray.append(contentsOf: data)
            
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
                    self.photoMap.append(data)
            
                case let .failure(error):
                    // error
                    print(error.localizedDescription)
                }
        }
    }
    
   
    
}
