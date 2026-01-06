//
//  VerificationField.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 02/01/26.
//

import SwiftUI


struct VerificationField: View {
    var type: CodeType
    var style: TextFieldStyle = .rounderBorder
    @Binding var isInValid: Bool
    var isLoading: Bool = false
    var onChange: (_ value: String) -> Void
    var onComplete: (_ value: String) async -> Void
    var configuration: VerificationFieldConfiguration = .default
    
    @State private var value: String = ""
    @State private var state: TypingState = .typing
    @State private var invalidTrigger: Bool = false
    @FocusState private var isActive: Bool
    @State private var hasCompleted: Bool = false
    
    var body: some View {
        HStack(
            spacing: style == .rounderBorder ? configuration.sizes.spacing : configuration.sizes.underlineSpacing
        ) {
            ForEach(0..<type.rawValue, id: \.self) { i in
                CharacterView(i)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: value)
        .animation(.easeInOut(duration: 0.2), value: isActive)
        .compositingGroup()
        // Invalid Phase Animator
        .phaseAnimator([0, 10, -10, 10, -5, 5, 0], trigger: invalidTrigger, content: { content, offset in
            content.offset(x: offset)
        }, animation: { _ in
                .linear(duration: 0.06)
        })
        .background {
            TextField("", text: $value)
                .focused($isActive)
                .keyboardType(.numberPad)
                .foregroundStyle(isLoading ? .gray.opacity(0.5) : .black)
                .mask(alignment: .trailing) {
                    Rectangle()
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                }
                .allowsHitTesting(false)
                .disabled(isLoading)
        }
        .contentShape(.rect)
        .onTapGesture {
            isActive = true
        }
        .onChange(of: isInValid, { oldValue, newValue in
            if newValue {
                state = .invalid
                hasCompleted = false
                if state == .invalid {
                    invalidTrigger.toggle()
                }
            }
        })
        .onChange(of: value) { oldValue, newValue in
            let trimmedValue = String(newValue.prefix(type.rawValue))
            
            if value != trimmedValue {
                value = trimmedValue
            }
            
            Task { @MainActor in
                if trimmedValue.count < type.rawValue {
                    onChange(trimmedValue)
                    state = .typing
                    hasCompleted = false
                } else if value.count == type.rawValue {
                    if !hasCompleted {
                        hasCompleted = true
                        state = .valid
                        onChange(trimmedValue)
                        await onComplete(trimmedValue)
                    }
                } else {
                    state = .invalid
                }
            }
        }
        
    }
    
    // MARK: - Computed Properties
       private var spacing: CGFloat {
           style == .rounderBorder
               ? configuration.sizes.spacing
               : configuration.sizes.underlineSpacing
       }
       
       private var textColor: Color {
           isLoading
               ? configuration.colors.loadingText
               : configuration.colors.text
       }
       
       private var fieldWidth: CGFloat {
           style == .rounderBorder
               ? configuration.sizes.fieldWidth
               : configuration.sizes.fieldWidth - 10
       }
    
    @ViewBuilder
    func CharacterView(_ index: Int) -> some View {
        Group {
            if style == .rounderBorder {
                RoundedRectangle(cornerRadius: configuration.borders.cornerRadius)
                    .stroke(
                        borderColor(index),
                        lineWidth: configuration.borders.width
                    )
            } else {
                Rectangle()
                    .fill(borderColor(index))
                    .frame(height: configuration.borders.underlineHeight)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(width: fieldWidth, height: configuration.sizes.fieldHeight)
        .overlay {
            let stringValue = string(index)
            
            if stringValue != "" {
                Text(stringValue)
                    .font(configuration.typography.font)
                    .fontWeight(configuration.typography.fontWeight)
                    .transition(.blurReplace)
                    .foregroundStyle(textColor)
                    .transition(.blurReplace)
                    .disabled(isLoading)
            }
        }
    }
    
    func string(_ index: Int) -> String {
        if value.count > index {
            let startIndex = value.startIndex
            let stringIndex = value.index(startIndex, offsetBy: index)
            
            return String(value[stringIndex])
        }
        
        return ""
    }
    
    func borderColor(_ index: Int) -> Color {
        let loadingOpacity = isLoading ? 0.5 : 1.0
        switch state {
        case .typing:
            return value.count == index && isActive
            ? configuration.colors.active.opacity(loadingOpacity)
            : configuration.colors.typing.opacity(loadingOpacity)
        case .valid:
            return configuration.colors.valid.opacity(loadingOpacity)
        case .invalid:
            return configuration.colors.invalid
        }
    }
}

//#Preview {
//    VerificationField()
//}


enum CodeType: Int, CaseIterable {
    case four = 4
    case six = 6
    
    var stringValue: String {
        "\(rawValue) Digit"
    }
}

enum TypingState {
    case typing
    case valid
    case invalid
}

enum TextFieldStyle: String, CaseIterable {
    case rounderBorder = "Rounded Border"
    case underline = "Underline"
}

struct VerificationFieldConfiguration {
    struct ColorConfig {
        var typing: Color
        var active: Color
        var valid: Color
        var invalid: Color
        var text: Color
        var loadingText: Color
        
        init(
            typing: Color = .gray,
            active: Color = .primary,
            valid: Color = .green,
            invalid: Color = .red,
            text: Color = .primary,
            loadingText: Color = Color.gray.opacity(0.5)
        ) {
            self.typing = typing
            self.active = active
            self.valid = valid
            self.invalid = invalid
            self.text = text
            self.loadingText = loadingText
        }
        
        static let `default` = ColorConfig()
    }
    
    struct SizeConfig {
        var fieldWidth: CGFloat
        var fieldHeight: CGFloat
        var spacing: CGFloat
        var underlineSpacing: CGFloat
        
        init(
            fieldWidth: CGFloat = 50,
            fieldHeight: CGFloat = 55,
            spacing: CGFloat = 8,
            underlineSpacing: CGFloat = 12
        ) {
            self.fieldWidth = fieldWidth
            self.fieldHeight = fieldHeight
            self.spacing = spacing
            self.underlineSpacing = underlineSpacing
        }
        
        static let `default` = SizeConfig()
    }
    
    struct BorderConfig {
        var width: CGFloat
        var cornerRadius: CGFloat
        var underlineHeight: CGFloat
        
        init(
            width: CGFloat = 1,
            cornerRadius: CGFloat = 8,
            underlineHeight: CGFloat = 1
        ) {
            self.width = width
            self.cornerRadius = cornerRadius
            self.underlineHeight = underlineHeight
        }
        
        static let `default` = BorderConfig()
    }
    
    struct TypographyConfig {
        var font: Font
        var fontWeight: Font.Weight
        
        init(
            font: Font = .title2,
            fontWeight: Font.Weight = .semibold
        ) {
            self.font = font
            self.fontWeight = fontWeight
        }
        
        static let `default` = TypographyConfig()
    }
    
    var colors: ColorConfig
    var sizes: SizeConfig
    var borders: BorderConfig
    var typography: TypographyConfig
    
    init(
        colors: ColorConfig = .default,
        sizes: SizeConfig = .default,
        borders: BorderConfig = .default,
        typography: TypographyConfig = .default
    ) {
        self.colors = colors
        self.sizes = sizes
        self.borders = borders
        self.typography = typography
    }
    
    static let `default` = VerificationFieldConfiguration()
    
    // Builder methods remain the same
    func withColors(_ colors: ColorConfig) -> VerificationFieldConfiguration {
        var config = self
        config.colors = colors
        return config
    }
    
    func withSizes(_ sizes: SizeConfig) -> VerificationFieldConfiguration {
        var config = self
        config.sizes = sizes
        return config
    }
    
    func withBorders(_ borders: BorderConfig) -> VerificationFieldConfiguration {
        var config = self
        config.borders = borders
        return config
    }
    
    func withTypography(_ typography: TypographyConfig) -> VerificationFieldConfiguration {
        var config = self
        config.typography = typography
        return config
    }
}
