//
//  LocalDataInteractor.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import Foundation

protocol DevelopmentConfigurable {
    var jsonFileName: String { get }
}

struct LocalDataInteractor: DataInteractorProtocol {
    let jsonFileName: String
    
    init(for developmentPhase: DevelopmentConfigurable) {
        self.jsonFileName = developmentPhase.jsonFileName
    }
    
    var urlDoc: URL {
        if #available(iOS 16.0, *) {
            return URL.documentsDirectory.appending(path: "\(jsonFileName).json")
        } else {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }
    
    /// Generic func that tries to access documents filePath to find the JSON file. If it does not exist, it will search the JSON from app bundle.
    ///
    /// This function is only used if we are using a different model for DTO (from back) and for display (the one we use in the app).
    ///
    /// If you only use a simple model to load and save data, use `loadData()`
    ///
    /// ⚠️ Remember to make your DTO conform to ModelConvertible.
    func loadDataFromDTO<DTO: Decodable & ModelConvertible, Model: Decodable>(type: DTO.Type) throws -> [Model] where DTO.ModelType == Model {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent("\(jsonFileName).json")

        let data: Data
        if fileManager.fileExists(atPath: filePath.path) {
            data = try Data(contentsOf: filePath)
            return try JSONDecoder().decode([Model].self, from: data)
        } else {
            guard let bundleURL = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
                throw NSError(domain: "LoadDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Resource file not found."])
            }
            data = try Data(contentsOf: bundleURL)
            // Decode the data into DTO objects
            let dtos = try JSONDecoder().decode([DTO].self, from: data)
            // Convert and return the array of models.
            return dtos.map { $0.toModel() }
        }
    }

    /// Generic func that tries to access documents filePath to find the JSON file. If it does not exist, it will search the JSON from app bundle.
    func loadData<MODEL: Decodable>() throws -> [MODEL] {
        if FileManager.default.fileExists(atPath: urlDoc.path()) {
            let data = try Data(contentsOf: urlDoc)
            return try JSONDecoder().decode([MODEL].self, from: data)
        } else {
            guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else { return [] }
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([MODEL].self, from: data)
        }
    }
    
    func saveData<MODEL: Encodable>(data: [MODEL]) throws {
        let data = try JSONEncoder().encode(data)
        do {
            try data.write(to: urlDoc, options: .atomic)
        }catch {
            print("🚩 NO SE HA PODIDO GUARDAR EL JSON")
        }
    }
}
