import UIKit

final class MovieQuizViewController: UIViewController {

                    
    private var currentQuestionIndex = 0
    private var correctAnswer = 0
    private var isShowingResult = false
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
       // let firstQuestion = questions[currentQuestionIndex]
       // let viewModel = convert(model: currentQuestion)
        //show (quiz: viewModel)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        if (!isShowingResult) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            if currentQuestion.correctAnswer {
                showAnswerResult(isCorrect: true)
            }
            else {
                showAnswerResult(isCorrect: false)
            }
        }
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        if (!isShowingResult) {
            // было
           // let currentQuestion = questions[currentQuestionIndex]

            // стало
            guard let currentQuestion = currentQuestion else {
                return
            }
            if !currentQuestion.correctAnswer {
                showAnswerResult(isCorrect: true)
            }
            else {
                showAnswerResult(isCorrect: false)
            }
        }
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    private func showAnswerResult(isCorrect: Bool) {
        isShowingResult = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor :
        UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswer += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return } 
            self.showNextQuestionOrResults()
        }
    }
        
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        isShowingResult = false
        if currentQuestionIndex == questionsAmount - 1 {
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: "Ваш результат - \(correctAnswer) из \(questionsAmount)",
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Сыграть еще раз", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.correctAnswer = 0
                self.currentQuestionIndex = 0
                //  let currentQuestion = self.questions[self.currentQuestionIndex]
                //  let viewModel = self.convert(model: currentQuestion)
                // self.show (quiz: viewModel)
                
                if let nextQuestion = questionFactory.requestNextQuestion() {
                    currentQuestion = nextQuestion
                    let viewModel = convert(model: nextQuestion)
                    show(quiz: viewModel)
                }
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
        currentQuestionIndex += 1
      //  let nextQuistion = questions[currentQuestionIndex]
      //  let viewModel = convert(model: nextQuistion)
          
       // show(quiz: viewModel)
          
            if let nextQuistion = questionFactory.requestNextQuestion() {
                currentQuestion = nextQuistion
                let viewModel = convert(model: nextQuistion)
                show(quiz: viewModel)
            }
      }
    }
}


