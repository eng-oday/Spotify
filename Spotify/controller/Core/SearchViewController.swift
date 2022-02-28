//
//  SearchViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController , UISearchResultsUpdating, UISearchBarDelegate {
    
    
    
    let searchController : UISearchController = {
        
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.searchBarStyle = .minimal
        vc.searchBar.placeholder = "Songs, Artists , Albums"
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout:UICollectionViewCompositionalLayout(sectionProvider: { _,_ -> NSCollectionLayoutSection? in
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(150)),
            subitem: item,
            count: 2
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return NSCollectionLayoutSection(group: group)
        
    }))
    
    private var categories = [Category]()
    
    var ViewModel:[CategoryCollectionViewCellViewModel]{
        
        categories.compactMap {
            return CategoryCollectionViewCellViewModel(
                image: URL(string: $0.icons.first?.url ?? ""),
                name: $0.name)
        }
    }
        
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        
        APIcaller.shared.GetAllCategory { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result
                {
                case .success(let data):
                    self?.categories = data
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    //call when press enter or search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let resultController = searchController.searchResultsController as? SearchResultViewController ,
              let query = searchBar.text ,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else{
                  return
              }
        resultController.delegate = self
        APIcaller.shared.Search(with: query) { response in
            
            DispatchQueue.main.async {
                switch response{
                case .success(let results):
                    resultController.update(with:results)
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }

            }
            
        }
    }
    
    // call every time press kyeboard
    func updateSearchResults(for searchController: UISearchController) {
    
        
    }
    
}


extension SearchViewController: SearchResultViewControlleDelegate {
    func didTapResult(_ result: SearchResult) {
    
        switch result {
            
        case.artist(let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case.track(let model):
            break
        case.album(let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case.playlist(let model):
            let vc = PlayListViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}


extension SearchViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath) as? CategoryCollectionViewCell
        else{
            return UICollectionViewCell()
        }
   
        let viewModel = ViewModel[indexPath.row]
        
    cell.configure(with: viewModel)
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
    
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    
    
}
