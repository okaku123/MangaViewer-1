import SwiftUI
import Alamofire
import NukeUI
import Nuke

struct KeystoreManagerBookCell: View {
    
    var book : KeyStoreBook
    var geoProxy : GeometryProxy
    var tag : String
    @Binding var selection: String?
    var selectedID : String
    
    var body: some View {
        return ZStack{
            let count : CGFloat = isIpad ? 5 : 3
            let space = count + 1
            let beforeWidth : CGFloat =  ( geoProxy.size.width - 20 * space ) / count
            let beforeHeight : CGFloat =  ( geoProxy.size.width - 20 * space ) / count * 1.3
            let isHighLight = ( tag == selectedID )
            
            NavigationLink( destination:
                                KeystoreBookmanagerDetailsView(book: book ),
                            tag: tag ,
                            selection : $selection ){
                VStack{
                    if let coverUrl = book.coverUrl , let url = URL(string : coverUrl ) {
                        LazyImage(source: url )
                            .aspectRatio(contentMode: .fill)
                            .transition(.fade(duration: 0.33))
                            .frame(width: beforeWidth , height: beforeHeight )
                            .background(Color.gray)
                            .cornerRadius(4)
                            .clipped()
                            .onTapGesture {
                                //                                selectedID = navigationTag
                                Timer.scheduledTimer(withTimeInterval: 0.12, repeats: false){ _ in
                                    DispatchQueue.main.async {
                                        self.selection = tag
                                    }
                                }
                            }
                    }
                    
                    if book.coverUrl == nil {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(Color(UIColor( hexString: "#111827" )))
                            .frame(width: beforeWidth , height: beforeHeight )
                    }
                    
                    if isHighLight {
                        Text( book.name )
                            .font(.system(size: 14))
                            .foregroundColor(Color.black)
                            .background(Color.yellow)
                            .cornerRadius(4)
                            .clipped()
                            .padding(3)
                    }else{
                        Text( book.name )
                            .font(.system(size: 14))
                    }
                }
            }
        }
    }
}


