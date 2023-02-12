//
//  ViewController.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 1/26/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var activityView: UIActivityIndicatorView?
    var movieManager = MovieManager()
    var movieName: String?
    var movieDescription: String?
    var resultsList: [Results]?
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 0.88, green: 0.75, blue: 0.59, alpha: 1.00)
        movieManager.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
//MARK: - Movie Manager Methods


extension SearchViewController: MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: MovieModel) {
        DispatchQueue.main.async {
            
            self.movieName = movie.movieName
            self.movieDescription = movie.movieDescription
            self.resultsList = movie.results
            self.hideActivityIndicator()
            self.performSegue(withIdentifier: "goToResults", sender: self)
            // update with new movie data here
            
        }
    }
    
   
    
    func didFailWithError(error: Error) {
        print("error updating movie" )
    }
    
}
//MARK: - Search Bar Methods
extension SearchViewController: UISearchBarDelegate {
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        activityView?.color = UIColor(red: 0.18, green: 0.14, blue: 0.14, alpha: 1.00)
        

        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    func hideActivityIndicator() {
     
            activityView?.stopAnimating()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let userSearch = searchBar.text {
            movieManager.fetchMovie(for: userSearch)
            showActivityIndicator()
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToResults" {
            if let destinationVC = segue.destination as? ResultsListViewController {
                destinationVC.results = resultsList
            }
        }
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


