//
//  pictureViewModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/25.
//

import Foundation
import Alamofire
import SwiftUI

class GetBooksModel : ObservableObject {
    @Published var bookMap = [[KeyStoreBook]]()
    var loadingPages = [Int]()
    var booksCount: Int = 0
    let gqlUrl = "http://150.230.198.185:3002/api/graphql"
    @AppStorage("KeystoreToken") var KeystoreToken = ""
    var onedriveReqQueue: [String] = []
    var reqTimer: Timer? = nil
    
    init() {
        getBooksCount()
    }
    
    func getPage( _ count : Int = 1) {
        
        if loadingPages.contains(count){
            return
        }
        
        if loadingPages.contains(count){
            return
        }
        print("start getPage: \(count)")
        loadingPages.append(count)
        
        let skip = 20 * ( count - 1 )
        let pageNum = 20
        let query = """
{
  books(skip: \(skip), take: \(pageNum) ){
    id
    name
    pageCount
    path
    addBy
    type
    coverID
    __typename
  }
}
"""
        let parameters: [String: Any] = [
            "query": query,
            "variables": "{}"
        ]
        
        AF.request( gqlUrl, method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default)
        .responseDecodable(of: KeyStoreBookData.self ){ response in
            //              debugPrint(response)
            switch response.result {
            case let .success(data):
                DispatchQueue.main.async {
                    if let books = data.data?.books{
                        self.bookMap[count - 1] = books
                        self.getCoverFromFileGetBatch(of: count - 1)
                    }
                }
                break
            case let .failure(error):
                print(error)
            }
            
        }
        
    }
    
    /// 获取onedrive文件直链(链接有效时间短)
    /// - Parameter id: String
    func getCoverFromFileGetBatch(in id: String){
        var fileId = ""
        if id.contains("/img/avator/") {
            fileId =  id.replacingOccurrences(of: "/img/avator/", with: "")
        }
        if id.contains("/img/cover/") {
            fileId =  id.replacingOccurrences(of: "/img/cover/", with: "")
        }
        onedriveReqQueue.append(fileId)
        if ( onedriveReqQueue.count == 20 ){
            let _onedriveReqQueue: [String] = onedriveReqQueue
            self.onedriveReqQueue.removeAll()
            reqTimer?.invalidate()
            reqTimer = nil
            FileGetBatch(ids: _onedriveReqQueue )
            return
        }
        reqTimer?.invalidate()
        reqTimer = nil
        reqTimer = Timer(timeInterval: 1 , repeats: false ){_ in
            self.FileGetBatch(ids: self.onedriveReqQueue )
        }
    }
    
    /// 获取onedrive文件直链(链接有效时间短)
    /// - Parameter ids: [String]
    func FileGetBatch( ids: [String] ){
        let parameters: [String: Any] = [ "ids": ids]
        print("start FileGetBatch: ")
        print(ids.count)
        let url = "http://150.230.198.185:3001/OneDrive/FileGetBatch"
        AF.request( url,
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default)
        .responseDecodable(of: FileGetBatchResponse.self ){ response in
//            debugPrint(response)
            switch response.result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.handleFileGetBatch(items: data.playload )
                }
                break
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func handleFileGetBatch(items: [FileGetBatchResponseItem] ){
        for item in items {
            for i in 0...(bookMap.count - 1) {
                let bookRowCol = bookMap[i]
                var finded = false
                for j in 0...(bookRowCol.count - 1) {
                     let book = bookMap[i][j]
                    var fileId = ""
                    if book.coverID.contains("/img/avator/") {
                        fileId =  book.coverID.replacingOccurrences(of: "/img/avator/", with: "")
                    }
                    if book.coverID.contains("/img/cover/") {
                        fileId =  book.coverID.replacingOccurrences(of: "/img/cover/", with: "")
                    }
                    if fileId == item.id {
                        bookMap[i][j].coverUrl = item.url
                        finded = true
                        continue
                    }
                }
                if finded {
                    continue
                }
            }
        }
    }
    
    func getBooksCount() {
        let query = """
{
    booksCount
}
"""
        let parameters: [String: Any] = [
            "query": query,
            "variables": "{}"
        ]
        
        AF.request( gqlUrl, method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any]{
                    let data = json["data"] as? [String: Any]
                    if let booksCount = data?["booksCount"] as? Int {
                        self.booksCount = booksCount
                        let colNum = Int( booksCount / 20 )
                        let empty = KeyStoreBook()
                        self.bookMap.removeAll()
                        for _ in 0 ..< colNum {
                            self.bookMap.append( Array( repeating: empty , count: 20 ))
                        }
                    }
                }
            case .failure(let error):
                // 请求失败，处理错误
                print("Error: \(error)")
            }
        }
    }
    
    /// 一次性获取row的所有onedrive 地址
    /// - Parameter row: Int
    func getCoverFromFileGetBatch( of row: Int ){
        let bookList =  self.bookMap[row]
        let coverIds = bookList.map{ item in
            let id = item.coverID
            var fileId = ""
            if id.contains("/img/avator/") {
                fileId =  id.replacingOccurrences(of: "/img/avator/", with: "")
            }
            if id.contains("/img/cover/") {
                fileId =  id.replacingOccurrences(of: "/img/cover/", with: "")
            }
            return fileId
        }
        FileGetBatch(ids: coverIds )
    }
    
    
}

struct KeyStoreBook:  Decodable, Encodable {
    
    var id: String = ""
    var name : String = ""
    var pageCount : Int = 0
    var path: String = ""
    var addBy: String = ""
    var type: String = ""
    var coverID: String = ""
    var __typename: String = "Book"
    
    var coverUrl: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, name,pageCount,path,addBy,type,coverID,__typename
    }
    
    func getCoverUrl() -> String {
        return "\(serverUrl)/getCover/\(name.replacingOccurrences(of: ".zip", with: ".jpg").urlEncoded() )"
    }
    
}

struct KeyStoreBookData: Decodable, Encodable {
    var data: KeyStoreBooks? = nil
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct KeyStoreBooks: Decodable, Encodable {
    var books: [KeyStoreBook] = []
    enum CodingKeys: String, CodingKey {
        case books
    }
}


struct FileGetBatchResponse: Decodable, Encodable {
    var playload: [FileGetBatchResponseItem]
    enum CodingKeys: String, CodingKey {
        case playload
    }
}

struct FileGetBatchResponseItem : Decodable, Encodable {
    var id: String = ""
    var url: String = ""
    enum CodingKeys: String, CodingKey {
        case id,url
    }
}

