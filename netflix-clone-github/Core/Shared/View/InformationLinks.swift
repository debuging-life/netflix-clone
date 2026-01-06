//
//  InformationLinks.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI

struct InformationLinks: View {
    @State private var selectedSheet: SheetType?
    
    var textColor: Color = .white
    var isPrivacy: Bool = false
    
    init(textColor: Color, isPrivacy: Bool = true) {
        self.textColor = textColor
        self.isPrivacy = isPrivacy
    }
    var body: some View {
        HStack(spacing: 8) {
            if isPrivacy {
                Button("Privacy") {
                    selectedSheet = .privacy
                }
                .foregroundStyle(textColor)
            }
            
            Button("Help") {
                selectedSheet = .help
            }
            .foregroundStyle(textColor)
        }
        .sheet(item: $selectedSheet) { sheet in
            SafariSheet(url: sheet.url)
        }
    }
}

#Preview {
    InformationLinks(textColor: .white)
}


enum SheetType: String, Identifiable {
    case privacy
    case help
    
    var id: String { rawValue }
    
    var url: URL {
        switch self {
            case .privacy:
            return URL(string: "https://www.netflix.com/legal/privacy-policy")!
        case .help:
            return URL(string: "https://www.netflix.com/help")!
        }
    }
}
