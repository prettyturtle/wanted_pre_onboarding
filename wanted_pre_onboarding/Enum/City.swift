//
//  City.swift
//  wanted_pre_onboarding
//
//  Created by yc on 2022/06/12.
//

import Foundation

enum City: String, CaseIterable {
    case gongju
    case gwangju
    case gumi
    case gunsan
    case daegu
    case daejeon
    case mokpo
    case busan
    case seosan
    case seoul
    case sokcho
    case suwon
    case suncheon
    case ulsan
    case iksan
    case jeonju
    case jeju
    case cheonan
    case cheongju
    case chuncheon
    
    var text: String {
        
        switch self {
        case .gongju: return "공주"
        case .gwangju: return "광주"
        case .gumi: return "구미"
        case .gunsan: return "군산"
        case .daegu: return "대구"
        case .daejeon: return "대전"
        case .mokpo: return "목포"
        case .busan: return "부산"
        case .seosan: return "서산"
        case .seoul: return "서울"
        case .sokcho: return "속초"
        case .suwon: return "수원"
        case .suncheon: return "서천"
        case .ulsan: return "울산"
        case .iksan: return "익산"
        case .jeonju: return "전주"
        case .jeju: return "제주"
        case .cheonan: return "천안"
        case .cheongju: return "청주"
        case .chuncheon: return "춘천"
        }
    }
}
