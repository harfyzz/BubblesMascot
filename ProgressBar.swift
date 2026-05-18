//
//  ProgressBar.swift
//  BubblesMascot
//
//  Created by Afeez Yunus on 16/05/2026.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 32)
                    .foregroundStyle(Color("green100"))
                RoundedRectangle(cornerRadius: 32)
                    .frame(width: geo.size.width * max(0, min(progress, 1)))
                    .foregroundStyle(Color("green500"))
                    .overlay(alignment: .trailing) {
                        HStack(spacing: 4) {
                            
                             Capsule()
                             .fill(.white.opacity(0.6))
                             .frame(width: 16, height: 4)
                             .offset(y:-1)
                             /*
                            Circle()
                                .fill(.white.opacity(0.6))
                                .frame(width: 6, height: 6)
                              */
                        }
                        .padding(.trailing, 8)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 12)
    }
}
