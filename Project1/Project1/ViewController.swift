//
//  ViewController.swift
//  Project1
//
//  Created by Kamil on 28.09.2021.
//

import UIKit

class ViewController: UITableViewController {

    private var pictures: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        // The system thing to work with file system
        let fm = FileManager.default
        
        // Our compiling directory
        let path = Bundle.main.resourcePath!
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            // Get all items from compiling directory
            let items = try! fm.contentsOfDirectory(atPath: path)
            for item in items {
                if item.hasPrefix("nssl") {
                    self?.pictures.append(item)
                }
            }
            self?.pictures.sort()
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // Приходит таблица и номер ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Создается ячейка типа dequeReusable(оптимизированная) для конкретного индекса
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // Берется название картинки по номеру индекса (они совпадают)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    // При выборе ячейки что мы делаем? Написано тут
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Создаем новый ViewController (с картинкой)
        // В сториборде мы указали, что наш DetailVievController имеет Storyboard ID "Detail", тут мы можем обращаться к нему.
        // Мы должны сделать тайпкастинг, потому что по дефолту он вернет UIViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // внутри DetailViewController есть премененная, которую надо заредефайнить
            vc.selectedImage = pictures[indexPath.row]
            vc.imagePosition = indexPath.row + 1
            vc.totalNumberOfImages = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

