//
//  HomePageViewController.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/10/18.
//

import Foundation
import UIKit

class HomePageViewController:UIViewController {
    
    let viewModel = HomePageViewModel()
    
    lazy var tableView = makeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PokeDéx"
        
        view.layer.insertSublayer(makeGradientLayer(), at: 0)
        view.addSubview(tableView)
        tableView.constraint(top: view.safeAreaLayoutGuide.snp.top, bottom: view.safeAreaLayoutGuide.snp.bottom, left: view.snp.left, right: view.snp.right)
        
    }
}

// MARK: - Factory Methods
extension HomePageViewController {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomePageTableViewCell.self, forCellReuseIdentifier: String(describing: HomePageTableViewCell.self))
        tableView.isScrollEnabled = false
        return tableView
    }
    
    func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.blue.cgColor] // 定義漸層顏色
        gradientLayer.locations = [0.4, 1.0] //設置顏色過渡點，表示第一個顏色佔比60%
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // 漸層的起點
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1) // 漸層的終點
        return gradientLayer
    }
}

// MARK: - UITableViewDataSource
extension HomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomePageTableViewCell.self), for: indexPath) as! HomePageTableViewCell
        cell.configureCell(with: viewModel.cellModelList[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITableViewDelegate
extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = AllPokemonListViewController()
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

