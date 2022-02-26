//
//  TittleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Oday Dieg on 25/02/2022.
//

import UIKit

class TittleHeaderCollectionReusableView: UICollectionReusableView {
 
    
    static let identifier = "TittleHeaderCollectionReusableView"
    
    private let label:UILabel = {
       
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .systemBackground
         addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: 0, width: width - 20 , height: height)
        
    }
    
    func configure(with title:String){
        
        label.text = title
        
    }
    
}
