//
//  FeedModel.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import Foundation
import UIKit
import SwiftUI

struct FeedResponeModel: Codable {
    let slug: String
    let cards: [CardGroupModel]
    
    enum CodingKeys: String, CodingKey {
        case slug = "slug"
        case cards = "hc_groups"
    }
}

struct CardGroupModel: Codable, Identifiable {
    let id: Int
    let name: String
    let card_type: Int
    let design_type: CardDesignTypes
    let cards: [CardModel]?
    let is_scrollable: Bool
    let height: Double?
    let is_full_width: Bool
    let slug: String?
    let icon_size: Double?
    
    var cardUniqueID = UUID().uuidString
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case card_type
        case design_type
        case is_scrollable
        case is_full_width
        case slug
        case height
        case cards
        case icon_size
    }
}

enum CardDesignTypes: String, Codable {
    case smallDisplayCard = "HC1"
    case bigDisplayCard = "HC3"
    case imageCard = "HC5"
    case smallCardWithArrow = "HC6"
    case dynamicWidthCard = "HC9"
    case unsupported
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let designType = try container.decode(String.self)
        if let validDesignType = CardDesignTypes(rawValue: designType) {
            self = validDesignType
        } else {
            self = .unsupported
        }
    }
}

struct CardModel: Codable, Identifiable {
    let id: Int
    let name: String?
    let slug: String?
    let title: String?
    let url: String?
    let formatted_title: Formatted_title?
    let formatted_description: Formatted_title?
    let bg_image: Bg_image?
    let bg_gradient: Bg_gradient?
    let cta: [Cta]?
    let icon: icon?
    let bg_color: String?
    let components: [String]?
    let is_disabled: Bool
    let is_shareable: Bool
    let is_internal: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case slug = "slug"
        case title = "title"
        case formatted_title = "formatted_title"
        case formatted_description = "formatted_description"
        case components = "components"
        case url = "url"
        case bg_image = "bg_image"
        case bg_gradient = "bg_gradient"
        case cta = "cta"
        case is_disabled = "is_disabled"
        case is_shareable = "is_shareable"
        case is_internal = "is_internal"
        case icon = "icon"
        case bg_color = "bg_color"
    }
}

struct icon: Codable {
    let image_type: String?
    let image_url: String?
    let webp_image_url: String?
    let aspect_ratio: Double?
}

struct Bg_gradient: Codable {
    let angle: Int
    let colors: [String]
    
    enum CodingKeys: String, CodingKey {
        case angle = "angle"
        case colors = "colors"
    }
}

struct Bg_image: Codable {
    let image_type: String?
    let image_url: String?
    let webp_image_url: String?
    let aspect_ratio: Double?
    
    enum CodingKeys: String, CodingKey {
        case image_type = "image_type"
        case image_url = "image_url"
        case webp_image_url = "webp_image_url"
        case aspect_ratio = "aspect_ratio"
    }
}

struct Cta: Codable {
    let text: String
    let type: String?
    let bg_color: String?
    let is_circular: Bool?
    let is_secondary: Bool?
    let stroke_width: Int?
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case type = "type"
        case bg_color = "bg_color"
        case is_circular = "is_circular"
        case is_secondary = "is_secondary"
        case stroke_width = "stroke_width"
    }
}

struct Formatted_title: Codable {
    let text: String
    let entities: [Entities]
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case entities = "entities"
    }
    
    func isValid() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: #"\{\}"#, options: [])
            let matchCount = regex.matches(in: text, options: [], range: .init(location: 0, length: text.count))
            return matchCount.count == entities.count
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    func updateEntities() -> [Entities] {
        
        if !isValid() {
            return [Entities(text: text, color: nil, font_size: nil)]
        }
        
        var entitiesCopy = entities
        var newEntities: [Entities] = []
        
        let tokens = text.components(separatedBy: "\n")
        
        for (index, token) in tokens.enumerated() {
            if token == "{}" && !entitiesCopy.isEmpty {
                var currentEntity = entitiesCopy.removeFirst()
                currentEntity.text! += (index == tokens.count - 1 ? "" : " ")
                newEntities.append(currentEntity)
            } else {
                let spacedToken = token + (index == tokens.count - 1 ? "" : " ")
                newEntities.append(Entities(text: spacedToken, color: nil, font_size: nil))
            }
        }
        
        return newEntities
    }
    
}

struct Entities: Codable, Identifiable, Hashable {
    var text: String?
//    let type: String?
    let color: String?
    let font_size: Int?
//    let font_style: String?
//    let font_family: String?
    
    var id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
//        case type = "type"
        case color = "color"
        case font_size = "font_size"
//        case font_style = "font_style"
//        case font_family = "font_family"
    }
    
    init(text: String, color: String?, font_size: Int?) {
        self.text = text
        self.color = color
        self.font_size = font_size
    }
    
}
