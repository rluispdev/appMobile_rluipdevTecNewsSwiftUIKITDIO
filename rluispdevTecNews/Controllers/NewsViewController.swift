//
//  NewsViewController.swift
//  rluispdevNews
//
//  Created by Rafael Gonzaga on 5/12/25.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newsWebView: WKWebView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    var news: NewsModel?{
        didSet {
            self.title = self.news?.source.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView() 

    }
    
    private func setupWebView(){
        self.newsWebView.navigationDelegate = self
        
        guard let news = news, let url = URL(string: news.url) else { return }
        self.newsWebView.load(URLRequest(url: url))
        self.newsWebView.allowsBackForwardNavigationGestures = true
        
    }
}

extension NewsViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadingActivityIndicator.startAnimating()
        self.loadingView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingActivityIndicator.stopAnimating()
        self.loadingView.isHidden = true
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        self.loadingActivityIndicator.stopAnimating()
        self.loadingView.isHidden = true
    }
}
