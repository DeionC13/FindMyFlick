//
//  ResultsListViewController.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 1/29/23.
//

import UIKit

class ResultsListViewController: UITableViewController {
    var currentMovie: Results?
    var results: [Results]?
 
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.88, green: 0.75, blue: 0.59, alpha: 1.00)
        tableView.register(UINib(nibName: "ResultsListViewCell", bundle: nil), forCellReuseIdentifier: "ResultsCell")
        
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        if let unwrappedResults = results {
            return unwrappedResults.count
        } else {
            return 1
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            if let destinationVC = segue.destination as? DetailsViewController {
                destinationVC.currentMovie = currentMovie
               
                
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if let selectedMovie = self.results?[indexPath.row] {
                self.currentMovie = selectedMovie
                self.performSegue(withIdentifier: "goToDetails", sender: self)
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsListViewCell
        cell.backgroundColor = UIColor(red: 0.88, green: 0.75, blue: 0.59, alpha: 1.00)
        
        if let movieResults = results {
            if let url = URL(string: movieResults[indexPath.row].image) {
            

            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        cell.movieImage.image = UIImage(data: data)
                      
                        
                    }
                    }
                }
            }
         
            cell.movieTitle.text = movieResults[indexPath.row].title
            
        }
        
        return cell
    }
   

    
}
