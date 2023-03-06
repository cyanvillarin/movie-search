//
//  ListViewController.swift
//  demo_app
//
//  Created by Villarin, Cyan on 2023/03/04.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    
    var moviesList: [Movie] = []
    
    let requestString = "https://api.themoviedb.org/3/search/movie"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Need to set the delegate and dataSource to 'self'
        // Which means that this ViewController 'ListViewController' should have the:
        /// for delegate (UITableViewDelegate) -> didSelectRowAt                               (for when the cell is tapped)            -> See the 'extension ListViewController: UITableViewDelegate' below
        /// for dataSource (UITableViewDataSource) -> numberOfRowsInSection       (number of cells in the tableView)   -> See the 'extension ListViewController: UITableViewDataSource' below
        /// for dataSource (UITableViewDataSource) -> cellForRowAt                          (the cell to display)                          -> See the 'extension ListViewController: UITableViewDataSource' below
        tableView.delegate = self
        tableView.dataSource = self
        
        // Since we are using a custom TableViewCell, we need to register it to the tableView
        // nibName - the name of the ListTableViewCell.xib on the left side
        // forCellReuseIdentifier - the 'Identifier' if you click the ListTableViewCell.xib
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ListTableViewCell")
    }
    
    // @IBAction - means you can link it in the .storyboard file
    // func - means it is a function/method
    @IBAction func didTapSearchButton() {
        guard let searchBarText = searchBar.text else { return }
        
        // getMovies is a function with a closure
        // need to capture self weakly so that when 'self' (ListViewController) is deallocated (it is NOT in the memory anymore)
        // it will be NULL, then we can just exit the closure (by executing 'return')
        getMovies(query: searchBarText, completionHandler: { [weak self] movies, message in
            
            // 'self' is Optional (can be NULL) coz we captured it weakly by [weak self]
            // if it is NULL, just return
            // if it is NOT NULL, proceed below
            guard let self = self else { return }
            
            // assign the movies retrieved from getMovies to the self.moviesList
            self.moviesList = movies
            
            // self.tableView.reloadData() is a function that involves the UI
            // It is required that we execute code that involves UI to be run on the main thread
            // So we need to use 'DispatchQueue.main.async'
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(movies)
            print(message ?? "No message")
        })
    }
    
    // getMovies - method/function name
    // query - the text that the user puts on the searchBar
    // completionHandler - the parameter that makes it possible for getMovies function to use 'closure'
    /// closure means that when the API returns a response, completionHandler will be called
    /// API call takes time (it is not instant -> will probably take 0.5sec to 1sec), so once that API is done, then completionHandler is called
    func getMovies(query: String, completionHandler: @escaping ([Movie], String?) -> Void) {
    
        // An example of a request is
        // https://api.themoviedb.org/3/search/movie?api_key=3e2e18da4dfb0fa90a468263972bb803&query=cars
        // In order to add the '?api_key=3e2e18da4dfb0fa90a468263972bb803&query=cars' we do it like this
        // https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query) BUT this is dangerous, and NOT recommended
        // It is kinda difficult to explain which it is dangerous, let's just say it will be easier to hack(?)
        // So we will proceed with the way below
        
        // Adding request parameters (example: &query=cars)
        /// Prepare the urlComponents
        guard var urlComponents = URLComponents(string: requestString) else {
            completionHandler([], "Failed to create URLComponents")
            return
        }
        
        /// Add the queryItems
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: query)
        ]
        
        /// Create the URL
        guard let url = urlComponents.url else {
            completionHandler([], "Failed to create URL")
            return
        }
        // After this, the '?api_key=3e2e18da4dfb0fa90a468263972bb803&query=cars' is already added to the requestString
        // url is now https://api.themoviedb.org/3/search/movie?api_key=3e2e18da4dfb0fa90a468263972bb803&query=cars
        
        // Cast it into URLRequest, so it can be used on URLSession.shared.dataTask()
        let request = URLRequest(url: url)
        
        // URLSession.shared.dataTask() is a function that has a 'closure'
        // It has closure coz it involves API call
        // API call takes time and not instant
        // Once API call is finished, it will return a tuple (Data?, URLResponse?, Error?)
        // In the completionHandler, we just named it (data, response, error)
        // Just remember this pattern:
        /// completionHandler: { (data, response, error) in
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            // First, check if there is error
            // In programming, it is always good to check if there is error
            // If there is error, exit from the closure
            if let error {
                completionHandler([], "Error: \(error)")
                return
            }
            
            // If there is no error, check if the response is from 200->299
            // In backend, usually 200->299 means that the backend response is successful
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler([], "Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            // if the response is 200->299, we can start decoding the raw data (NSData)
            // data is Optional (NSData?), so we check if it is NOT NULL by 'if let data'
            // JSONDecoded().decode() also is a function that CAN FAIL
            /// Since JSONDecoded().decode() has 'throws' keyword, it means it can fail
            /// Also since it has 'throws' keyword, we gotta use 'try' in front of the function
            if let data,
               let moviesList = try? JSONDecoder().decode(MoviesList.self, from: data) {
                // If it gets in here, it means it successfully decoded the data
                // Decodes the raw data into MoviesList
                completionHandler(moviesList.results, nil)
                return
            }
            
            // If it didn't decode, it will go here
            completionHandler([], "Failed to decode data")
            
        })

        // Don't forget about this, I think this means that 'start the task'
        task.resume()
    }

}

// for 'tableView.delegate = self' inside viewDidLoad() -> see above
extension ListViewController: UITableViewDelegate {
    // for when the cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailsViewController", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
        detailsVC.movie = moviesList[indexPath.row]
        self.present(detailsVC, animated: true)
    }
}

// for 'tableView.dataSource = self' inside viewDidLoad() -> see above
extension ListViewController: UITableViewDataSource {
    // number of cells in the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    // the cell to display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        // .setup() is a function we wrote in the ListTableViewCell
        /// this is the set the data from Movie into the cell's UILabels
        cell.setup(movie: moviesList[indexPath.row])
        return cell
    }
}

