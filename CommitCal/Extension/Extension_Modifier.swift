//
//  Extension_View.swift
//  CommitCal
//
//  Created by apple on 3/3/24.
//

import SwiftUI

struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.text)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.subBackground)
                RoundedRectangle(cornerRadius: 8)
                    .stroke()
            }
    }
}
