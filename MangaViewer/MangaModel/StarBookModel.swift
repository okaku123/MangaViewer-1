//
//  StartBookModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/6/24.
//

import Foundation
import FileKit

class StarBookModel : ObservableObject{
    
    @Published var bookList = [Book]()
    
    
    init() {
        ReadFile()
    }
  
    func ReadFile() {
        let lastRead  : Path = Path.userDocuments + "StarBook.json"
        if !lastRead.exists {
           try? lastRead.createFile()
            let tmpData = [Book]()
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(tmpData)
            let file = DataFile(path: lastRead)
            if let data = jsonData {
                try? file.write(data)
            }
        }
        
        let file = DataFile(path: lastRead)
        if let data = try? file.read() {
            let jsonDecoder =  JSONDecoder()
            let lastReadList = try? jsonDecoder.decode([Book].self, from: data)
            self.bookList  = lastReadList ?? [Book]()
        }
       
    }
    
    func save(_ book : Book) {
        bookList.append(book)
        OperationQueue.main.addOperation( BlockOperation(block: {
            let lastRead  : Path = Path.userDocuments + "StarBook.json"
            let file = DataFile(path: lastRead)
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(self.bookList)
            if let data = jsonData {
                try? file.write(data)
            }
        }) )
        
    }
    
    
}

