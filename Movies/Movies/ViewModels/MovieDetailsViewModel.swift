//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Ozgur Hayat on 24/10/2020.
//

import Foundation

class MovieDetailsViewModel {
    
    let movieDetails: MovieEntity?
    
    let title: String?
    let rate: String?
    let year: String?
    let overview: String?
    let posterImage: String?
    
    init(movieDetails: MovieEntity?) {
        self.movieDetails = movieDetails
        
        self.title = movieDetails?.title
        self.rate = movieDetails?.rate
        self.year = MovieDetailsViewModel.convertDataFormat(movieDetails?.year)
        self.overview = movieDetails?.overview
        self.posterImage = "https://image.tmdb.org/t/p/w300" + movieDetails!.posterImage!
    }
    
    //MARK: - Convert date format
    private static func convertDataFormat(_ date: String?) -> String {
        var dateOutput = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateInput = date {
            if let newDate = dateFormatter.date(from: dateInput) {
                dateFormatter.dateFormat = "MMM d, yyyy"
                dateOutput = dateFormatter.string(from: newDate)
            }
        }
        return dateOutput
    }
}
