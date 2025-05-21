//
//  SystemExtensions.swift
//  rluispdevNews
//
//  Created by Rafael Gonzaga on 5/9/25.
//

import UIKit


extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(named: "no-image.png")
                }
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
        .resume()
    }
    
    func loadImage(from link: String?, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let link = link, let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: contentMode)
    }
}


extension Date{
    func toString(with formatter: String = "dd/MM/yyyy") -> String?{
        let dateFormat = DateFormatter()
        
        if Calendar.current.isDateInToday(self){
            dateFormat.dateFormat = "HH:mm"
            dateFormat.locale = Locale(identifier: "pt_BR")
            dateFormat.timeZone = TimeZone(abbreviation: "UTC-3")
            return "Hoje às \(dateFormat.string(from: self))"
        }
        
        dateFormat.dateFormat = formatter
        return dateFormat.string(from: self)
    }
}
