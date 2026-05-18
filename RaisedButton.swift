//
//  RaisedButton.swift
//  BubblesMascot
//
//  Created by Afeez Yunus on 16/05/2026.
//

import SwiftUI

struct RaisedButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    @State private var isPressed = false
    
    init(_ title: String, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        ZStack {
            Text(title)
                .offset(y: isDisabled || isPressed ? 0 : 4)
                .frame(width: 321, height: 54)
                .foregroundStyle(Color(isDisabled ? "gray400" : "gray100"))
                .fontWeight(.medium)
                .font(.subheadline)
                .background(Color(isDisabled ? "gray200" : (isPressed ? "gray800" : "gray700")))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onTapGesture {
                    if !isDisabled { action() }
                }
                .offset(y: isDisabled || isPressed ? 0 : -8)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in if !isDisabled { isPressed = true } }
                        .onEnded { _ in isPressed = false }
                )
        }
        .background(Color(isDisabled ? "gray200" : "gray900"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
