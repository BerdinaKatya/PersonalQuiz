//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Екатерина Теляубердина on 08.08.2023.
//

import UIKit

final class ResultViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var descriptionResultLabel: UILabel!
    
    var answers: [Answer]!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        calculateResult()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    deinit {
        print("\(type(of: self)) has been deallocated")
    }
    
    private func calculateResult() {
        var responseCount: [Animal : Int] = [:]
        let responseAnimals = answers.map { $0.animal }
        
        for responseAnimal in responseAnimals {
            responseCount[responseAnimal] = (responseCount[responseAnimal] ?? 0) + 1
            }
         
        let responseCountSorted = responseCount.sorted { $0.value > $1.value }
        let finalAnswer = responseCountSorted.first?.key
        guard let finalAnswer = finalAnswer else { return }
        
        resultLabel.text = "Вы - \(finalAnswer.rawValue)"
        descriptionResultLabel.text = finalAnswer.definition
        }
    }

