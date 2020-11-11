//
//  OnBoardingVC.swift
//  Movies
//
//  Created by Ozgur Hayat on 24/10/2020.
//

import UIKit

class LaunchScreenVC: UIViewController {
    
    private var apiService = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadPopularMoviesData()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func loadPopularMoviesData() {
        
        // Fetch data from the server
        apiService.getMoviesData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                // Save data to Core Data
                CoreData.sharedInstance.saveDataOf(movies: listOf.movies)
                self?.perform(#selector(self?.mainScreen))
            case .failure(let error):
                // Show alert message in case of error
                self?.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    // MARK: - Alert message
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
//     Perform a transition to the main screen (MoviesListViewController)
    @objc func mainScreen() {
        DispatchQueue.main.asyncAfter(deadline:.now() + 5.0, execute: {
        let viewController = self.storyboard?.instantiateViewController(identifier: "main")
        self.navigationController?.pushViewController(viewController!, animated: true)
        })
    }
}

