//
//  ModernRests.swift
//  Eateries
//
//  Created by Виталий Охрименко on 08/01/2019.
//  Copyright © 2019 Ivan Akulov. All rights reserved.
//

import Foundation
import UIKit

class ModernRests {
    
    var restaraunt: Restaurant?
    
    static func lala(name: String, location: String, type: String, isVisited: Bool, isFavourite: Bool, averageCheck: String, image: UIImage, isPhoto: Bool, star: Double ) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext else { return }
        
        let restaurant = Restaurant(context: context)
        restaurant.name = name.capitalized
        restaurant.location = location.capitalized
        restaurant.type = type.capitalized
        restaurant.isVisited = isVisited
        restaurant.isFavourite = isFavourite
        restaurant.averageCheck = averageCheck
        restaurant.image = image.pngData()
        restaurant.star = star
    
    do {
    try context.save()
    }
    catch let error as NSError{
    print ("Не удалось сохранить данные \(error.localizedDescription)")
    }
}



}
