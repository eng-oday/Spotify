//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Oday Dieg on 28/02/2022.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {


    static let identifier = "SearchResultDefaultTableViewCell"
    
    
    let label:UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        return label
        
    }()
    
    
    let iconImageView: UIImageView = {
        
       let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        
        return imageview
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        
        accessoryType = .disclosureIndicator
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize:CGFloat = contentView.height - 10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        label.frame = CGRect(x: iconImageView.right + 10, y: 0, width: contentView.width - iconImageView.right - 15, height: contentView.height)
        
        iconImageView.layer.cornerRadius = imageSize / 2
        iconImageView.layer.masksToBounds = true
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        
    }
    
    
    func configure(with Viewmodel: SearchResultDefaultTableViewCellViewModel){
        
        label.text = Viewmodel.title
        iconImageView.sd_setImage(with: Viewmodel.imageUrl, completed: nil)
        
    }
    
}
