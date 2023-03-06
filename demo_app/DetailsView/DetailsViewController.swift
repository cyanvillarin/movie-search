//
//  DetailsViewController.swift
//  demo_app
//
//  Created by Villarin, Cyan on 2023/03/04.
//

import Foundation
import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    // This is set during the didSelectRowAt on ListViewController
    // This is set just before the 'self.present(detailsVC, animated: true)'
    var movie: Movie!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var overviewTextView: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    // viewDidLoad means that the ViewController is already allocated in the memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Since it is already in the memory, we can call setup(movie: Movie)
        // We can access the UILabels without problem since the this ViewController is already in the memory
        setup(movie: movie)
    }
    
    func setup(movie: Movie) {
        titleLabel.text = movie.title
        voteCountLabel.text = String(movie.voteCount)
        overviewTextView.text = movie.overview
        
        // First check if posterPath is NULL (posterPath is Optional)
        if let posterPath = movie.posterPath {
            
            // If it is NOT NULL, construct the complete imagePath (since posterPath is just a part of the image URL)
            let completeImagePath = "https://image.tmdb.org/t/p/w500\(posterPath)"
            
            // Cast it into URL since completeImagePath is still a String
            let imageUrl = URL(string: completeImagePath)
            
            // set the image using the KingFisher's library function
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
}
