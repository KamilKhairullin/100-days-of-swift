//
//  Petition.swift
//  Project7
//
//  Created by Kamil on 01.11.2021.
//

import Foundation

// Хранит данные о статье
// Тайтл, который выводится в списке и текст внутри ячейки
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
