//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Анастасия  Колгушкина  on 13.04.2025.
//

import Foundation

// Расширяем при объявлении
final class StatisticService: StatisticServiceProtocol {
    
    private enum Keys:String {
         case gamesCount
         case bestGameCorrect
         case bestGameTotal
         case bestGameDate
         case totalCorrectAnswers
     }
    
    private let storage: UserDefaults = .standard
    
    var gamesCount: Int {
        get {
           return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date )
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalGames = storage.integer(forKey: Keys.gamesCount.rawValue)
        let correctAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        if totalGames == 0 { return 0.0}
        
        return Double(correctAnswers * 100)/Double(totalGames * 10)
    }
    
  
    func store(correct count: Int, total amount: Int) {
        if count > self.bestGame.correct {
             let newBestGame = GameResult(correct: count, total: amount, date: Date())
             bestGame = newBestGame
         }
        let totalCorrectAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(totalCorrectAnswers + count, forKey: Keys.totalCorrectAnswers.rawValue)
        let totalGames = gamesCount
        storage.set(totalGames, forKey: Keys.gamesCount.rawValue)    }
}
