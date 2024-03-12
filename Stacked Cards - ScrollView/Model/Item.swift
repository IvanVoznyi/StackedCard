//
//  Item.swift
//  Stacked Cards - ScrollView
//
//  Created by Ivan Voznyi on 09.03.2024.
//

import SwiftUI

struct Item: Identifiable {
    var id: UUID = .init()
    var color: Color
}

var items: [Item] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .pink),
    .init(color: .purple)
]

extension [Item] {
    func zindex(_ item: Item) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id }) {
            ///this code creates a zIndex in reverse order. This means that the first zIndex will be the last index of the array index, and the last zIndex will be the index of the first element in the array.
            
            ///items.count = 6
            ///1 item. zIndex = 6.0
            ///2 item. zIndex = 5.0
            ///3 item. zIndex = 4.0
            ///4 item. zIndex = 3.0
            ///5 item. zIndex = 2.0
            ///6 item. zIndex = 1.0
            return CGFloat(count) - CGFloat(index)
        }
        
        return .zero
    }
}
