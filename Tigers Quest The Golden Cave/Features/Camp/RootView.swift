//
//  RootView.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

struct RootView: View {
    @State private var showOnboarding = !OnboardingStore.isCompleted

    var body: some View {
        ZStack {
            AppBackgroundView()

            if showOnboarding {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showOnboarding = false
                    }
                }
                .transition(.opacity)
            } else {
                ContentView()
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RootView()
}
