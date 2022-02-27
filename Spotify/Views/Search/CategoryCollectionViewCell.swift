//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Oday Dieg on 27/02/2022.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
 
    static let identifier = "CategoryCollectionViewCell"
    
    private let imageView:UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: 50,
                                    weight: .regular
                                  )
        )
        
        return imageView
        
    }()
    
    
    private let label:UILabel = {
       
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let colors:[UIColor] = [
        .systemPink,
        .systemGreen,
        .systemPurple,
        .systemRed,
        .systemBlue,
        .systemCyan,
        .darkGray,
        .systemOrange,
        .systemYellow,
        .systemTeal
    
    ]
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        addSubview(imageView)
        addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2, y: 10, width: contentView.width/2, height: contentView.height/2)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: 50,
                                    weight: .regular
                                  )
        )
        
    }
    
    func configure(with ViewModel:CategoryCollectionViewCellViewModel){
        label.text = ViewModel.name
        imageView.sd_setImage(with: ViewModel.image, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
    
    
    
}
