//
//  pictureViewModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import Alamofire

class BookSelfModel : ObservableObject {
    @Published var bookMap = [[Book]]()
    var loadingPages = [Int]()
    init() {
        
    }
    
    func  setPage(_ count : Int){
        let empty = Book()
        for _ in 0 ..< count {
            self.bookMap.append( Array( repeating: empty , count: 30 ))
        }
    }
    
    func getPage( _ count : Int = 1) {
        
        if loadingPages.contains(count){
            return
        }
        
        if  bookMap.count < count , let f = bookMap[count].first , !f.name.isEmpty {
            return
        }
      
        print("start load \(count)...")
        loadingPages.append(count)
        
        let url = "\(serverUrl)/getBookByApp?page=\(count)&pageSize=30"
        AF.request(url).responseDecodable(of: [Book].self ){ response in
            
            switch response.result {
            case let .success(data):
                
                DispatchQueue.main.async {
                    print("load end \(data.count )")
                    self.bookMap[ count - 1 ] = []
                    self.bookMap[ count - 1 ] = data
                }

                break
            case let .failure(error):
                
                DispatchQueue.main.async {
                    if self.loadingPages.contains(count) ,
                       let index = self.loadingPages.firstIndex(of: count){
                        self.loadingPages.remove(at: index)
                    }
                }
                
               
                
                print(error)
            }
        }
    }
}

struct Book :  Decodable  , Encodable {
    var name : String = ""
    var cover : String = ""
    var group : [String] = []
    
    
    enum CodingKeys: String, CodingKey {
          case name, group
      }
    
    func getCoverUrl() -> String {
        return "\(serverUrl)/getCover/\(name.replacingOccurrences(of: ".zip", with: ".jpg").urlEncoded() )"
    }
    
}
