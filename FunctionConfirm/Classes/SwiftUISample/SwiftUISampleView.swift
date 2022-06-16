//
//  SwiftUISampleView.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/06/16.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import SwiftUI

struct SwiftUISampleView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
    }
}

struct SwiftUISampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISampleView()
    }
}
