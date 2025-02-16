//
//  MoviesListView.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MoviesListView: BaseViewController {
    
    //MARK: - Outlets
    private lazy var text: UILabel = {
        let label = UILabel()
        label.text = "teste"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: - Variables
    var presenter: MoviesListPresenterProtocol?
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.viewDidLoad()
    }
    
    private func setup() {
        view.addSubview(text)
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

}

extension MoviesListView: MoviesListViewProtocol {
    
    func showMovies() {
        
    }

    func showError() {
        
    }
    
}
