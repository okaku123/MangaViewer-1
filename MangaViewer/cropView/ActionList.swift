//
//  ActionList.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/9/14.
//

import SwiftUI

struct ActionList: View {
    
   @State var restaurants = [
           Restaurant(name: "arrow.right.circle"),
           Restaurant(name: "arrow.up.circle"),
            Restaurant(name: "arrow.left.circle"),
           Restaurant(name: "arrow.down.circle")
       ]
    @State var totalCount = 4
    
    var body: some View {
        VStack{
            ScrollView(showsIndicators: false ){
                LazyVStack(spacing: 15 ){
                    ForEach( 0..<totalCount ){ index in
                        RestaurantRow(restaurant: restaurants[index])
                            .if( index == restaurants.count - 1, else: index == restaurants.count - 2, transform: { view in
                                view.scaleEffect(1.4)
                            }, done: { view in
                                view.scaleEffect(1.2)
                            })
                    }
                }.padding([.top , .bottom], 15)
            }
        }
        .frame(width: 30, height: 300, alignment: .center)
        .onTapGesture {
            self.restaurants.append(Restaurant(name: "arrow.down.circle"))
            self.totalCount += 1
        }
    }
}

struct RestaurantRow: View {
    var restaurant: Restaurant

    var body: some View {
        Image(systemName: "\(restaurant.name)")
            .font(.title2)
            .foregroundColor(.blue)
    }
}

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
}



struct ActionList_Previews: PreviewProvider {
    static var previews: some View {
        ActionList()
    }
}
