//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 23/02/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    
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
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)]
            return section
        })
    )
    
   private var counter = 0
    private var viewModel = [AlbumCollectionViewCellViewModel]()
    private var headerViewModel = [PlayListHeaderViewModel]()
    private let album:Album
    private var tracks = [AudioTracks]()
    
    init(album:Album ) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(CollectionView)
        CollectionView.backgroundColor = .systemBackground
        CollectionView.dataSource = self
        CollectionView.delegate = self
        
        CollectionView.register(
            AlbumTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier
        )
        //register header
        CollectionView.register(
            PlayListHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlayListHeaderCollectionReusableView.identifier
        )
        
        
        fetchdata()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CollectionView.frame = view.bounds
    }
    
    func fetchdata(){
        
        APIcaller.shared.GetAlbumDetails(album: album) {[weak self] data in
            DispatchQueue.main.sync {
                switch data{
                case .success(let data):
                    
                    self?.tracks = data.tracks.items
                    
                    self?.viewModel = data.tracks.items.compactMap({
                        
                        return AlbumCollectionViewCellViewModel(
                            artistName: $0.artists.first?.name ?? "-",
                            TrackName:$0.name)
                    })
                    
                    self?.CollectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                    
                    
                }
            }
            
            
        }
        
        
    }
    
    
}




extension AlbumViewController: UICollectionViewDelegate,UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else{
            return UICollectionViewCell()
        }
        let viewmodel = viewModel[indexPath.row]
        counter = indexPath.row + 1
        
        cell.Configure(with: viewmodel, number: counter)
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
            PlayListImage: URL(string: album.images.first?.url ?? ""),
            nameOfPlayList: album.name,
            descriptionPlayList: "Release Date: \(String.FormattedDate(string: album.release_date))",
            owner: album.artists.first?.name ?? "-"
        )

        // header configure

        header.configure(with: headerViewModel)
        // conform protocol
        header.delegate = self
        return header


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = indexPath.row
        var track = tracks[index]
        track.album = self.album
        PlayBackPresenter.shared.StartPlayBack(from: self, track: track)

    }


}

extension AlbumViewController:PlayListHeaderCollectionReusableViewDelegate{
    
    func PlayListHeaderCollectionReusableViewDidTapPlayAll(_ header: PlayListHeaderCollectionReusableView) {
        
        // start play list in queue

        // set to each track the image of album
        let tracksWithAlbum :[AudioTracks] = tracks.compactMap {
            
            var track = $0
            track.album = self.album
            return track
            
        }
        
        PlayBackPresenter.shared.StartPlayBack(from: self, tracks: tracksWithAlbum)
    }
    
    
}
