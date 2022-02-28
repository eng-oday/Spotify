//
//  SearchResultViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit


struct searchSection {
    
    let title:String
    let results:[SearchResult]
}

protocol SearchResultViewControlleDelegate: AnyObject {
    
    func didTapResult(_ result: SearchResult)
}

class SearchResultViewController: UIViewController {

    
    weak var delegate:SearchResultViewControlleDelegate?
    
    private let tableView:UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
        
    }()
    
    private var sections:[searchSection] = []
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with result: [SearchResult]){
        
        let artists =  result.filter {
            switch $0 {
            case .artist: return true
            default: return false
                
            }
            
        }
        let albums =  result.filter {
            switch $0 {
            case .album: return true
            default: return false
                
            }
            
        }
        let tracks =  result.filter {
            switch $0 {
            case .track: return true
            default: return false
                
            }
            
        }
        let playlists =  result.filter {
            switch $0 {
            case .playlist: return true
            default: return false
                
            }
            
        }



        
        self.sections = [
            searchSection(title: "Artist", results: artists),
            searchSection(title: "Albums", results: albums),
            searchSection(title: "Playlists", results: playlists),
            searchSection(title: "Tracks", results: tracks)
            
            
        ]
        
        tableView.reloadData()
        
        tableView.isHidden = result.isEmpty
        
    }


}


extension SearchResultViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
    
        switch result {
            
        case.artist(let artist):
            
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else{
                  return UITableViewCell()
              }
            
            let viewModel = SearchResultDefaultTableViewCellViewModel(title: artist.name, imageUrl: URL(string: artist.images?.first?.url ?? ""))
              
            cell.configure(with: viewModel)
              
              return cell
            
        case.track(let track):
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else{
                  return UITableViewCell()
              }
            
            let viewModel = SearchResultSubtitleTableViewCellViewModel(title: track.name, subtitle: track.artists.first?.name ?? "-", imageUrl: URL(string: track.album?.images.first?.url ?? ""))
              
            cell.configure(with: viewModel)
              
              return cell
            
            
        case.album(let album):
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else{
                  return UITableViewCell()
              }
            
            let viewModel = SearchResultSubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "-", imageUrl: URL(string: album.images.first?.url ?? ""))
              
            cell.configure(with: viewModel)
              
              return cell
            
            
            
            
        case.playlist(let playlist):
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else{
                  return UITableViewCell()
              }
            
            let viewModel = SearchResultSubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.display_name, imageUrl: URL(string: playlist.images.first?.url ?? ""))
              
            cell.configure(with: viewModel)
              
              return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        
        delegate?.didTapResult(result)

    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    
    
}
