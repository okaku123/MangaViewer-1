//
//  HttpZipFoundation.swift
//  MangaViewer
//
//  Created by okaku on 2024/3/30.
//

import Foundation
import Alamofire

class HttpZipFoundation {
    
    var entrys: [HttpZipEntry] = []
    var fileDatas: [Data] = []
    var url: URL! = nil
    var loadFinishCallBack : (( _ : String? )->())? = nil
    
    func getHttpFileLength(header: HTTPHeaders) -> Int?{
      if  let contentRange = header.dictionary["Content-Range"],
        let lengthStr = contentRange.split(separator: "/").last,
          let length = Int( lengthStr ) {
          return length
      }
        return nil
    }
    
    func load(_ url: URL, callBack: @escaping (_ : String?)->()){
        self.url = url
        self.loadFinishCallBack = callBack
        let headers: HTTPHeaders = ["Range": "bytes=0-1"]
        AF.request(url, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if let contentLength = self.getHttpFileLength( header: response.response!.headers ){
                    self.fetchFileEndPart( contentLength )
                }
            case .failure(let error):
                print("Error fetching data:", error)
            }
        }
    }
    
    func fetchFileEndPart( _ contentLenght: Int ){
        
        let reqByteCounts =  1000 * 3
        let startByte = contentLenght - reqByteCounts
        let headers: HTTPHeaders = ["Range": "bytes=\(startByte)-\(contentLenght)"]
        AF.request(self.url, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                let httpZipDirectory = self.scanForEndOfCentralDirectoryRecord(with: data,
                                                        contentLength: data.count)
                if httpZipDirectory.offset == 0 || httpZipDirectory.entries == 0 || httpZipDirectory.size == 0 {
                    
                    self.loadFinishCallBack?( "scanForEndOfCentralDirectoryRecord: ERROR" )
                    return
                }
                self.GetEntriesAsync( directoryData: httpZipDirectory
                ){ list in
                    self.entrys = list
                    self.loadFinishCallBack?(nil)
                }
            case .failure(let error):
                print("Error fetching data:", error)
            }
        }
    }
    
    struct HttpZipDirectory {
        var offset: UInt32 = 0
        var size: UInt32 = 0
        var entries: UInt16 = 0
    }

  func scanForEndOfCentralDirectoryRecord( with data: Data , contentLength: Int) ->  HttpZipDirectory{
        var httpZipDirectory = HttpZipDirectory()
        let secureMargin = 22
        let chunkSize = 256
        var tryCount = 1
        var rangeStart = contentLength - secureMargin
        let rangeFinish = contentLength
        
        while httpZipDirectory.offset == 0 && tryCount <= 4 {
            rangeStart -= chunkSize * tryCount
            if rangeStart <= 0 {
                return httpZipDirectory
            }
            let subData =  data.subdata(in: rangeStart..<rangeFinish)
            var pos = subData.count - secureMargin
            while pos >= 0 {
                if subData[ pos + 0] == 0x50,
                   subData[ pos + 1] == 0x4b,
                   subData[ pos + 2] == 0x05,
                   subData[ pos + 3] == 0x06{
                    httpZipDirectory.size =  subData.subdata(in: (pos + 12) ..< ( pos + 12 + MemoryLayout<UInt32>.size)).toUInt32LE()
                    httpZipDirectory.offset =  subData.subdata(in: (pos + 16) ..< ( pos + 16 + MemoryLayout<UInt32>.size)).toUInt32LE()
                    httpZipDirectory.entries =  subData.subdata(in: (pos + 10) ..< ( pos + 10 + MemoryLayout<UInt16>.size)).toUInt16LE()
                    print( httpZipDirectory )
                    return httpZipDirectory
                }
                pos -= 1
            }
            tryCount += 1
        }
        return httpZipDirectory
    }
    
    func GetEntriesAsync(
                          directoryData: HttpZipDirectory,
                          callBack: @escaping (_ list: [HttpZipEntry] )->()){
        
        let UInt16Count = MemoryLayout<UInt16>.size
        let UInt32Count = MemoryLayout<UInt32>.size
        
        func GetEntries(_ data: Data){
            var entryList: [HttpZipEntry] = []
            var entriesOffset = 0
            var entryIndex = 0
                while entryIndex < directoryData.entries {
                    var entry = HttpZipEntry(index: entryIndex)
                    entry.compressionMethod = data.subdata(in: entriesOffset + 10 ..< entriesOffset + 10 + UInt16Count ).toUInt16LE()
                    entry.fileNameLength = data.subdata(in:  entriesOffset + 28 ..<  entriesOffset + 28 + UInt16Count ).toUInt16LE()
                    entry.extraFieldLength = data.subdata(in: entriesOffset + 30 ..< entriesOffset + 30 + UInt16Count).toUInt16LE()
                    entry.fileCommentLength = data.subdata(in:  entriesOffset + 32 ..< entriesOffset + 32 + UInt16Count).toUInt16LE()
                    entry.compressedSize = data.subdata(in:  entriesOffset + 20 ..< entriesOffset + 20 + UInt32Count ).toUInt32LE()
                    entry.uncompressedSize = data.subdata(in:  entriesOffset +  24 ..<  entriesOffset +  24 + UInt32Count ).toUInt32LE()
                    entry.fileOffset = data.subdata(in: entriesOffset + 42 ..< entriesOffset + 42 + UInt32Count).toUInt32LE()
//                    print( entry.fileOffset )
                    var fileNameStart = entriesOffset + 46
                    var fileNameBuffe = data.subdata(in: entriesOffset + 46 ..< entriesOffset + 46 + Int( entry.fileNameLength ) )
                    let fileName = String(data: fileNameBuffe, encoding: .utf8)
                    entry.fileName = fileName ?? ""
                    entry.extraFieldStart = fileNameStart + Int(entry.fileNameLength)
                    entry.fileCommentStart = entry.extraFieldStart + Int( entry.extraFieldLength )
                    entryList.append( entry )
                    entriesOffset = entry.fileCommentStart + Int( entry.fileCommentLength )
                    entryIndex += 1
                }
            callBack(entryList)
            
        }
         
            var startByte = directoryData.offset;
            var endByte = directoryData.offset + directoryData.size;
        
            let headers: HTTPHeaders = ["Range": "bytes=\(startByte)-\(endByte)"]
 
            AF.request( self.url, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    print("Fetched data:", data)
                    GetEntries(data)
                case .failure(let error):
                    print("Error fetching data:", error)
                }
            }
    }
    
    
}

