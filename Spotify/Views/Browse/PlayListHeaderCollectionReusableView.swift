//
//  PlayListHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Oday Dieg on 23/02/2022.
//

import UIKit
import SDWebImage

protocol PlayListHeaderCollectionReusableViewDelegate: AnyObject{
    func PlayListHeaderCollectionReusableViewDidTapPlayAll(_ header: PlayListHeaderCollectionReusableView)
    
}

final class PlayListHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "PlayListHeaderCollectionReusableView"
    
    weak var delegate:PlayListHeaderCollectionReusableViewDelegate?
    
    private let imageView:UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
       // label.backgroundColor = .red
        return label
        
    }()
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
       // label.backgroundColor = .green
        label.numberOfLines = 0
        return label
        
    }()
    private let ownerLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .secondaryLabel
//label.backgroundColor = .yellow
        return label
        
    }()
    
    private let PlayButton:UIButton = {
       
        let buttton = UIButton()
        buttton.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular))
        buttton.setImage(image, for: .normal)
        buttton.tintColor = .white
        buttton.layer.cornerRadius = 30
        buttton.layer.masksToBounds = true
        return buttton
    }()
    
    //MARK: - init
    
    override init(frame: CGRect){
    super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(PlayButton)
        PlayButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
        
        
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = height / 1.5
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 10, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: imageView.Bottom, width: width - 20, height: 30)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.Bottom, width: width - 80, height: 70)
        ownerLabel.frame = CGRect(x: 10, y: descriptionLabel.Bottom , width: width - 80, height: 20)
        PlayButton.frame = CGRect(x: width - 80, y: height - 80, width: 60, height: 60)
        
    }

    
    
    
    func configure(with viewModel:PlayListHeaderViewModel){
        
        nameLabel.text = viewModel.nameOfPlayList
        descriptionLabel.text = viewModel.descriptionPlayList
        ownerLabel.text = viewModel.owner
        imageView.sd_setImage(with: viewModel.PlayListImage, completed: nil)
        
    }
    
    @objc private  func didTapPlayAll(){
        delegate?.PlayListHeaderCollectionReusableViewDidTapPlayAll(self)
        
    }
    
}
