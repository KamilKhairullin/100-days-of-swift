//
//  ViewController.swift
//  Day41Challenge
//
//  Created by Kamil on 08.11.2021.
//

import UIKit

class ViewController: UIViewController {
    var word: UILabel!
    var mistakes: UILabel!
    var letterButtons = [UIButton]()
    var solution: String!
    var level = 1
    var levels: [String] = ["AFTERMATH", "KING", "SLAYER"]
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        word = UILabel()
        word.translatesAutoresizingMaskIntoConstraints = false
        word.font = UIFont.systemFont(ofSize: 32)
        word.textAlignment = .center
        word.numberOfLines = 0
        word.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        view.addSubview(word)
//        solution.forEach { _ in
//            word.text?.append("?")
//        }
//        word.text = ""
//        mistakes.text = "❤️❤️❤️❤️❤️❤️"
        
        mistakes = UILabel()
        mistakes.translatesAutoresizingMaskIntoConstraints = false
        mistakes.font = UIFont.systemFont(ofSize: 32)
        mistakes.numberOfLines = 0
        mistakes.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        view.addSubview(mistakes)
        loadLevel()
        
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
    
        let buttonsWidth = UIScreen.main.bounds.width

        let buttonsHeight = buttonsWidth * 4 / 7
        let width = Int(buttonsWidth / 7)
        let height = width
        
        print(buttonsWidth, buttonsHeight)
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        var row = 0
        var column = 0
        
        alphabet.forEach { letter in
            let letterButton = UIButton(type: .system)
            letterButton.layer.borderWidth = 1
            letterButton.layer.borderColor = UIColor.lightGray.cgColor
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
            letterButton.setTitle(String(letter), for: .normal)
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
           
            let frame = CGRect(x: column*width, y: row*height, width: width, height: height)
            letterButton.frame = frame
            buttonsView.addSubview(letterButton)
            letterButtons.append(letterButton)
            
            column += 1
            if column == 7 {
                column = 0
                row += 1
            }
        }

        
        NSLayoutConstraint.activate([
            word.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            word.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 5),
            word.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5, constant: -10),
            
            mistakes.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            mistakes.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -5),
            mistakes.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5, constant: -10),
            mistakes.heightAnchor.constraint(equalTo: word.heightAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: buttonsWidth),
            buttonsView.heightAnchor.constraint(equalToConstant: buttonsHeight),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: word.bottomAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    @objc private func letterTapped(_ sender: UIButton) {
        guard
            let buttonTitle = sender.titleLabel?.text,
            let text = word.text,
            let solutionString = solution
        else { return }
        
        if solution.contains(buttonTitle) {
            sender.isEnabled = false
            let sol = solutionString.map { String($0) == buttonTitle ? $0 : "?" }
            word.text = String(text.enumerated().map {(index, element) in String(element) == "?" ? sol[index] : element})
        } else {
            mistakes.text?.removeLast()
        }
        
        if mistakes.text?.count == 0 {
            let ac = UIAlertController(title: "You lost.", message: "Try again?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: restartLevel))
            present(ac, animated: true)
        } else if solution == word.text {
            let ac = UIAlertController(title: "You won!", message: "Are u ready for the next level?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
    }
    
    func restartLevel(action: UIAlertAction) {
        for button in letterButtons {
            button.isEnabled = true
        }
        
        word.text = ""
        solution.forEach { _ in
            word.text?.append("?")
        }
        mistakes.text = "❤️❤️❤️❤️❤️❤️"
    }
    
    func levelUp(action: UIAlertAction){
        level += 1
        
        loadLevel()
        
        for button in letterButtons {
            button.isEnabled = true
        }
    }
    
    func loadLevel() {
        solution = levels[level - 1]
        word.text = ""
        solution.forEach { _ in
            word.text?.append("?")
        }
        mistakes.text = "❤️❤️❤️❤️❤️❤️"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

