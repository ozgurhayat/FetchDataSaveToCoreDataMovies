//
//  MoviesListTableViewCell.swift
//  Movies
//
//  Created by Ozgur Hayat on 24/10/2020.
//

import UIKit


class MainCell: UITableViewCell {

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
//    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieRate: UILabel!

    
    private var apiService = ApiService()
    private var urlString: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImg.layer.cornerRadius = 14
    }
    
    func setCellWithValuesOf(_ movie:MovieEntity) {
        updateUI(title: movie.title, rate: movie.rate, backdrop: movie.backdropImage)
    }

    private func updateUI(title:String?, rate:String?, backdrop:String?) {
        
        self.mainTitle.text = title
        self.movieRate.text = rate
//        self.movieOverview.text = overview
        
        guard let backdropString = backdrop else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + backdropString
        
        guard let backdropImageURL = URL(string: urlString) else {
            self.mainImg.image = UIImage(named: "noImageAvailable")
            return
        }
        
        
        self.mainImg.image = nil
        
        apiService.getImageDataFrom(url: backdropImageURL) { [weak self] (data: Data) in
            if let image = UIImage(data: data) {
                self?.mainImg.image = image
            } else {
                self?.mainImg.image = UIImage(named: "noImageAvailable")
            }
        }
    }

}

