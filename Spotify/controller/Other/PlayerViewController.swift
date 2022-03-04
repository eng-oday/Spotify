//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit
import SDWebImage


//MARK: - protocols

protocol PlayerDataSource: AnyObject {
    
    var title:String? {get}
    var subTitle:String? {get}
    var imageURL:URL? {get}
}

protocol PlayerViewControllerDelegate : AnyObject{
    
    
    func didTapPlayPauseBtn()
    func didTapNextBtn()
    func didTapBackwardBtn()
    func didSlideSliderBtn(_ value:Float)
    
}


//MARK: - main class

class PlayerViewController: UIViewController {

    
    weak var dataSource:PlayerDataSource?
    weak var delegate : PlayerViewControllerDelegate?
    
    private let imageView:UIImageView = {
       
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemBlue
        return image
        
    }()
    private let controlView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlView)
        controlView.delegate = self
        ConfigureBarButton()
        
        configureDataToView()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top  , width: view.width, height: view.width)
        controlView.frame = CGRect(
            x: 10,
            y: imageView.Bottom + 10,
            width: view.width-20,
            height: view.height - imageView.height - view.safeAreaInsets.top-view.safeAreaInsets.bottom-15
        )
        
    }
    
    
    private func configureDataToView(){
        
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        
        let viewModel = PlayerControlsViewModel(songName: dataSource?.title, subtitle: dataSource?.subTitle)
        controlView.configure(with: viewModel)
        
    }
    
    
    private func ConfigureBarButton(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector (DidTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector (DidTapAction))

    }
    
    
    @objc func DidTapClose(){
        
        // close songs and resest play list and dismiss vc
        dismiss(animated: true)
        PlayBackPresenter.shared.playerQueue?.removeAllItems()
     PlayBackPresenter.shared.index = 0
        PlayBackPresenter.shared.player?.replaceCurrentItem(with: nil)
        
        
        
        
    }
    @objc func DidTapAction(){
        
    //action
        
    }
    
    
    public func RefreshUI(){
        
        configureDataToView()
    }
  



}


//MARK: - conform protocol mn el view bibl8 en el button etdas 3aleha

extension PlayerViewController: PlayerControlsViewDelegate {
    
    func PlayerControlView(_ PlayerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        
        // bbl8 ana b protocol tani el presenter nafz el func ele 3andk el te5os el button dah w lw feh value bb3tha
        delegate?.didSlideSliderBtn(value)
    }
    
    func PlayerControlViewDidTapPlayPauseButton(_ PlayerControlsView: PlayerControlsView) {
        // lma ana etbl8t fel protocol da en eluser das 3la button bta3 el play and pause
        
        // ana mn hena b2a bl8t el presenter eno etdas 3la el button fa nafz el func bta3t el pause and play
        delegate?.didTapPlayPauseBtn()
    
    }
    
    func PlayerControlViewDidTapNextButton(_ PlayerControlsView: PlayerControlsView) {
        delegate?.didTapNextBtn()
    }
    
    func PlayerControlViewDidTapBackButton(_ PlayerControlsView: PlayerControlsView) {
        delegate?.didTapBackwardBtn()
    }
    
    
    
    
}
