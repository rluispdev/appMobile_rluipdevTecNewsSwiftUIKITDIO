//
//  ViewController.swift
//  rluispdevNews
//
//  Created by Rafael Gonzaga on 4/24/25.
//

import UIKit

class NewsListViewController: UIViewController{
    
    
    @IBOutlet weak var newsListTableView: UITableView!
    
    private var newsList: [NewsModel]? {
        didSet {
            self.newsListTableView.reloadData()
        }
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.fetchNewsFromAPI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewsViewController", let destination = segue.destination as? NewsViewController {
            if let destinationViewController = segue.destination as? NewsViewController{
                destination.news = sender as? NewsModel
            }
               
        }
    }
    
    private func fetchNewsFromAPI() {
        NewsListRepository.shared.getNewsList { [weak self] news, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erro ao buscar notícias: \(error.localizedDescription)")
                    return
                }
                
                self?.newsList = news
            }
        }
    }
    
    private func setupTableView(){
        self.newsListTableView.delegate = self
        self.newsListTableView.dataSource = self
        self.newsListTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
    }
    
    
   
    
  
}
    

extension NewsListViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newsList = newsList else{
            fatalError( " Does not exist data")
        }
        performSegue(withIdentifier: "ShowNewsViewController", sender: newsList[indexPath.row])
    }
}

extension NewsListViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {
            fatalError( "Could not dequeue cell with identifier: NewsTableViewCell")
        }
        
        guard let newList = newsList else{
            fatalError( " Does not exist data")
        }
        
        cell.news = newsList?[indexPath.row]
        cell.selectionStyle = .none
    return  cell
    }
}

 

