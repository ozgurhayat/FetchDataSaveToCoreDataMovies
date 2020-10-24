//
//  ViewController.swift
//  Movies
//
//  Created by Ozgur Hayat on 24/10/2020.
//

import UIKit

class MainVC: UIViewController, UpdateTableViewDelegate {

    @IBOutlet weak var warningTextView: UITextView!
    @IBOutlet var warningView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    
    private var viewModel = MoviesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTableView.dataSource = self
        self.viewModel.delegate = self
        
        setNavigationBar()
        loadData()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func loadData() {
        viewModel.retrieveDataFromCoreData()
    }
    
    func reloadData(sender: MoviesListViewModel) {
        self.mainTableView.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
        }

    
    // Mark: TableView beginning animation
    
    func animateTable() {
        mainTableView.reloadData()
        let cells = mainTableView.visibleCells
        
        let tableViewHeight = mainTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.06, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "movieSelected" {
            guard let detailsVC = segue.destination as? MovieDetailsViewController else {return}
            guard let selectedMovieCell = sender as? UITableViewCell else {return}
            
            if let indexPath = mainTableView.indexPath(for: selectedMovieCell) {
                let selectedMovie = viewModel.object(indexPath: indexPath)
                detailsVC.viewModel = MovieDetailsViewModel(movieDetails: selectedMovie)
            }
            // Back button without title on the next screen
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
    }
    
    private func setNavigationBar() {
        // Transparent the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        navigationController?.hidesBarsOnSwipe = false
    }
    
        
    }
    

//MARK: - TableView

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let object = viewModel.object(indexPath: indexPath)
        
        if let movieCell = cell as? MainCell {
            if let movie = object {
                movieCell.setCellWithValuesOf(movie)
            }
        }
        return cell
    }
    
    
}

