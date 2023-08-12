//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Екатерина Теляубердина on 08.08.2023.
//

import UIKit

final class QuestionsViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multioleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedSlider: UISlider!
    @IBOutlet var rangedLables: [UILabel]!
    
    // MARK: - Private Properties
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answerChosen: [Answer] = []
    private var curentAnswers: [Answer] {
        questions[questionIndex].answers
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       updateUI()
        let answerCount = Float(curentAnswers.count - 1)
        rangedSlider.maximumValue = answerCount
        rangedSlider.value = answerCount / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        resultVC.answers = answerChosen
    }

    // MARK: - IB Actions
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = curentAnswers[buttonIndex]
        answerChosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, curentAnswers) {
            if multipleSwitch.isOn {
                answerChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answerChosen.append(curentAnswers[index])
        nextQuestion()
    }
    
    deinit {
        print("\(type(of: self)) has been deallocated")
    }
}

// MARK: - Private Methods
private extension QuestionsViewController {
    func updateUI() {
        // Hide everything
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // Set navigation title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // Get current question
        let currentQuestion = questions[questionIndex]
        
        // Set current question for question label
        questionLabel.text = currentQuestion.titile
        
        // Calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress for question progress view
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // Show stackes corresponding to question type
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    
    /// Choice of answers category
    ///
    /// Displaying answers to a questuions according to a category
    ///
    /// - Parameter type: Specifies the category of responses
    func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: curentAnswers)
        case .multiple: showMultipleStackView(with: curentAnswers)
        case .range: showRangeStackView(with: curentAnswers)
        }
    }
    
    func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multioleLabels, answers) {
            label.text = answer.title
        }
    }
    
    func showRangeStackView(with answers: [Answer]) {
        rangedStackView.isHidden.toggle()
        
        rangedLables.first?.text = answers.first?.title
        rangedLables.last?.text = answers.last?.title
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}
