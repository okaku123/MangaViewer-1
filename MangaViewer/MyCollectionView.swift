//
//  MyCollectionView.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/5/27.
//

import Foundation
import SwiftUI
import UIKit
import Nuke

struct MyCollectionView : UIViewRepresentable {
    
//    @ObservedObject var randomImages = collectionPictureViewModel()

    @State var imagesList : [PicModelObject] = []
    
    func makeUIView(context: Context) -> UICollectionView {
        let cellWidth = UIScreen.main.bounds.size.width
        let cellHeight = UIScreen.main.bounds.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth , height: cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register( MagaCell.self, forCellWithReuseIdentifier: "MagaCell")
        collectionView.showsHorizontalScrollIndicator = true
        
        let dataSource = UICollectionViewDiffableDataSource<MySection, PicModelObject>(collectionView: collectionView) { collectionView, indexPath, myModelObject in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MagaCell", for: indexPath) as! MagaCell
            cell.backgroundColor = .systemGray2
            print(myModelObject.urls.small)
            if let url = URL(string: myModelObject.urls.thumb) {
                Nuke.loadImage(with: url , into: cell.imageView )
            }
            // ...
            // Do whatever customization you want with your cell here!
            // ...
            return cell
        }
        collectionView.dataSource = dataSource
        populate(dataSource: dataSource)
        context.coordinator.dataSource = dataSource
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        guard let dataSource = context.coordinator.dataSource else { return }
        populate(dataSource: dataSource)
        
    }
    
    func makeCoordinator() -> MyCoordinator {
        MyCoordinator()
    }
    
    
    func populate(dataSource: UICollectionViewDiffableDataSource<MySection, PicModelObject>) {
        var snapshot = NSDiffableDataSourceSnapshot<MySection, PicModelObject>()
        snapshot.appendSections([.main])
//        snapshot.appendItems(randomImages.photoArray)
        snapshot.appendItems( imagesList )
        //        snapshot.appendItems([MyModelObject(), MyModelObject(), PicModelObject()])
        dataSource.apply(snapshot , animatingDifferences: true)
    }
}

// This represents the different sections in our UICollectionView. When using UICollectionViewDiffableDataSource, the model must be Hashable (which enums already are)
enum MySection : CaseIterable {
    case main
}

// This represents a model object that we would have in our collection. When using UICollectionViewDiffableDataSource, the model must be Hashable
class MyModelObject: Hashable {
    
    let id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MyModelObject, rhs: MyModelObject) -> Bool {
        return lhs.id == rhs.id
    }
}

class MyCoordinator {
    var dataSource: UICollectionViewDiffableDataSource<MySection, PicModelObject>?
}


struct MyCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MyCollectionView(imagesList: [])
    }
}
