//
//  Help.swift
//  MangaViewer
//
//  Created by okaku on 2024/2/11.
//

import Foundation
import SwiftUI
import Alamofire

struct Help : View {
    
    
    @AppStorage("KeystoreToken") var KeystoreToken = ""
    let gqlUrl = "http://150.230.198.185:3002/api/graphql"
    
    func testFetch(){
        // 定义请求参数
        let rootEmail = "yangxuzong@live.com"
        let rootPassword = "11111111"
        let query = """
mutation{
    authenticateUserWithPassword(email:"\(rootEmail)" , password:"\(rootPassword)"){
      ...on UserAuthenticationWithPasswordSuccess{
        sessionToken
      }
    }
  }
"""
        let parameters: [String: Any] = [
            "query": query,
            "variables": "{}"
        ]
        
        // 发起POST请求
        AF.request( gqlUrl, method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any]{
                    let data = json["data"] as? [String: Any]
                    let authenticateUserWithPassword = data?["authenticateUserWithPassword"] as? [String: Any]
                    let sessionToken = authenticateUserWithPassword?["sessionToken"] as? String
                    if sessionToken != nil {
                        KeystoreToken = sessionToken!
                    }
                }
            case .failure(let error):
                // 请求失败，处理错误
                print("Error: \(error)")
            }
        }
    }
    
    
    var body: some View{
        NavigationView{
            VStack{
                Button("登陆"){
                    testFetch()
                    
                }
                Spacer()
                
                Button("获取列表"){
                    GetBooksModel().getPage()
                    
                }
                Spacer()
                Button("获取页数"){
                    
                    
                }
                Spacer()
                Button("获取页面"){
                    
                    
                }
                
                
                
            }
            
        }
    }
}
