//
//  pictureViewModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import Alamofire

class collectionPictureViewModel: ObservableObject {
    
    @Published var photoArray: [PicModelObject] = []

    init() {
          loadDataForCollection()
    }

    func loadDataForCollection() {
        let key = "giOJHDt4_OaivQHyBg6X_TpQ_mLXGWCpq2p9AlpKkNU"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        AF.request(url).responseDecodable(of : [PicModelObject].self ){  response in
            switch response.result {
                case let .success(data):
                    self.photoArray.append(contentsOf: data)
                case let .failure(error):
                    // error
                    print(error.localizedDescription)
                }
        }
    }
    
}
