//
//  BeaconDetailsViewController.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import UIKit

protocol BeaconDetailsDelegate: AnyObject {
    func addBeacon(item: Beacon)
}

class BeaconDetailsViewController: UIViewController {
    
    weak var coordinator: DetailCoordinator?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 25
        label.font = UIFont(name: "Arial", size: 30)
        label.text = "Enter Beacon Values"
        label.textAlignment = .center
        return label
    }()
    
    private var uuidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 25
        label.text = "Enter uuid"
        return label
    }()
    
    private var uuidTextField: UITextField = {
        let uuidTextField = UITextField()
        uuidTextField.translatesAutoresizingMaskIntoConstraints = false
        uuidTextField.backgroundColor = .gray
        return uuidTextField
    }()
    
    private var minValueTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 25
        label.text = "Enter Minor"
        label.textAlignment = .natural
        return label
    }()
    
    
    private var minValueTextField: UITextField = {
        let minValueTextField = UITextField()
        minValueTextField.translatesAutoresizingMaskIntoConstraints = false
        minValueTextField.backgroundColor = .gray
        return minValueTextField
    }()
    
    private var maxValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 25
        label.text = "Enter Major"
        label.textAlignment = .natural
        return label
    }()
    
    private var maxValueTextField: UITextField = {
        let maxValueTextField = UITextField()
        maxValueTextField.translatesAutoresizingMaskIntoConstraints = false
        maxValueTextField.backgroundColor = .gray
        return maxValueTextField
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 25
        label.text = "Enter name"
        label.textAlignment = .left
        return label
    }()
    
    private var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.backgroundColor = .gray
        return nameTextField
    }()
    
    private var enterBeaconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(enterBeaconButtonPressed), for: .touchUpInside)
        button.setTitle("Enter Beacon", for: .normal)
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        return stackView
    }()
    
    weak var delegate: BeaconDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    private func setupViews() {
        self.view.addSubview(titleLabel)
        
        self.view.addSubview(uuidLabel)
        self.view.addSubview(uuidTextField)
        
        self.view.addSubview(minValueTitleLabel)
        self.view.addSubview(minValueTextField)

        self.view.addSubview(maxValueLabel)
        self.view.addSubview(maxValueTextField)
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(nameTextField)
        
        self.view.addSubview(enterBeaconButton)
    }
    
    private func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        uuidLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40).isActive = true
        uuidLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        uuidLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        uuidLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
        uuidTextField.topAnchor.constraint(equalTo: self.uuidLabel.topAnchor).isActive = true
        uuidTextField.leadingAnchor.constraint(equalTo: uuidLabel.trailingAnchor).isActive = true
        uuidTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        uuidTextField.heightAnchor.constraint(equalTo: self.uuidLabel.heightAnchor).isActive = true
        
        minValueTitleLabel.topAnchor.constraint(equalTo: self.uuidLabel.bottomAnchor, constant: 20).isActive = true
        minValueTitleLabel.leadingAnchor.constraint(equalTo: self.uuidLabel.leadingAnchor).isActive = true
        minValueTitleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        minValueTitleLabel.heightAnchor.constraint(equalTo: self.uuidLabel.heightAnchor).isActive = true
        
        minValueTextField.topAnchor.constraint(equalTo: self.minValueTitleLabel.topAnchor).isActive = true
        minValueTextField.leadingAnchor.constraint(equalTo: minValueTitleLabel.trailingAnchor).isActive = true
        minValueTextField.trailingAnchor.constraint(equalTo: self.uuidTextField.trailingAnchor).isActive = true
        minValueTextField.heightAnchor.constraint(equalTo: self.minValueTitleLabel.heightAnchor).isActive = true
        
        maxValueLabel.topAnchor.constraint(equalTo: self.minValueTitleLabel.bottomAnchor, constant: 20).isActive = true
        maxValueLabel.leadingAnchor.constraint(equalTo: self.uuidLabel.leadingAnchor).isActive = true
        maxValueLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        maxValueLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        maxValueTextField.topAnchor.constraint(equalTo: self.maxValueLabel.topAnchor).isActive = true
        maxValueTextField.leadingAnchor.constraint(equalTo: maxValueLabel.trailingAnchor).isActive = true
        maxValueTextField.trailingAnchor.constraint(equalTo: self.uuidTextField.trailingAnchor).isActive = true
        maxValueTextField.heightAnchor.constraint(equalTo: self.maxValueLabel.heightAnchor).isActive = true

        nameLabel.topAnchor.constraint(equalTo: self.maxValueLabel.bottomAnchor, constant: 20).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.maxValueLabel.leadingAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: self.nameLabel.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: self.uuidTextField.trailingAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: self.nameLabel.heightAnchor).isActive = true
        
        enterBeaconButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 20).isActive = true
        enterBeaconButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20).isActive = true
        enterBeaconButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        enterBeaconButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}

extension BeaconDetailsViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
    @objc func enterBeaconButtonPressed() {
        let uuidString = uuidTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let major = Int(maxValueTextField.text!) ?? 0
        let minor = Int(minValueTextField.text!) ?? 0
        let name = nameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let item = Beacon(uuid: uuidString, major: major, minor: minor, name: name)
        if item.isValid {
            delegate?.addBeacon(item: item)
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Enter valid UUID", message: "You didn't enter proper UUID ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
}
