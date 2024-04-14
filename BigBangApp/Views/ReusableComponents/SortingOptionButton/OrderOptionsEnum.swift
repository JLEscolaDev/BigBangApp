//
//  File.swift
//  BigBangApp
//
//  Created by Jose Luis Escolá García on 14/4/24.
//

import Foundation

enum OrderOptionsEnum: String, CaseIterable, Identifiable {
    case bySeasonAsc = "Season (Ascendent)"
    case bySeasonDes = "Season (Descendent)"
    case byTitleAsc = "Title (Ascendent)"
    case byTitleDes = "Title (Descendent)"
    case byYearAsc = "Year (Ascendent)"
    case byYearDes = "Year (Descendent)"
    
    var id: Self { self }
}
