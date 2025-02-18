//
//  FavoriteMoviesView.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import UIKit

class FavoriteMoviesView: BaseViewController {
    
    private enum Constants {
        static let title: String = "Favoritos"
        static let emptyLabelText: String = "Nenhum filme favoritado"
    }
    
    //MARK: - Outlets
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .black
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.emptyLabelText
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    //MARK: - Variables
    var presenter: FavoriteMoviesPresenterProtocol?
    private var movies: [MovieDetailsConfig] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        self.showActivityIndicator()
        presenter?.viewDidAppear()
    }
    
    private func setup() {
        navigationItem.title = Constants.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteMovieTableViewCell.self, forCellReuseIdentifier: FavoriteMovieTableViewCell.identifier)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

extension FavoriteMoviesView: FavoriteMoviesViewProtocol {
    func showFavorites(movies: [MovieDetailsConfig]) {
        self.movies = movies
        self.hideActivityIndicator()
        
        if movies.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }

    func showFavoriteError(message: String) {
        self.hideActivityIndicator()
        self.showError(message)
    }

}

extension FavoriteMoviesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMovieTableViewCell.identifier, for: indexPath) as? FavoriteMovieTableViewCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        cell.removeButtonTapped = { [weak self] in
            self?.presenter?.didTapRemoveFavorite(index: indexPath.row)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        presenter?.didSelectItem(movie: movie)
    }
}
