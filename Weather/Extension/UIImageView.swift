//
//  UIImageView.swift
//  Weather
//
//  Created by Ingy Salah on 11/22/21.
//

import Foundation
import UIKit

extension UIImageView {

    func downloaded(from urlString: String) {
        guard let imageUrl = URL(string: urlString) else { return }
        var req = URLRequest(url: imageUrl)
        req.httpMethod = "GET"
        let dataTask = Http.shared.makeNewRequest(req: req) { data in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
            
        } failure: { error in
        }
        dataTask.resume()
        
    }

}
