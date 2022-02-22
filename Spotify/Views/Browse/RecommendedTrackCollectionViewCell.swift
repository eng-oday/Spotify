//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Oday Dieg on 20/02/2022.
//

import UIKit
import SDWebImage

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    
    private let imageOfTrack:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
     
        return label
        
    }()
    
    private let artitstNameLabel:UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
      
        return label
        
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(imageOfTrack)
        contentView.addSubview(trackLabel)
        contentView.addSubview(artitstNameLabel)
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       // constraints
        trackLabel.sizeToFit()
        artitstNameLabel.sizeToFit()

        let imageSize = contentView.height - 5
        imageOfTrack.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        trackLabel.frame = CGRect(
            x: imageOfTrack.right + 10 ,
            y: 0,
            width: contentView.width - imageOfTrack.right - 20,
            height:45
        )
        artitstNameLabel.frame = CGRect(
            x: imageOfTrack.right + 10 ,
            y: trackLabel.Bottom,
            width: contentView.width - imageOfTrack.right-30 ,
            height: 30
        )
    
        
        
    }
    
    override func prepareForReuse(){
        imageOfTrack.image = nil
        trackLabel.text = nil
        artitstNameLabel.text = nil
        
        
    }
    
    func Configure(with viewModel:RecommentedTracksCellViewModel ){
        imageOfTrack.sd_setImage(with: viewModel.trackImage, completed: nil)
        trackLabel.text = viewModel.TrackName
        artitstNameLabel.text = viewModel.TrackName
    }
    
    
}
