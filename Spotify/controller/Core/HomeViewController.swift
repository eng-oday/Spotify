//
//  ViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit


class HomeViewController: UIViewController {

     
    private let spinner: UIActivityIndicatorView = {
       
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    private var newAlbums:[Album] = []
    private var playlist: [PlayList] = []
    private var tracks: [AudioTracks] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings)
        )
        ConfigureCollectionView()
        view.addSubview(spinner)
        Fetchdata()
    }
    
    
    //MARK: - Collection View Steup
    private var collectioView: UICollectionView =  UICollectionView(
        frame: .zero,
        collectionViewLayout:
            UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return HomeViewController.CreateSectionLayout(section: sectionIndex)
            }
    )
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectioView.frame = view.bounds
    }
    
    private func  ConfigureCollectionView(){
        view.addSubview(collectioView)
        // Register Collection View Cells
    
        collectioView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectioView.register(NewRelasesCollectionViewCell.self, forCellWithReuseIdentifier: NewRelasesCollectionViewCell.identifier)
        collectioView.register(FeaturedPlayListCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlayListCollectionViewCell.identifier)
        collectioView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectioView.register(
            TittleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TittleHeaderCollectionReusableView.identifier)

        
        collectioView.dataSource = self
        collectioView.delegate = self
        collectioView.backgroundColor = .systemBackground
    }
    
    //MARK: - Load data
    
    
    private func Fetchdata(){
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
       group.enter()

        var newRealses: NewRelasesResponse?
        var featuredPlayList: FeaturedPlayListResponse?
        var RecommnedetTarcks: RecomendationsResponse?
        // New Relases
        
        APIcaller.shared.GetNewRelases { result in
            
            defer{
                group.leave()
            }
            switch result {
            case .success(let model):
                newRealses = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // featcherd playlist
        APIcaller.shared.GetFeaturedPlaylist { result in
            
            defer{
                group.leave()
            }
            switch result {
            case .success(let model):
                featuredPlayList = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        //recomended tracks
        APIcaller.shared.GetGenreRecomendations(completion: { result in
            
            switch result {
            case.success(let data):
                let genres = data.genres
                var seeds = [String]()
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.append(random)
                    }
                }
                APIcaller.shared.GetRecomendations(geners: seeds) { recommendedResult in
                    defer{
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        RecommnedetTarcks = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
        group.notify(queue: .main){
            
            guard let newAlbums = newRealses?.albums.items ,
                  let playLists = featuredPlayList?.playlists.items,
                  let Tracks = RecommnedetTarcks?.tracks else{
                return
            }
            self.configureModels(newAlbums: newAlbums, playlist: playLists, tracks: Tracks)
            
        }
    }
    
   
    
    private func configureModels(newAlbums: [Album] ,playlist: [PlayList], tracks: [AudioTracks] ){
        //configure Models
        
        self.newAlbums = newAlbums
        self.playlist = playlist
        self.tracks = tracks
        
        sections.append(.NewRelases(viewModel: newAlbums.compactMap({
            return NewRealsesCellViewModel(name: $0.name, artWorkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
            
        })))
        
        sections.append(.FeaturedPlayList(viewModel: playlist.compactMap({
            
            return FeaturedPlayListCellViewModel(artWorkURL:URL(string: $0.images.first?.url ?? ""), name: $0.name, CreatorName: $0.owner.display_name)
        })))
                
        sections.append(.RecommendedTracks(viewModel: tracks.compactMap({
            
            return RecommentedTracksCellViewModel(trackImage: URL(string: $0.album?.images.first?.url ?? ""),
                                                  artistName: $0.artists.first?.name ?? "-",
                                                  TrackName: $0.name)
        })))
        
        collectioView.reloadData()
        
        
    }
    
    @objc func didTapSettings(){
        
        let vc = SettingViewController()
        vc.title = "settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        
    }

}

//MARK: - collectionView Extension

extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    enum BrowseSectionType {
        case NewRelases(viewModel: [NewRealsesCellViewModel])
        case FeaturedPlayList(viewModel: [FeaturedPlayListCellViewModel])
        case RecommendedTracks(viewModel: [RecommentedTracksCellViewModel])
        
        
        var title:String{
            
            switch self{
                
            case .NewRelases:
                return"New Realsed Albums"
            case .FeaturedPlayList:
                return "Fetaured PlayList"
            case .RecommendedTracks:
                return "Recommended"
            }
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let type  = sections[section]
        
        switch type{
            
        case .NewRelases(let viewModel):
            return viewModel.count
        case .FeaturedPlayList(let viewModel):
            return viewModel.count
        case .RecommendedTracks(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let type = sections[indexPath.section]
        
        switch type{
            
        case .NewRelases( let viewModel):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewRelasesCollectionViewCell.identifier, for: indexPath) as? NewRelasesCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            let viewModel = viewModel[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .FeaturedPlayList( let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlayListCollectionViewCell.identifier, for: indexPath) as? FeaturedPlayListCollectionViewCell else{
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.Configure(with: viewModel)
            return cell
            
        case .RecommendedTracks(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else{
                return UICollectionViewCell()
            }
            let viewModel = viewModel[indexPath.row]
            cell.Configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        
        switch section {
        case .NewRelases:
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
       
        case .FeaturedPlayList:
            
            let playlist = playlist[indexPath.row]
            let vc = PlayListViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
           
        case .RecommendedTracks:
            let track = tracks[indexPath.row]
            
            DispatchQueue.main.sync {
                PlayBackPresenter.shared.StartPlayBack(from: self, track: track)
            }
        
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind ,
            withReuseIdentifier: TittleHeaderCollectionReusableView.identifier,
            for: indexPath
        )  as? TittleHeaderCollectionReusableView ,
                kind == UICollectionView.elementKindSectionHeader
        else{
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        let title = sections[section].title
        
        header.configure(with:title)
        return header
    }
    
    
    //MARK: -  create section
     static func CreateSectionLayout(section:Int) -> NSCollectionLayoutSection
    {
        //headerview
        let supplementaryView  = [
            NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
            )
        ]
        

        switch section{
        case 0 :
            
            // item
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
                )
            let item = NSCollectionLayoutItem( layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
            
            
            // group
            let verticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(360)
            )
            let horizontalGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(380)
            )
            //vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical( layoutSize: verticalGroupSize , subitem: item, count:3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal( layoutSize: horizontalGroupSize , subitem: verticalGroup, count: 1)
            
            
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
            
        case 1:
            
            // item
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(200)
                )
            let item = NSCollectionLayoutItem( layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(400)
            )
  
            let horizontalGroupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(200),
                heightDimension: .absolute(430)
            )
            
            let verticalGroup = NSCollectionLayoutGroup.vertical( layoutSize: verticalGroupSize , subitem: item, count:2)

            let horizontalGroup = NSCollectionLayoutGroup.horizontal( layoutSize: horizontalGroupSize , subitem: verticalGroup, count: 1)
            
            
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryView

            return section
            
        case 2:
            
            // item
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
                )
            let item = NSCollectionLayoutItem( layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
    
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
            )
    
            let group = NSCollectionLayoutGroup.vertical( layoutSize: groupSize , subitem: item, count: 1)
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView

            return section

        default:
            // item
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
                )
            let item = NSCollectionLayoutItem( layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            
            // group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(360)
            )
          
            let group = NSCollectionLayoutGroup.vertical( layoutSize: groupSize , subitem: item, count:3)
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView

            return section
            
        }
  
    }
    
    
    
    
}
