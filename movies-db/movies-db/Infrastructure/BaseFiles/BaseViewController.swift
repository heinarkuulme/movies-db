//
//  BaseViewController.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showError(_ error: String, title: String = "Error", completion: ((UIAlertAction) -> Void)? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .default, handler: completion))
            self.present(alert, animated: true)
        }
        
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.tag = 999
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            let dimmingView = UIView()
            dimmingView.tag = 998
            dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(dimmingView)
            dimmingView.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                dimmingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                dimmingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: dimmingView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: dimmingView.centerYAnchor)
            ])
            
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            
            if let dimmingView = self.view.viewWithTag(998) {
                dimmingView.removeFromSuperview()
            }
            
            if let activityIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                self.hideActivityIndicator()
            }
        }
    }
    
}
