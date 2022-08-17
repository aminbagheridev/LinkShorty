//
//  LinkHistoryViewController.swift
//  linkShorty
//
//  Created by Amin  Bagheri  on 2022-08-14.
//

import UIKit

class LinkHistoryViewController: UIViewController {

    let realmManager = RealmManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVieww.delegate = self
        tableVieww.dataSource = self
        view.addSubview(tableVieww)
        view.backgroundColor = .systemBackground
        self.title = "History"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableVieww.reloadData()
    }
    
    private let tableVieww: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private func setupTableView() {
        tableVieww.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableVieww.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableVieww.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableVieww.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

    }

}

extension LinkHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        realmManager.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVieww.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = realmManager.links[indexPath.row].shortLink
            cell.detailTextLabel?.text = realmManager.links[indexPath.row].longLink
            return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let link = realmManager.links[indexPath.row]
            let linkId = link.id
            realmManager.links.remove(at: indexPath.row)
            realmManager.deleteLink(id: linkId)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let link = realmManager.links[indexPath.row].shortLink
        print("Link tapped")
        
        UIPasteboard.general.string = link
        let alertController = UIAlertController(title: "Copied Link!", message: "You can now paste it anywhere as needed.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Great!", style: .cancel)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
    
}


class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
