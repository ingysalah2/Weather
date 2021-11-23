//
//  LocalStorage.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation

class LocalStorage {

    enum UserDefaultsNames: String {
        case userCitiesList
   
    }

    static var userCitiesList: [City]? {
        get { return readFromUserDefaults(name: UserDefaultsNames.userCitiesList.rawValue) }
        set { writeToUserDefaults(object: newValue, name: UserDefaultsNames.userCitiesList.rawValue) }
    }


    static func writeToUserDefaults<T: Codable>(object: T?, name: String) {
        guard let object = object else { return }
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.setValue(data, forKey: name)
        }
        catch {
            print(error)
        }
    }

    static func readFromUserDefaults<T: Codable>(name: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: name) else { return nil }
        if let object = try? JSONDecoder().decode(T.self, from: data) {
            return object
        }
        return nil
    }

}
