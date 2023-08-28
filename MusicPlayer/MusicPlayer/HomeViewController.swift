//
//  HomeViewController.swift
//  MusicPlayer
//
//  Created by Tobi on 24/08/2023.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var listMusic: UITableView!

    let audios = DatabaseGetter().getAudios()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Music Player"
        
        listMusic.delegate = self
        listMusic.dataSource = self
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = listMusic.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell
        else
        {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "tableViewCellId")
            return cell
        }
        let cellData = audios[indexPath.row]
        
        tableViewCell.config(thisAudio: cellData)
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {
            vc.audioIndex = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
