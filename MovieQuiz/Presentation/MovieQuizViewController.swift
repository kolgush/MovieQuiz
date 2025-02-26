import UIKit

final class MovieQuizViewController: UIViewController {

    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion (
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion (
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion (
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion (
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion (
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion (
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion (
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion (
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion (
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion (
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }
                    
    private var currentQuestionIndex = 0
    
    private var correctAnswer = 0
    
    private var isShowingResult = false
    
    @IBOutlet private var imageView: UIImageView!

    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var counterLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameStarting()
    }
    private func gameStarting() {
        correctAnswer = 0
        currentQuestionIndex = 0
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestion)
        show (quiz: viewModel)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        if (!isShowingResult) {
            
            if questions[currentQuestionIndex].correctAnswer {
                showAnswerResult(isCorrect: true)
            }
            else {
                showAnswerResult(isCorrect: false)
            }
        }
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        if (!isShowingResult) {
            if !questions[currentQuestionIndex].correctAnswer {
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
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
        
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        isShowingResult = false
      if currentQuestionIndex == questions.count - 1 {
          let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: "Ваш результат - \(correctAnswer) из \(questions.count)",
            preferredStyle: .alert)
          
          let action = UIAlertAction(title: "Сыграть еще раз", style: .default) {
              _ in self.gameStarting ()
          }
          
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
      } else {        
        currentQuestionIndex += 1
        let nextQuistion = questions[currentQuestionIndex]
        let viewModel = convert(model: nextQuistion)
          
        show(quiz: viewModel)
      }
    }
}


