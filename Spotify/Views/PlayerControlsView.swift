//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by Oday Dieg on 01/03/2022.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    
    func PlayerControlViewDidTapPlayPauseButton(_ PlayerControlsView: PlayerControlsView )
    func PlayerControlViewDidTapNextButton(_ PlayerControlsView: PlayerControlsView)
    func PlayerControlViewDidTapBackButton(_ PlayerControlsView: PlayerControlsView)
    func PlayerControlView(_ PlayerControlsView: PlayerControlsView, didSlideSlider value : Float)


}


final class PlayerControlsView :UIView{
    
    private var isPlaying = true
    weak var delegate:PlayerControlsViewDelegate?
    
    private let volimeSlider: UISlider = {
        
       let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let namelabel:UILabel = {
        
        let label = UILabel()
        label.text = "i want to sleep now "
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
       return label
    }()
    
    private let subtitlelabel:UILabel = {
        
        let label = UILabel()
        label.text = "pretty israa want to be sleep "
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
       return label
    }()
    
    
    private let backButton:UIButton = {
       let button = UIButton()
        button.tintColor = .label
        
        let image = UIImage(systemName: "backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let nextButton:UIButton = {
       let button = UIButton()
        button.tintColor = .label
        
        let image = UIImage(systemName: "forward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let playPauseButton:UIButton = {
       let button = UIButton()
        button.tintColor = .label
        
        let image = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .none
        addSubview(namelabel)
        addSubview(subtitlelabel)
        
        addSubview(volimeSlider)
        volimeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        clipsToBounds = true
        
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        backButton.addTarget(self, action: #selector(DidTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(DidTapNextButton), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(DidTapPlayPausekButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func DidTapBackButton(){
        
        delegate?.PlayerControlViewDidTapBackButton(self)
    }
    @objc func DidTapNextButton(){
        delegate?.PlayerControlViewDidTapNextButton(self)
        
    }
    @objc func DidTapPlayPausekButton(){
        self.isPlaying = !isPlaying
        delegate?.PlayerControlViewDidTapPlayPauseButton(self)
        
        //update icon
        let pause = UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))

        playPauseButton.setImage(isPlaying ? pause:play, for: .normal)
        
    }
    
    @objc func didSlideSlider(_ slider: UISlider){
        
        let valueOfSlider = slider.value
        
        delegate?.PlayerControlView(self, didSlideSlider: valueOfSlider)
    }
    
    
    
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        namelabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitlelabel.frame = CGRect(x: 0, y: namelabel.Bottom+10, width: width, height: 50)
        
        volimeSlider.frame = CGRect(x: 10, y: subtitlelabel.Bottom+20 , width: width-20, height: 44)
        
        let buttonSize:CGFloat = 60
        
        playPauseButton.frame = CGRect(x: (width-buttonSize)/2, y: volimeSlider.Bottom+30, width: buttonSize, height: buttonSize)
        
        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        
        nextButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)



        
    }
    
    func configure (with viewModel: PlayerControlsViewModel){
        
        namelabel.text = viewModel.songName
        subtitlelabel.text = viewModel.subtitle
        
    }
    
    

}
