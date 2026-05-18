//
//  ExperienceLevelPicker.swift
//  BubblesMascot
//
//  Created by Afeez Yunus on 17/05/2026.
//

import SwiftUI

protocol PickerOption: Hashable, CaseIterable {
    var title: String { get }
    var subtitle: String { get }
    func imageName(isSelected: Bool) -> String
}

struct OptionPicker<Option: PickerOption>: View {
    @Binding var selection: Option?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(Option.allCases), id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    OptionRow(option: option, isSelected: selection == option)
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
}

private struct OptionRow<Option: PickerOption>: View {
    let option: Option
    let isSelected: Bool
    
    var body: some View {
        HStack {
            ZStack{
                Image(option.imageName(isSelected: isSelected))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 66, height: 66)
            }
           // .background(.white)
            VStack(alignment: .leading, spacing:6) {
                Text(option.title)
                    .foregroundStyle(Color(isSelected ? "blueTitle" : "gray600"))
                    .font(.headline)
                    .fontWeight(.medium)
                Text(option.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color(isSelected ? "blueBody" : "gray400"))
            }
            Spacer()
        }
        
       // .padding(4)
        .padding(.trailing, 8)
        .background(Color(isSelected ? "blueBg" : "gray100"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color("blueBorder") : .clear, lineWidth: 1.5)
        )
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
    }
}

typealias ExperienceLevelPicker = OptionPicker<ExperienceLevel>

enum ExperienceLevel: String, CaseIterable, PickerOption {
    case beginner
    case novice
    case intermediate
    case advanced
    
    var title: String {
        rawValue.capitalized
    }
    
    var subtitle: String {
        switch self {
        case .beginner: "I want to start from the basics"
        case .novice: "I've seen, but not touched code before"
        case .intermediate: "I can write simple programs with loops"
        case .advanced: "I've written longer programs"
        }
    }
    
    func imageName(isSelected: Bool) -> String {
        "\(rawValue)\(isSelected ? "True" : "False")"
    }
}

#Preview {
    OptionPicker<ExperienceLevel>(selection: .constant(.beginner))
        .padding()
}

