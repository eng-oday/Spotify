//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Oday Dieg on 14/02/2022.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.isHidden = true
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
         
     }()
     
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        FetchUserData()

        view.addSubview(tableView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    //MARK: - Api
    
    private func FetchUserData(){
        
        APIcaller.shared.getCurrentUserProfile { [weak self] result in
            
            DispatchQueue.main.async {
                switch result
                {
                case .success(let model):
                    self?.UpdateProfileUI(with: model)

                case .failure(let error):
                    print("profile error : \(error.localizedDescription)")
                    self?.FailedToGetProfile()
               }
            }
        }
    }
    
    
    //MARK: - Custom Profile UI
    
    private func UpdateProfileUI(with model: UserProfile){
        
        tableView.isHidden = false
        //updateUI
        
        models.append("full name: \(model.display_name)")
        models.append(" email: \(model.email)")
        models.append(" the id:  \(model.id)")
        models.append("country: \(model.country)")
        models.append("product: \(model.product)")
        CreateTableHeader(with: model.images.first?.url)

        
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    private func FailedToGetProfile(){
        
        let Label = UILabel(frame: .zero)
        Label.text = "Failed To Load Profile"
        Label.sizeToFit()
        Label.textColor = .secondaryLabel
        view.addSubview(Label)
        Label.center = view.center
        
    }
    
    
    //MARK: - Table View
    
    private func CreateTableHeader(with url:String?){
        
        guard let Stringurl = url , let urL = URL(string: Stringurl) else{
            return
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        let imagSize:CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imagSize, height: imagSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imagSize/2
        imageView.sd_setImage(with: urL, completed: nil)
        
        tableView.tableHeaderView = headerView
        
        
    }
    
    
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
    }

}
