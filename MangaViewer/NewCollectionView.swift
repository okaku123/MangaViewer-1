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

struct NewCollectionView : UIViewRepresentable {
    
    @State var imagesList : [ MangaPageObject ] = []
    @Binding var currentPageCount : Int
    @Binding var jumpPageCount : Int
    @Binding var jumpToggle : Bool

      func makeUIView(context: Context) -> UICollectionView {
        let cellWidth = UIScreen.main.bounds.size.width
        let cellHeight = UIScreen.main.bounds.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth , height: cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight) ,collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register( MagaCell.self, forCellWithReuseIdentifier: "MagaCell")
        collectionView.showsHorizontalScrollIndicator = true
//        collectionView.contentInset = .zero
//        collectionView.contentOffset = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        
        let dataSource = UICollectionViewDiffableDataSource< MagaSection , MangaPageObject >(collectionView: collectionView) { collectionView, indexPath, page in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MagaCell", for: indexPath) as! MagaCell
            cell.backgroundColor = .systemGray2
            if  let url = page.url , let imageReq = URL(string: url ) {
                Nuke.loadImage(with: imageReq , into: cell.imageView )
            }
            // ...
            // Do whatever customization you want with your cell here!
            // ...
            return cell
        }
        collectionView.dataSource = dataSource
        
        populate(dataSource: dataSource)
        context.coordinator.dataSource = dataSource
        collectionView.delegate = context.coordinator
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        guard let dataSource = context.coordinator.dataSource else { return }
        populate(dataSource: dataSource)
        
        if jumpToggle , jumpPageCount > -1{
            print("go to \(jumpPageCount)")
            uiView.scrollToItem(at: IndexPath(item: jumpPageCount , section: 0), at: .left , animated: true)
        }
    }
    
    func makeCoordinator() ->MangaCoordinator  {
        MangaCoordinator(self)
    }
    
    
    func populate(dataSource: UICollectionViewDiffableDataSource<MagaSection, MangaPageObject>) {
        var snapshot = NSDiffableDataSourceSnapshot<MagaSection, MangaPageObject>()
        snapshot.appendSections([.main])
        snapshot.appendItems( imagesList )
        //animatingDifferences 要设置为false  不然会在apply的时候遍历所有cellProvider
        dataSource.apply(snapshot , animatingDifferences: false)
    }
}

enum MagaSection : CaseIterable {
    case main
}

struct  MangaPageObject: Hashable {
    let id = UUID()
    let url : String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MangaPageObject , rhs: MangaPageObject) -> Bool {
        return lhs.id == rhs.id
    }
}

class MangaCoordinator : NSObject , UICollectionViewDelegate {
    
    var this  : NewCollectionView
    
     init( _ this : NewCollectionView ) {
        self.this = this
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if  !collectionView.indexPathsForVisibleItems.isEmpty , let f = collectionView.indexPathsForVisibleItems.first {
            let currentPage = f.row
            this.currentPageCount = currentPage
        }
    }
        
    var dataSource: UICollectionViewDiffableDataSource< MagaSection , MangaPageObject >?
    

    
}


