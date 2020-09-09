//
//  TracksController.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 04.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import UIKit
import RealmSwift

protocol TracksControllerDelegate: class {
  func tracksControllerDidSelectTrack(_ selectedTrack: RealmTrack)
}

class TracksController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView = UITableView()
    weak var delegate: TracksControllerDelegate?
    private lazy var tracks: Results<RealmTrack> = try! RealmService.get(RealmTrack.self)

    override func loadView() {
        super.loadView()
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TrackCell")
        cell.textLabel?.text = tracks[indexPath.row].date
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //guard let index = navigationController?.viewControllers.firstIndex(of: self),
        //      let mapController = navigationController?.viewControllers[index - 1] as? MapController
        //      else { return }
        self.navigationController?.popViewController(animated: true)
        let track = tracks[indexPath.row]
        delegate?.tracksControllerDidSelectTrack(track)
    }

}
