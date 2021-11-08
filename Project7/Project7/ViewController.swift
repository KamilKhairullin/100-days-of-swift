//
//  ViewController.swift
//  Project7
//
//  Created by Kamil on 01.11.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    // Массив наших статей
    var petitions = [Petition]()
    var allPetitions = [Petition]()
    
    // Переписываем метод, говорим, что в нашем тейбле будет количество строк, равное длине partitions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    // говорим, что для ячейки под каждым номером
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Создается ячейка типа dequeReusable(оптимизированная) для конкретного индекса
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Ставится тайтл и сабтайтл

        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        // Превью текста в ячейке
        cell.detailTextLabel?.text = petition.body
        // возвращаем cell
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showDataInfo))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(getSearchQuery))
        
        // Берем юрл с данными
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        //Если сможем забрать дату, вызываем парс
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                return
            }
        } else {
            showError()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    // приходит json
    func parse(json: Data) {
        let decoder = JSONDecoder()
        // декодим json
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            // добавляем в petitions
            petitions = jsonPetitions.results
            allPetitions = petitions
            tableView.reloadData()
        }
    }

    // Что происходит при выборе ячейки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // создаем вьюконтроллер
        let vc = DetailViewController()
        // выбираем нужную статью
        vc.detailItem = petitions[indexPath.row]
        // пушим вьюшку с нужной статьей
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func getSearchQuery() {
        let ac = UIAlertController(title: "Enter word to find", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let query = ac?.textFields?[0].text else { return }
            self?.searchAndUpdate(query)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func searchAndUpdate(_ query: String) {
        if query == "" { petitions = allPetitions } else {
            petitions = []
            for petition in allPetitions {
                if petition.title.contains(query) || petition.body.contains(query) {
                    petitions.append(petition)
                }
            }
        }
        tableView.reloadData()
    }
    @objc func showDataInfo() {
        let ac = UIAlertController(title: "Author info", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}
