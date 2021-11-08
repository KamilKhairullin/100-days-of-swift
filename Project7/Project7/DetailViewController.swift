//
//  DetailViewController.swift
//  Project7
//
//  Created by Kamil on 01.11.2021.
//

import UIKit
import WebKit
// Открывается при выборе ячейки
class DetailViewController: UIViewController {

    // Веб Вью
    var webView: WKWebView!
    // Наша статья
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return  }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body {font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        // Пушим html  
        webView.loadHTMLString(html, baseURL: nil)
    }
    
}
