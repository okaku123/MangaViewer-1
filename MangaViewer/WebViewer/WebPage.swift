import SwiftUI
import NukeUI
import FileKit
import Alamofire

//MARK: 页面 -
struct WebPage: View {
    
    var bookName: String
    var zipEntry: HttpZipEntry
    @State var url: URL? = nil
    
    func fetchCache(){
        var path = Path.userDocuments
        let bookName = bookName.replacingOccurrences(of: ".zip", with: "")
        path += "\(bookName)/\(zipEntry.fileName)"
        print(path.url.absoluteString)
        if !path.exists{
            //fetch
            downloadCover()
        }else{
            self.url = path.url
        }
    }
    
    func decompress(_ data: Data)->Data? {
        do {
            let uncompressedData = try ( data as NSData).decompressed(using: .zlib)
            let output = ( uncompressedData as Data )
            return output
        } catch {
            print ("Decompression error: \(error)")
            return nil
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
        
        var fileHeaderLength = 30 + Int(zipEntry.fileNameLength) + Int(zipEntry.extraFieldLength)
        
        var rangeStart = Int(zipEntry.fileOffset) + fileHeaderLength + 4
        var rangeFinish = rangeStart + Int(zipEntry.compressedSize);
        
        print("\(rangeStart)-\(rangeFinish)")
        
        let encodedString = bookName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "http://150.230.198.185:3001/FileManager/download?path=/root/Downloads/\(encodedString!)"
        
        let headers: HTTPHeaders = ["Range": "bytes=\(rangeStart)-\(rangeFinish)"]
        
        AF.request( url, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                if zipEntry.compressionMethod == 8 {
                    if let decompressData =  self.decompress( data) {
                        if let img = UIImage(data: decompressData){
                            
                            let f = Float(1080)
                            var width =  Float( img.cgImage!.width )
                            if width > f {
                                width = f
                            }
                            let height = width * 1.3
                            
                            let resize = CGSize(width: Int(width), height: Int(height) )
                            let resizeImg = resizeImage(image: img, targetSize: resize)
                            if let imgData = convertImageToJPEG(image: resizeImg, quality: 0.9){
                                var path = Path.userDocuments
                                let bookName = bookName.replacingOccurrences(of: ".zip", with: "")
                                
                                var fileName = zipEntry.fileName
                                if zipEntry.fileName.contains("/") {
                                    fileName = String( zipEntry.fileName.split(separator: "/").last! )
                                }
                                let endPos = fileName.lastIndex(of: ".")!
                                fileName = String( fileName[..<endPos] )
                                fileName += ".jpg"
                                path += "\(bookName)/\(fileName)"
                                print(path.url.absoluteString)
                                try? imgData |> DataFile(path: path)
                                self.url = path.url
                            }
                        }
                    }
                }else{
                    if let img = UIImage(data: data){
                        
                        let f = Float(1080)
                        var width =  Float( img.cgImage!.width )
                        if width > f {
                            width = f
                        }
                        let height = width * 1.3
                        
                        let resize = CGSize(width: Int(width), height: Int(height) )
                        let resizeImg = resizeImage(image: img, targetSize: resize)
                        if let imgData = convertImageToJPEG(image: resizeImg, quality: 0.9){
                            var path = Path.userDocuments
                            let bookName = bookName.replacingOccurrences(of: ".zip", with: "")
                            
                            var fileName = zipEntry.fileName
                            if zipEntry.fileName.contains("/") {
                                fileName = String( zipEntry.fileName.split(separator: "/").last! )
                            }
                            let endPos = fileName.lastIndex(of: ".")!
                            fileName = String( fileName[..<endPos] )
                            fileName += ".jpg"
                            path += "\(bookName)/\(fileName)"
                            
                            try? imgData |> DataFile(path: path)
                            self.url = path.url
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching data:", error)
            }
        }
    }
    
    var body: some View {
        VStack{
            if let _url = url {
                LazyImage(source: _url  ) { state in
                    if let image = state.image {
                        image
                            .resizingMode(.aspectFit)
                    } else if state.error != nil {
                        Text("error")
                            .foregroundColor(.white)
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .foregroundColor(Color.white)
                            .scaleEffect(2)
                    }
                }
            }else{
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .foregroundColor(Color.white)
                    .scaleEffect(2)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .onAppear{
            if url == nil {
                self.fetchCache()
            }
        }
    }
}
