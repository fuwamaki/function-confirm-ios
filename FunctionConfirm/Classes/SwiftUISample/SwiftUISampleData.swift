//
//  SwiftUISampleData.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/06/16.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import Foundation

class SwiftUISampleData: ObservableObject {
    @Published var name: String
    @Published var isFavorited: Bool
    
    init(name: String, isFavorited: Bool) {
        self.name = name
        self.isFavorited = isFavorited
    }
    
    var favoriteImageName: String {
        isFavorited ? "heart.fill" : "heart"
    }
}
