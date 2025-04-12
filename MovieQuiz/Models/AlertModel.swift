//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Анастасия  Колгушкина  on 15.03.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)
}
