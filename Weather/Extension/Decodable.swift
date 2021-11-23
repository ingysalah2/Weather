//
//  Decodable.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation

extension Decodable {
    static func fromStrig(str: String) -> Self? {
        do {
            return try JSONDecoder().decode(self, from: str.data(using: .utf8)!)
        }
        catch {
            print(error)
        }
        return nil
    }

    static func fromData(data: Data) -> Self? {
        do {
          
            return try JSONDecoder().decode(self, from: data)
        }
        catch {
            print(error)
        }
        return nil
    }
}
