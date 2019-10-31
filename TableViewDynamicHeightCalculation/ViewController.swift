//
//  ViewController.swift
//  TableViewDynamicHeightCalculation
//
//  Created by Fani Hamdani on 31/10/19.
//  Copyright © 2019 fani. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let btn1 = UIButton(type: .system)
        btn1.setTitle("HeightCalculationUsingLabel", for: .normal)
        btn1.addTarget(self, action: #selector(btn1_Tapped(sender:)), for: .touchUpInside)
        
        let btn2 = UIButton(type: .system)
        btn2.setTitle("HeightCalculationUsingBoundingRect", for: .normal)
        btn2.addTarget(self, action: #selector(btn2_Tapped(sender:)), for: .touchUpInside)
        
        let btn3 = UIButton(type: .system)
        btn3.setTitle("HeightCalculationUsingAutoLayout", for: .normal)
        btn3.addTarget(self, action: #selector(btn3_Tapped(sender:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [btn1, btn2, btn3])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        self.view = view
    }
    
    @objc func btn1_Tapped(sender: UIButton) {
        let vc = DynamicHeightCalculationUsingLabel()
        vc.title = sender.titleLabel?.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btn2_Tapped(sender: UIButton) {
        let vc = DynamicHeightCalculationUsingBoundingRect()
        vc.title = sender.titleLabel?.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btn3_Tapped(sender: UIButton) {
        let vc = DynamicHeightCalculationUsingAutoLayout()
        vc.title = sender.titleLabel?.text
        navigationController?.pushViewController(vc, animated: true)
    }
}

class MyTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let data = [
        "The quick brown fox jumps over the lazy dog.",
        "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
        "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
        "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog."
    ]
    
    let labelFont = (UITableViewCell().textLabel?.font)!
    let constrainedWidth: CGFloat = UIScreen.main.bounds.width - 30
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let tableView = UITableView()
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        self.view = view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
}

class DynamicHeightCalculationUsingLabel: MyTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[indexPath.row].heightUsingLabel(constrainedWidth: constrainedWidth, font: labelFont)
    }
}

class DynamicHeightCalculationUsingBoundingRect: MyTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[indexPath.row].heightUsingBoundingRect(constrainedWidth: constrainedWidth, font: labelFont)
    }
}

class DynamicHeightCalculationUsingAutoLayout: MyTableViewController {
    var prototypeCell: AutoLayoutCell?
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let tableView = UITableView()
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(AutoLayoutCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        self.view = view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AutoLayoutCell
        cell.label?.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if prototypeCell == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AutoLayoutCell
            prototypeCell = cell
        }
        
        prototypeCell?.label?.text = data[indexPath.row]
        prototypeCell?.layoutIfNeeded()
        
        let constraintRect = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        let size = prototypeCell?.contentView.systemLayoutSizeFitting(constraintRect, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel) ?? .zero
        //let size = prototypeCell?.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) ?? .zero
        return size.height
    }
}

class AutoLayoutCell: UITableViewCell {
    
    var label: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        self.label = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension String {
    func heightUsingLabel(constrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightUsingBoundingRect(constrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
