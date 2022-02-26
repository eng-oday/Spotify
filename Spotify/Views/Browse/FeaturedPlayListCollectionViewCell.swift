//
//  FeaturedPlayListCollectionViewCell.swift
//  Spotify
//
//  Created by Oday Dieg on 20/02/2022.
//

import UIKit
import SDWebImage

class FeaturedPlayListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeaturedPlayListCollectionViewCell"

    private let imageOfTrack:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let NameLabel:UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
    }()
    
    private let creatorLabel:UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .center

        label.numberOfLines = 0
        return label
        
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageOfTrack)
        contentView.addSubview(NameLabel)
        contentView.addSubview(creatorLabel)
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        // add constrain

        creatorLabel.frame = CGRect(
            x: 3,
            y: contentView.height-20,
            width: contentView.width - 5,
            height:20
        )
        NameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-50,
            width: contentView.width - 5,
            height: 30
        )
        let imageSize = contentView.height - 50
        
        imageOfTrack.frame = CGRect(x:(contentView.width - imageSize ) / 2 , y: 3, width: imageSize, height: imageSize)
        
    }
    
    override func prepareForReuse() {
        
        imageOfTrack.image = nil
        NameLabel.text = nil
        creatorLabel.text = nil
    }
    
    
     func Configure(with viewModel:FeaturedPlayListCellViewModel){
        
        NameLabel.text = viewModel.name
        creatorLabel.text = viewModel.CreatorName
        imageOfTrack.sd_setImage(with: viewModel.artWorkURL, completed: nil)
        
    }
    
    
    
}
