//
//  CropedModel.swift
//  MangaViewer
//
//  Created by bcat rea on 2021/9/16.
//


import Combine
import Foundation
import SwiftUI
import SDWebImageSwiftUI
import UIKit
import SwiftUIPager
import Alamofire

class CropedModel : ObservableObject  {
    @Published var imagesList = [MangaPageObject]()
    //开始裁剪AB页的offset ,避免封面是单张的情况
    @Published var CropPageOffset = 0
    @Published var isCrop = false
    @Published var pageIndexList = [Int]()
    
    
    func setPage(_ name : String , count : Int ){
        var tmpUrlList = [MangaPageObject ]()
        for i in 0 ..< count {
            
            if !isCrop {
                let url = "\(serverUrl)/getPage?name=\(name.urlEncoded())&index=\(i)"
                tmpUrlList.append( MangaPageObject(url: url) )
                continue
            }
            
            if i < CropPageOffset {
                let url = "\(serverUrl)/getPage?name=\(name.urlEncoded())&index=\(i)"
                tmpUrlList.append( MangaPageObject(url: url) )
            }else{
                let url = "\(serverUrl)/getPage?name=\(name.urlEncoded())&index=\(i)&crop=A"
                tmpUrlList.append( MangaPageObject(url: url) )
                let url1 = "\(serverUrl)/getPage?name=\(name.urlEncoded())&index=\(i)&crop=B"
                tmpUrlList.append( MangaPageObject(url: url1) )
            }
        }
        imagesList.append(contentsOf: tmpUrlList)
        
        print(imagesList.count)
        
        var tmpPageIndexList = [Int]()
        for  i in 0 ..< imagesList.count {
            tmpPageIndexList.append(i)
        }
        pageIndexList = tmpPageIndexList
  
    }
    
    func setOffset(_ count : Int){
        CropPageOffset = count
    }
   
}
