//
//  CategoryViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 27/02/2022.
//

import UIKit

class CategoryViewController: UIViewController {

    
    
    
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout:UICollectionViewCompositionalLayout(sectionProvider: { _,_ -> NSCollectionLayoutSection? in
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 2, trailing: 5)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(250)),
            subitem: item,
            count: 2
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        return NSCollectionLayoutSection(group: group)
        
    }))
    
    //MARK: - init
   private let category:Category
    
    init(category:Category){
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    private var playlists = [PlayList]()
    
    private var viewModel:[FeaturedPlayListCellViewModel]{
        
        playlists.compactMap {
            return FeaturedPlayListCellViewModel(
                artWorkURL:URL(string: $0.images.first?.url ?? "") ,
                name: $0.name,
                CreatorName: $0.owner.display_name)
        }
    }
    

    //MARK: - LifyCycle
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        fetchdata()
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeaturedPlayListCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlayListCollectionViewCell.identifier)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
        
    }
    
    private func fetchdata(){
        
        APIcaller.shared.GetCategoryPlayListById(with: category) { [weak self]result in
            
            DispatchQueue.main.async {
                switch result{
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.collectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }

            }
        }
        
    }
    
    
    

}



extension CategoryViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlayListCollectionViewCell.identifier, for: indexPath) as? FeaturedPlayListCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let viewModel = viewModel[indexPath.row]
        
        cell.Configure(with:viewModel)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let playlist = playlists[indexPath.row]
        let vc = PlayListViewController(playlist: playlist)
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    
    
}
