//
//  PageView.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI

struct PageView<Content: View>: View {
    @Binding var currentPage: Int
    var pages: Int
    var onComplete: (Bool) -> Void
    var content: Content
    
    init(
        currentPage: Binding<Int>,
        pages: Int,
        onComplete: @escaping (Bool) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self._currentPage = currentPage
        self.pages = pages
        self.content = content()
        self.onComplete = onComplete
    }
    
    var body: some View {
        TabView(selection: $currentPage) {
            content
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onChange(of: currentPage) { oldValue, newValue in
            if newValue == pages - 1 {
                onComplete(true)
            }
        }

        IndicatorsView(currentIndex: currentPage, pages: pages)
    }
}

struct IndicatorsView: View {
    var currentIndex: Int = 0
    var pages: Int
    var body: some View {
        HStack {
            ForEach(0..<pages, id: \.self) { index in
                Circle()
                    .fill(
                        index == currentIndex ? Color.white : Color.gray
                            .opacity(0.5)
                    )
                    .frame(
                        width: index == currentIndex ? 12 : 10,
                        height: index == currentIndex ? 12 : 10
                    )
                    .animation(.spring(duration: 0.25), value: index)
            }
        }
    }
}

#Preview {
    IndicatorsView(pages: 3)
}
