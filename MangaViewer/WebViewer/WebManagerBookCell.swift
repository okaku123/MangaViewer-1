import SwiftUI
import Alamofire
import NukeUI
import Nuke
import FileKit
import Compression

public typealias CRC32 = UInt32

enum CompressionError: Error {
    case invalidStream
    case corruptedData
}

enum LoadStatue {
    case idle
    case loading
    case error
    case success
}

struct WebManagerBookCell: View {
    
    var bookName : String
    var geoProxy : GeometryProxy
    var tag : String
    @Binding var selection: String?
    var selectedID : String
    @State var zipEntryList: [HttpZipEntry] = []
    @State var image: UIImage? = nil
    @State var loadStatue: LoadStatue = .idle
    
    func loadCover(){
        let encodedString = bookName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "http://150.230.198.185:3001/FileManager/download?path=/root/Downloads/\(encodedString!)"
        let zip = HttpZipFoundation()
        if let reqUrl = URL(string: url){
            zip.load(reqUrl){ error in
                if error != nil {
                    print(error)
                    return
                }
                let entrys = zip.entrys.filter { entry -> Bool in
                    return entry.fileName != ""
                }
                var filtedEntrys = entrys.filter{ entry -> Bool in
                    return !entry.fileName.contains("__MACOSX")
                }
                filtedEntrys =  filtedEntrys.filter{ entry -> Bool in
                    return !entry.fileName.contains("DS_Store")
                }
                
                filtedEntrys = filtedEntrys.filter{ entry -> Bool in
                    return entry.fileName.contains(".jpg") ||
                    entry.fileName.contains(".jpeg") ||
                    entry.fileName.contains(".JPG") ||
                    entry.fileName.contains(".png") ||
                    entry.fileName.contains(".PNG")
                }
                
                var sortedEntrys = filtedEntrys.sorted { (entry1, entry2) -> Bool in
                    return entry1.fileName.localizedStandardCompare(entry2.fileName) == .orderedAscending
                }
                
                self.zipEntryList = sortedEntrys
                
                if self.zipEntryList.count > 0 {
                    downloadCover()
                }else{
                    loadStatue = .error
                }
            }
        }
    }
    
    func getZipEntryList(){
        let encodedString = bookName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "http://150.230.198.185:3001/FileManager/download?path=/root/Downloads/\(encodedString!)"
        let zip = HttpZipFoundation()
        if let reqUrl = URL(string: url){
            zip.load(reqUrl){ error in
                if error != nil {
                    print(error)
                    return
                }
                let entrys = zip.entrys.filter { entry -> Bool in
                    return entry.fileName != ""
                }
                var filtedEntrys = entrys.filter{ entry -> Bool in
                    return !entry.fileName.contains("__MACOSX")
                }
                filtedEntrys =  filtedEntrys.filter{ entry -> Bool in
                    return !entry.fileName.contains("DS_Store")
                }
                
                filtedEntrys = filtedEntrys.filter{ entry -> Bool in
                    return entry.fileName.contains(".jpg") ||
                    entry.fileName.contains(".jpeg") ||
                    entry.fileName.contains(".JPG") ||
                    entry.fileName.contains(".png") ||
                    entry.fileName.contains(".PNG")
                }
                
                var sortedEntrys = filtedEntrys.sorted { (entry1, entry2) -> Bool in
                    return entry1.fileName.localizedStandardCompare(entry2.fileName) == .orderedAscending
                }
                
                self.zipEntryList = sortedEntrys
            }
        }
    }
    
    
    func decompress(_ data: Data, size: Int64)->Data? {
        do {
            let uncompressedData = try ( data as NSData).decompressed(using: .zlib)
            let output = ( uncompressedData as Data )
            return output
        } catch {
            print ("Decompression error: \(error)")
            return nil
        }
    }
    
