import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

                    
    private var currentQuestionIndex = 0
    private var correctAnswer = 0
    private var isShowingResult = false
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?

    private var currentQuestion: QuizQuestion? 
    private var statisticService: StatisticServiceProtocol = StatisticService()
    override func viewDidLoad() {
        super.viewDidLoad()

        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        if !isShowingResult {
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
        if !isShowingResult {

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
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки не скрыт
        activityIndicator.stopAnimating() // включаем анимацию
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
      //  let model = AlertModel(title: "Ошибка",
       //                        message: message,
       //                        buttonText: "Попробовать еще раз") { [weak self] in
       //     guard let self = self else { return }
            
       //     self.currentQuestionIndex = 0
      //      self.correctAnswer = 0
      ///
        //    self.questionFactory?.requestNextQuestion()
       // }
        
        //model.ShowAlert(in: self, model: model)
        
        //let text = "Ваш результат"
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать еще раз", style: .default) {
            [weak self] _ in
            guard let self = self else { return }
            self.correctAnswer = 0
            self.currentQuestionIndex = 0
            self.questionFactory?.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
            guard let self else { return }
            self.showNextQuestionOrResults()
        }
    }
        
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        isShowingResult = false
        if currentQuestionIndex == questionsAmount - 1 {
                 statisticService.store(correct: correctAnswer, total: questionsAmount)
                 statisticService.gamesCount += 1
                 
            let text = "Ваш результат: \(correctAnswer)/\(questionsAmount) \n Количество сыграных квизов: \(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: text,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Сыграть еще раз", style: .default) {
                [weak self] _ in
                guard let self = self else { return }
                self.correctAnswer = 0
                self.currentQuestionIndex = 0
                self.questionFactory?.requestNextQuestion()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
        currentQuestionIndex += 1
        self.questionFactory?.requestNextQuestion()
      }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
            questionFactory?.requestNextQuestion()
        
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
        
    }
}


