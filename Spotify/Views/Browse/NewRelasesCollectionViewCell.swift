//
//  NewRelasesCollectionViewCell.swift
//  Spotify
//
//  Created by Oday Dieg on 20/02/2022.
//

import UIKit
import SDWebImage

class NewRelasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewRelasesCollectionViewCell"
    
    
    private let albumCoverImageView:UIImageView = {
       
        let imagview = UIImageView()
        imagview.image = UIImage(systemName: "photo")
        imagview.contentMode = .scaleAspectFill
        return imagview
        
    }()
    
    private let albumNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let numberOfTracksLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0

        return label
    }()
    private let artistNameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0

        return label
    }()
    
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(numberOfTracksLabel)

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
        
      //  let albumNameLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-imageSize-10, height: contentView.height-10))
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
   //     let albumNameLabelHeight = min(50,albumNameLabelSize.height)
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 0,
            width:contentView.width-albumCoverImageView.width , //albumNameLabelSize.width
            height:contentView.height-albumCoverImageView.height+40 //albumNameLabelHeight
        )
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: albumNameLabel.Bottom,
            width: contentView.width - albumCoverImageView.right-40,
            height: 30
        )
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: artistNameLabel.Bottom,
            width: contentView.width - albumCoverImageView.right,
            height: 20
        )
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        artistNameLabel.text = nil
        albumNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
        
    }
    
    
    func configure (with ViewModel: NewRealsesCellViewModel){
        artistNameLabel.text = ViewModel.artistName
        albumNameLabel.text = ViewModel.name
        numberOfTracksLabel.text = "Tracks: \(ViewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: ViewModel.artWorkURL, completed: nil )
        
        
    }
    
}