    func createCach(){
        loadStatue = .loading
        var path = Path.userDocuments
        let bookName = bookName.replacingOccurrences(of: ".zip", with: "")
        path += "\(bookName)/"
        if !path.exists{
            try? path.createDirectory()
        }
        path += "cover.jpg"
        
        if !path.exists{
            //fetch online zip
            loadCover()
        }else{
            getZipEntryList()
            self.image = UIImage(url: path.url )
            loadStatue = .success
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let newImage = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return newImage
    }
    
    func convertImageToJPEG(image: UIImage, quality: CGFloat) -> Data? {
        return image.jpegData(compressionQuality: quality)
    }
    
    func downloadCover(){
        let entry = zipEntryList[0]
        var fileHeaderLength = 30 + Int(entry.fileNameLength) + Int(entry.extraFieldLength)
        var rangeStart = Int(entry.fileOffset) + fileHeaderLength + 4
        var rangeFinish = rangeStart + Int(entry.compressedSize);
        print("\(rangeStart)-\(rangeFinish)")
        let encodedString = bookName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "http://150.230.198.185:3001/FileManager/download?path=/root/Downloads/\(encodedString!)"
        let headers: HTTPHeaders = ["Range": "bytes=\(rangeStart)-\(rangeFinish)"]
        
        AF.request( url, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print("Fetched data:", data)
                if entry.compressionMethod == 8 {
                    if let decompressData =  self.decompress( data, size: Int64(entry.compressedSize)) {
                        if let img = UIImage(data: decompressData){
                            let resize = CGSize(width: 100, height: 100 * 1.3)
                            let resizeImg = resizeImage(image: img, targetSize: resize)
                            self.image = resizeImg
                            self.loadStatue = .success
                            if let imgData = convertImageToJPEG(image: resizeImg, quality: 0.9){
                                var path = Path.userDocuments
                                let bookName = bookName.replacingOccurrences(of: ".zip", with: "")
                                path += "\(bookName)/cover.jpg"
                                try? imgData |> DataFile(path: path)
                            }
                        }
                    }
                }else{
                    if let img = UIImage(data: data){
                        let resize = CGSize(width: 100, height: 100 * 1.3)
                        let resizeImg = resizeImage(image: img, targetSize: resize)
                        self.image = resizeImg
                        self.loadStatue = .success
                        if let imgData = convertImageToJPEG(image: resizeImg, quality: 0.9){
                            var path = Path.userDocuments
                            let bookName = bookName.replacingOccurrences(of: ".zip", with: "")
                            path += "\(bookName)/cover.jpg"
                            try? imgData |> DataFile(path: path)
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching data:", error)
                self.loadStatue = .error
            }
        }
    }
    
    var body: some View {
        return ZStack{
            let count : CGFloat = isIpad ? 5 : 3
            let space = count + 1
            let beforeWidth : CGFloat =  ( geoProxy.size.width - 20 * space ) / count
            let beforeHeight : CGFloat =  ( geoProxy.size.width - 20 * space ) / count * 1.3
            let isHighLight = ( tag == selectedID )
            
            NavigationLink( destination:
                                WebManagerDetailsView(bookName: self.bookName, zipEntryList: $zipEntryList),
                            tag: tag ,
                            selection : $selection ){
                VStack{
                    ZStack{
                        if image == nil {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(Color(UIColor( hexString: "#111827" )))
                                .frame(width: beforeWidth , height: beforeHeight )
                        }
                        
                        if loadStatue == .loading {
                            ProgressView()
                                .frame(width: 28, height: 28)
                        }
                        if loadStatue == .error {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color(UIColor( hexString: "#fafafa" )))
                                .frame(width: 28, height: 28)
                        }
                        if image != nil {
                            Image(uiImage: image!)
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fill)
                                .transition(.fade(duration: 0.33))
                                .frame(width: beforeWidth , height: beforeHeight )
                                .background(Color.gray)
                                .cornerRadius(4)
                                .clipped()
                                .onTapGesture {
                                    Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                                        DispatchQueue.main.async {
                                            self.selection = tag
                                        }
                                    }
                                }
                        }
                        
                    }
                    
                    if isHighLight {
                        Text( bookName)
                            .font(.system(size: 14))
                            .foregroundColor(Color.black)
                            .background(Color.yellow)
                            .cornerRadius(4)
                            .clipped()
                            .padding(3)
                    }else{
                        Text( bookName )
                            .font(.system(size: 14))
                    }
                }
                .onAppear{
                    if image == nil {
                        createCach()
                    }
                }
            }
                            .buttonStyle(PlainButtonStyle())
        }
    }
}

private extension compression_stream {
    
    mutating func prepare(for sourceData: Data?) -> Int {
        guard let sourceData = sourceData else { return 0 }
        
        self.src_size = sourceData.count
        return sourceData.count
    }
}


