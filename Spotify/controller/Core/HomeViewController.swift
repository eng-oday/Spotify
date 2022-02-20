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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
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
        
        sections.append(.NewRelases(viewModel: newAlbums.compactMap({
            return NewRealsesCellViewModel(name: $0.name,
                                           artWorkURL: URL(string:$0.images.first?.url ?? "") ,
                                           numberOfTracks: $0.total_tracks,
                                           artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.FeaturedPlayList(viewModel: []))
        sections.append(.RecommendedTracks(viewModel: []))
        
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
        case FeaturedPlayList(viewModel: [NewRealsesCellViewModel])
        case RecommendedTracks(viewModel: [NewRealsesCellViewModel])
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
            cell.backgroundColor = .red
            return cell
        case .FeaturedPlayList( let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlayListCollectionViewCell.identifier, for: indexPath) as? FeaturedPlayListCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.backgroundColor = .blue
            return cell
        case .RecommendedTracks(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.backgroundColor = .green
            return cell
        }
    }
    
     static func CreateSectionLayout(section:Int) -> NSCollectionLayoutSection
    {

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
                heightDimension: .absolute(360)
            )
            //vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical( layoutSize: verticalGroupSize , subitem: item, count:3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal( layoutSize: horizontalGroupSize , subitem: verticalGroup, count: 1)
            
            
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
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
                heightDimension: .absolute(400)
            )
            
            let verticalGroup = NSCollectionLayoutGroup.vertical( layoutSize: verticalGroupSize , subitem: item, count:2)

            let horizontalGroup = NSCollectionLayoutGroup.horizontal( layoutSize: horizontalGroupSize , subitem: verticalGroup, count: 1)
            
            
            //section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
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
            return section
            
        }
  
    }
    
    
    
    
}
