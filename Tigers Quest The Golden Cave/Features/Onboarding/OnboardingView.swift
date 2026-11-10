//
//  OnboardingView.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

enum OnboardingStore {
    private static let key = "quest.onboarding.done"

    static var isCompleted: Bool {
        UserDefaults.standard.bool(forKey: key)
    }

    static func complete() {
        UserDefaults.standard.set(true, forKey: key)
    }

#if DEBUG
    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
#endif
}

private struct OnboardingPage: Identifiable {
    let id: Int
    let symbol: String
    let imageName: String
    let title: String
    let body: String
}

struct OnboardingView: View {
    var onFinished: () -> Void

    @State private var page = 0
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            symbol: "flame.fill",
            imageName: CaveArtName.homeHero,
            title: "Campfire First",
            body: "Rest by the fire between halls. Gold stays in the pouch — it never leaves the caves."
        ),
        OnboardingPage(
            id: 1,
            symbol: "door.left.hand.closed",
            imageName: CaveArtName.seal,
            title: "Turn the Seals",
            body: "Read each inscription. Place coins and rubies in the hollows, then turn the stone to open the way."
        ),
        OnboardingPage(
            id: 2,
            symbol: "wand.and.stars",
            imageName: CaveArtName.forge,
            title: "Temper and Strike",
            body: "Feed the forge, then face the cave’s foes. Tap a spell to cast it. Swipe it up to put the staff behind the blow."
        )
    ]

    var body: some View {
        ZStack {
            AppBackgroundView()

            CaveAdaptiveContainer {
                VStack(spacing: 0) {
                    TabView(selection: $page) {
                        ForEach(pages) { item in
                            OnboardingPageView(page: item)
                                .tag(item.id)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    bottomChrome
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
    }

    private var bottomChrome: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach(pages) { item in
                    Capsule()
                        .fill(item.id == page ? CavePalette.gold : CavePalette.inkDim.opacity(0.45))
                        .frame(width: item.id == page ? 22 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: page)
                }
            }
            .accessibilityHidden(true)

            CaveActionButton(
                title: page == pages.count - 1 ? "Enter the caves" : "Continue",
                symbol: page == pages.count - 1 ? "arrow.right.circle.fill" : "chevron.right",
                action: advance
            )

            if page < pages.count - 1 {
                Button("Skip") {
                    finish()
                }
                .font(CaveType.caption(.subheadline, weight: .semibold))
                .foregroundStyle(CavePalette.inkDim)
                .frame(minHeight: 44)
            }
        }
    }

    private func advance() {
        if page >= pages.count - 1 {
            finish()
        } else {
            withAnimation(.easeInOut(duration: 0.25)) {
                page += 1
            }
        }
    }

    private func finish() {
        OnboardingStore.complete()
        onFinished()
    }
}

private struct OnboardingPageView: View {
    var page: OnboardingPage
    @Environment(\.caveMetrics) private var metrics

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: metrics.stack) {
                CaveSection(title: nil) {
                    CaveAssetImage(
                        name: page.imageName,
                        height: min(280, max(200, metrics.width * 0.58)),
                        corner: CaveDepth.tileRadius
                    )
                }

                CavePanel {
                    VStack(alignment: .leading, spacing: 12) {
                        Label(page.title, systemImage: page.symbol)
                            .font(CaveType.display(.title2))
                            .foregroundStyle(CavePalette.gold)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(page.body)
                            .font(CaveType.body())
                            .foregroundStyle(CavePalette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clearScrollBackground()
    }
}

#Preview {
    OnboardingView(onFinished: {})
}
