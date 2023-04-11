//
//  Landmark.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 9.04.2023.
//

import Foundation
import MapKit

struct Landmark: Identifiable, Hashable{
    let placemark : MKPlacemark
    let id = UUID()
    
    var name: String{
        self.placemark.name ?? ""
        
    }
    
    var title: String{
        self.placemark.title ?? ""
    }
    var coordinate: CLLocationCoordinate2D{
        self.placemark.coordinate
    }
}
