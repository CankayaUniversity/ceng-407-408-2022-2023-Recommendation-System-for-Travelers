//
//  MKCoordinateRegion+Extensions.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 9.04.2023.
//

import Foundation
import MapKit

extension MKCoordinateRegion{
    
    static func defaultRegion() -> MKCoordinateRegion{
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -122), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
    }
    
    static func regionFromLandmark(_ landmark: Landmark) -> MKCoordinateRegion{
        MKCoordinateRegion(center: landmark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
    }
}
