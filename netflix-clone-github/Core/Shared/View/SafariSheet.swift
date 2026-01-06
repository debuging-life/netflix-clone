//
//  SafariSheet.swift
//  netflix-clone-github
//
//  Created by Pardip Bhatti on 01/01/26.
//

import SwiftUI
import SafariServices

struct SafariSheet: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}
