//
//  MagaCell.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/5/27.
//

import Foundation
import UIKit
import Foundation

class MagaCell : UICollectionViewCell {
    
    var imageView:UIImageView!
    var titleLabel:UILabel!
    var screen: CGSize!
    var representedId: UUID?
    var type: Int = 1
    var flag: Bool = false
    
    var scroll:UIScrollView!
    
    lazy var _maskView:UIView = { return UIView() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        initScroll()
        initImage()
//        initLable()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImage(with image : UIImage?) {
        imageView.image = image
    }
    
    
    func initLable(){
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.darkGray
        titleLabel.textColor = UIColor.lightGray
        titleLabel.font = titleLabel.font.withSize(10)
        titleLabel.layer.cornerRadius = 7
        titleLabel.layer.masksToBounds = true
        self.contentView.addSubview(titleLabel)
    }
    
    func initScroll(){
        scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height )
        scroll.showsHorizontalScrollIndicator = true
        scroll.showsVerticalScrollIndicator = true
        scroll.isScrollEnabled = true
        scroll.scrollsToTop = false
        scroll.bounces = true
        scroll.zoomScale = 1.0
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 1.75
        scroll.bouncesZoom = true
        scroll.isPagingEnabled = false
        scroll.delegate = self
        scroll.isMultipleTouchEnabled = false
        contentView.addSubview(scroll)
    }
    
    func initMask( value :Float ){
        _maskView.frame = self.contentView.frame
        _maskView.backgroundColor = UIColor.black
        _maskView.alpha = CGFloat(value)
        imageView.mask = _maskView
    }
    
    
   
}

extension MagaCell :UIScrollViewDelegate{
    
    func initImage(){
        imageView = UIImageView(frame: self.contentView.frame)
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        //        self.contentView.addSubview(imageView)
        
        self.scroll.addSubview(imageView)
        
    }
    

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}



