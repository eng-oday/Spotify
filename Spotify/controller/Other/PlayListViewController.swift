//
//  PlayListViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit

class PlayListViewController: UIViewController {


    
    private let CollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ ->NSCollectionLayoutSection in
            // item
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
                )
            let item = NSCollectionLayoutItem( layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
    
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            )
    
            let group = NSCollectionLayoutGroup.vertical( layoutSize: groupSize , subitem: item, count: 1)
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            // to create header TO collectionView
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
                )
            ]
            return section
        })
    )
    
    
    private let playList:PlayList
    private var viewModel = [RecommentedTracksCellViewModel]()
    private var headerViewModel = [PlayListHeaderViewModel]()
    private var tracks = [AudioTracks]()
    
    init(playlist:PlayList) {
        self.playList = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(CollectionView)
        CollectionView.backgroundColor = .systemBackground
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        CollectionView.register(
            RecommendedTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier
        )
        //register header
        CollectionView.register(
            PlayListHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier
        )
        title = playList.name
        view.backgroundColor = .systemBackground
       
        fetchdata()

    }
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CollectionView.frame = view.bounds
    }
    
    
    func fetchdata(){
        
        APIcaller.shared.GetAlbumDetails(playList: playList) { [weak self] data in
            
            
            DispatchQueue.main.async {
                switch data{
                case .success(let data):
                    
                    self?.tracks = data.tracks.items.compactMap({$0.track})
                    self?.viewModel = data.tracks.items.compactMap({
                        
                        return RecommentedTracksCellViewModel(trackImage: URL(string: $0.track.album?.images.first?.url ?? ""),
                                                              artistName: $0.track.artists.first?.name ?? "-",
                                                              TrackName:$0.track.name)
                    })
                
                    self?.CollectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }

            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
    

    
    @objc private func didTapShare(){
        
        guard let urlPlayList = URL(string: playList.external_urls["spotify"]  ?? "") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [urlPlayList],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }

    
}


extension PlayListViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else{
            return UICollectionViewCell()
        }
        let viewmodel = viewModel[indexPath.row]
        cell.Configure(with: viewmodel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier,
            for: indexPath
        )as? PlayListHeaderCollectionReusableView ,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerViewModel = PlayListHeaderViewModel(
            PlayListImage: URL(string: playList.images.first?.url ?? ""),
            nameOfPlayList: playList.name,
            descriptionPlayList: playList.description,
            owner: playList.owner.display_name)
        
        // header configure
        
        header.configure(with: headerViewModel)
        // conform protocol
        header.delegate = self
        return header
    
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // play song
        let index = indexPath.row
        let track = tracks[index]
        
            PlayBackPresenter.shared.StartPlayBack(from: self, track: track)

      
        
    }
    
    
}

extension PlayListViewController:PlayListHeaderCollectionReusableViewDelegate{
    
    func PlayListHeaderCollectionReusableViewDidTapPlayAll(_ header: PlayListHeaderCollectionReusableView) {
        
        // start play list in queue
      
            PlayBackPresenter.shared.StartPlayBack(from: self, tracks: self.tracks)
     
    }
    
    
}
