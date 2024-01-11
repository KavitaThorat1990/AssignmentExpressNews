//
//  NewsCategoryHeader.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 31/12/23.
//

import SwiftUI

struct NewsCategoryHeader: View {
    var title: String
    var seeAllAction: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()

            Button(action: {
                seeAllAction()
            }) {
                Text(Constants.ButtonTitles.seeAll)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    NewsCategoryHeader(title: "Technology", seeAllAction: {})
}
