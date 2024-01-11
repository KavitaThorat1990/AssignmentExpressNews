//
//  NewsTitleView.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 10/01/24.
//

import SwiftUI

struct NewsTitleView: View {
    var title: String
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(5)
        }
        .background(Color.white.opacity(0.5))
    }
}

#Preview {
    NewsTitleView(title: "News Title")
}
