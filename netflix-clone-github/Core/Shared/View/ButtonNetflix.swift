//
//  ButtonNetflix.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI

import SwiftUI

struct ButtonConfigration {
    var backgroundColor: Color
    var cornerRadius: CGFloat
    var height: CGFloat
    var textConfiguration: TextConfiguration
    
    
    init(
        backgroundColor: Color = .netflixRed,
        cornerRadius: CGFloat = 4.0,
        height: CGFloat = 50.0,
        textConfiguration: TextConfiguration = .default
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.textConfiguration = textConfiguration
        self.height = height
    }
    
    struct TextConfiguration {
        let font: Font
        let fontWeight: Font.Weight
        let foregroundColor: Color
        
        init(
            font: Font = .body,
            fontWeight: Font.Weight = .bold,
            foregroundColor: Color = .white
        ) {
            self.font = font
            self.fontWeight = fontWeight
            self.foregroundColor = foregroundColor
        }
        
        static let `default` = TextConfiguration()
    }
    static let `default` = ButtonConfigration()
}

struct ButtonNetflix<Icon: View>: View {
    let configration: ButtonConfigration
    let text: String
    let icon: Icon?
    let action: () -> Void
    let disabled: Bool
    
    
    init(
        text: String,
        disabled: Bool = false,
        configuration: ButtonConfigration = .default,
        @ViewBuilder icon: () -> Icon,
        action: @escaping () -> Void,
    ) {
        self.text = text
        self.disabled = disabled
        self.configration = configuration
        self.icon = icon()
        self.action = action
    }
    
    var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    if let icon = icon {
                        icon
                    }
                    Text(text)
                        .font(configration.textConfiguration.font)
                        .fontWeight(configration.textConfiguration.fontWeight)
                        .foregroundStyle(
                            configration.textConfiguration.foregroundColor
                        )
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(
                    disabled ? configration.backgroundColor
                        .opacity(0.7) : configration
                        .backgroundColor)
                .frame(height: configration.height)
                .clipShape(.rect(cornerRadius: configration.cornerRadius))
            }
            .buttonStyle(.plain)
            .disabled(disabled)
    }
}

extension ButtonNetflix where Icon == EmptyView {
    init(
        text: String = "SIGN IN",
        configuration: ButtonConfigration = .default,
        disabled: Bool = false,
        action: @escaping () -> Void = {},
    ) {
        self.text = text
        self.configration = configuration
        self.disabled = disabled
        self.action = action
        self.icon = nil
    }
}

#Preview {
    ButtonNetflix()
}
