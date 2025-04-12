//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Анастасия  Колгушкина  on 15.03.2025.
//

import Foundation
import UIKit

class AlertPresenter {
    func ShowAlert (viewController: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default){
            _ in model.completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
