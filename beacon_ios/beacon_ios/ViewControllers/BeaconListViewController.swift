//
//  ViewController.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import UIKit
import CoreLocation


class BeaconListViewController: UIViewController {
    
    private var presenter: BeaconListPresenter?
    weak var coordinator: MainCoordinator?
    
    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .white
        tableview.dequeueReusableCell(withIdentifier: "cell")
        return tableview
    }()
    
    private var floatingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(addBeaconButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(presenter: BeaconListPresenter) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        setupViews()
        setupConstraints()
        presenter?.loadItems()
//        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupViews() {
        self.view.addSubview(tableView)
        self.view.addSubview(floatingButton)
    }
    
    private func setupConstraints() {
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.floatingButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
    }
}

extension BeaconListViewController {
    
    @objc func addBeaconButtonPressed(_ sender: Any) {
        presenter?.goToDetail()
    }
}

extension BeaconListViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.fetchedBeacons.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier) as! CustomCell
        
        cell.nameLabel.text = presenter?.fetchedBeacons[indexPath.row].name
        cell.uuidLabel.text = presenter?.fetchedBeacons[indexPath.row].uuid
        cell.majorLabel.text = presenter?.fetchedBeacons[indexPath.row].major.string
        cell.minorLabel.text = presenter?.fetchedBeacons[indexPath.row].minor.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let fetchBeacons = presenter?.fetchedBeacons else {
                return
            }
            
        presenter?.stopMonitoring(item: fetchBeacons[indexPath.row])
        presenter?.removeBeacon(indexPath: indexPath.row)
        tableView.reloadData()
        }
    }
}
