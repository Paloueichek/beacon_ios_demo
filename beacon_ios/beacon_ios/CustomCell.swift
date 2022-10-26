//
//  CustomCell.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import UIKit


class CustomCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    var beaconImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "ibeacon_image"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
     var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    var uuidLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.font = .systemFont(ofSize: 15)
       return label
   }()
    
     var minorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var majorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var rssiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    var valueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        contentView.addSubview(nameStackView)
        contentView.addSubview(valueStackView)
        contentView.addSubview(beaconImageView)
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(uuidLabel)
        
        valueStackView.addArrangedSubview(majorLabel)
        valueStackView.addArrangedSubview(minorLabel)
        valueStackView.addArrangedSubview(rssiLabel)
        valueStackView.addArrangedSubview(distanceLabel)
    }
    
    func setConstraints() {
        self.beaconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        self.beaconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        self.beaconImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.beaconImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.nameStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        self.nameStackView.leadingAnchor.constraint(equalTo: beaconImageView.trailingAnchor).isActive = true
        self.nameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        self.nameStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
      
        self.valueStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 30).isActive = true
        self.valueStackView.leadingAnchor.constraint(equalTo: beaconImageView.trailingAnchor).isActive = true
        self.valueStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        self.valueStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