class HttpZipEntry {
    var index: Int
    var isDirectory: Bool
    public var compressionMethod: UInt16 = 0
    private var _fileName: String = ""
    
    
    public var fileNameLength: UInt16 = 0
    public var extraFieldLength: UInt16 = 0
    public var fileCommentLength: UInt16 = 0
    public var compressedSize: UInt32 = 0
    public var uncompressedSize: UInt32 = 0
    public var fileOffset: UInt32 = 0
    public var extraFieldStart: Int = 0
    public var fileCommentStart: Int = 0
//    var fileNameStart = entriesOffset + 46;


    init(index: Int) {
        self.index = index
        self.isDirectory = false
    }

    var fileName: String {
        get {
            return _fileName
        }
        set {
            _fileName = newValue

            if newValue.last == "/" {
                isDirectory = true
            } else {
                isDirectory = false
            }
        }
    }
}

class HttpClient {
    var url: URL
    var start: Int
    var end: Int

    init(url: URL) {
        self.url = url
        self.start = -1
        self.end = -1
    }

    func getAsync() -> URLSessionDataTask {
        let url = self.url
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Accept")

        if start != -1 && end != -1 {
            request.setValue("bytes=\(start)-\(end)", forHTTPHeaderField: "Range")
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                }
                if let data = data {
                    // Handle the received data
                    // You can resolve a promise here if needed
                }
            }
        }
        task.resume()
        return task
    }
}

class HttpZipDirectory {
    var offset: Int
    var size: Int
    var entries: [HttpZipEntry]

    init() {
        self.offset = 0
        self.size = 0
        self.entries = []
    }
}

