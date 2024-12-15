//
//  Utils.swift
//  MoodJournal
//
//  Created by Brenda Pham on 12/4/24.
//

import Foundation
import UIKit
import SwiftUI


// Key for User Name User Default
let userNameKey = "userName"


// Format Date object to `Month Day, Year` format
extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
}


// Convert SwiftUI Color to UIColor -> UIColor(from: Color)
extension UIColor {
    convenience init?(from color: Color) {
        let uiColor: UIColor
        if let cgColor = color.cgColor {
            uiColor = UIColor(cgColor: cgColor)
        } else {
            // Use UIColor initializer for SwiftUI Colors
            let uiView = UIHostingController(rootView: Rectangle().foregroundColor(color))
            uiColor = uiView.view.backgroundColor ?? .clear
        }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


// Convert Data to SwiftUI Image
func convertDataToImage(_ data: Data) -> Image {
    let uiImageFromData = UIImage(data: data)
    let result = Image(uiImage: (uiImageFromData ?? .none)!)
    return result
}


// Returns height of any View
struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}


// Convert string date format "YYYY-MM" to "Month Year"
func convertDateToMonthYear(_ dateString: String) -> String? {
    // Define the input date format
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM"
    
    // Parse the input string into a Date object
    guard let date = inputFormatter.date(from: dateString) else {
        print("Invalid date format")
        return nil
    }
    
    // Define the output date format
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMMM yyyy"
    
    // Convert the Date object to the desired format
    let formattedDate = outputFormatter.string(from: date)
    return formattedDate
}

