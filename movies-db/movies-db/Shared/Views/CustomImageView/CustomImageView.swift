//
//  CustomImageView.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

public class CustomImageView: UIImageView {
    
    private static let imageCached = NSCache<NSString, UIImage>()
    
    private var dataTask: URLSessionDataTask?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    public func loadImage(_ url: URL?, placeholderImage: UIImage? = nil) {
        dataTask?.cancel()

        self.image = placeholderImage
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        guard let url = url else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            return
        }
        
        let cacheKey = url.absoluteString
        
        if let cachedImage = CustomImageView.imageCached.object(forKey: cacheKey as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
                self.activityIndicator.stopAnimating()
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("Erro ao carregar imagem: \(error.localizedDescription) - URL: \(url.absoluteString)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            
            CustomImageView.imageCached.setObject(image, forKey: cacheKey as NSString)
            DispatchQueue.main.async {
                self.image = image
                self.activityIndicator.stopAnimating()
            }
            
        }.resume()
    }
}
