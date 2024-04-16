//
//  LastReadModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/5/30.
//

import Foundation
import FileKit 

class LastReadModel : ObservableObject{
    
    @Published var lastReadSave = [LastRead]()
    
    init() {
        ReadFile()
    }
  
    func ReadFile() {
        let lastRead  : Path = Path.userDocuments + "LastRead.json"
        if !lastRead.exists {
           try? lastRead.createFile()
            let tmpData = [LastRead]()
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
            let lastReadList = try? jsonDecoder.decode([LastRead].self, from: data)
            self.lastReadSave = lastReadList ?? [LastRead]()
        }
    }
    
    func save(name : String , count : Int) {
        var ed = true
        for index  in lastReadSave.indices {
            if lastReadSave[index].name == name {
                if lastReadSave[index].count != 0 , count == 0 {
                 return
                }
                lastReadSave[index].count = count
                ed = false
                break
            }
        }
        if ed {
            let newSave = LastRead(name: name, count: count)
            lastReadSave.append(newSave)
        }
        
        let lastRead  : Path = Path.userDocuments + "LastRead.json"
        let file = DataFile(path: lastRead)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self.lastReadSave)
        if let data = jsonData {
            try? file.write(data)
        }
    }
    func find(_ name : String) -> Int {
        
        if self.lastReadSave.isEmpty {
            return -1
        }
        for item in self.lastReadSave {
            if item.name == name {
                return item.count
            }
        }
        return -1
    }
    
    
}

struct LastRead : Codable  {
    var name : String = ""
    var count : Int = 0
}
