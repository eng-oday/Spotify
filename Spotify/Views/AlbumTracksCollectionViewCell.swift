//
//  AlbumTracksCollectionViewCell.swift
//  Spotify
//
//  Created by Oday Dieg on 26/02/2022.
//

import Foundation
import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumTrackCollectionViewCell"
    

    private let trackLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        //label.backgroundColor = .red
     
        return label
        
    }()
    private let trackNumberLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
     
        return label
        
    }()

    
    private let artitstNameLabel:UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
       // label.backgroundColor = .green
      
        return label
        
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackLabel)
        contentView.addSubview(trackNumberLabel)
        contentView.addSubview(artitstNameLabel)
        
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       // constraints
       // trackLabel.sizeToFit()
       // artitstNameLabel.sizeToFit()


        
        trackNumberLabel.frame = CGRect(
            x:  20 ,
            y: 15,
            width: 30,
            height: contentView.height / 2
        )
        
        trackLabel.frame = CGRect(
            x:  trackNumberLabel.right + 10 ,
            y: 0,
            width: contentView.width - trackNumberLabel.width,
            height: (contentView.height / 1.5) - 10
        )
        artitstNameLabel.frame = CGRect(
            x: trackNumberLabel.right + 10 ,
            y: trackLabel.Bottom,
            width: contentView.width - 15 ,
            height: contentView.height - trackLabel.height
        )
    
        
        
    }
    
    override func prepareForReuse(){
        trackLabel.text = nil
        artitstNameLabel.text = nil
        trackNumberLabel.text = nil
        
        
    }
    
    func Configure(with viewModel:AlbumCollectionViewCellViewModel , number: Int ){
        trackLabel.text = viewModel.TrackName
        artitstNameLabel.text = viewModel.artistName
        trackNumberLabel.text =  String(number)
    }
    
    
}
