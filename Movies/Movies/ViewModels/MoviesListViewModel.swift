//
//  MovieListModels.swift
//  Movies
//
//  Created by Ozgur Hayat on 24/10/2020.
//

import Foundation
import UIKit
import CoreData

protocol UpdateTableViewDelegate: NSObjectProtocol {
    func reloadData(sender: MoviesListViewModel)
}

class MoviesListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultsController: NSFetchedResultsController<MovieEntity>?
    
    weak var delegate: UpdateTableViewDelegate?
    
    //MARK: Retrieve data from Core Data
    func retrieveDataFromCoreData() {
        
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            
            // Sorts movies by rating
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(MovieEntity.rate), ascending: false)]
            
            self.fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            // Notifying the tableView when any changes
            fetchedResultsController?.delegate = self
            
            // Fetch data
            do {
                try self.fetchedResultsController?.performFetch()
            } catch {
                print("Failed to initialize FetchedResultsController: \(error)")
            }
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Update the tableView
        self.delegate?.reloadData(sender: self)
    }
    
    //MARK: - TableView DataSource functions
    func numberOfRowsInSection (section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func object (indexPath: IndexPath) -> MovieEntity? {
        return fetchedResultsController?.object(at: indexPath)
    }
    
    
}
