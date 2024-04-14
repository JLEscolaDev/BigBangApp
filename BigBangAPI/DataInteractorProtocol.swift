//
//  DataInteractor.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import Foundation

protocol DataInteractorProtocol {
    func loadData<MODEL: Decodable>() throws -> [MODEL]
    func saveData<MODEL: Encodable>(data: [MODEL]) throws
}
