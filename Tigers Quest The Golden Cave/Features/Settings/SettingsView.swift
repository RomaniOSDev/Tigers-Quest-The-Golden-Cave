//
//  SettingsView.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import StoreKit
import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject private var store: QuestStore
    @State private var confirmRestart = false

    var body: some View {
        ZStack {
            AppBackgroundView()
            CaveAdaptiveContainer {
                SettingsScroll(
                    confirmRestart: $confirmRestart
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .confirmationDialog(
            "Restart the expedition?",
            isPresented: $confirmRestart,
            titleVisibility: .visible
        ) {
            Button("Restart", role: .destructive) {
                store.restartExpedition()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Coins, rubies, gear, and seals return to the first gallery.")
        }
    }
}

private struct SettingsScroll: View {
    @EnvironmentObject private var store: QuestStore
    @Environment(\.caveMetrics) private var metrics
    @Binding var confirmRestart: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: metrics.stack) {
                CaveScreenHeader(
                    title: "Settings",
                    subtitle: "Rate the expedition, read the stone laws, or start again."
                )

                CaveSection(title: "Links") {
                    VStack(alignment: .leading, spacing: metrics.sectionGap) {
                        SettingsActionCell(
                            title: "Rate Us",
                            detail: "Leave a short word for the caves.",
                            symbol: "star.fill",
                            tint: CavePalette.gold
                        ) {
                            rateApp()
                        }

                        SettingsActionCell(
                            title: "Privacy Policy",
                            detail: "How the pouch keeps its secrets.",
                            symbol: "hand.raised.fill",
                            tint: CavePalette.lapis
                        ) {
                            openPolicy(.privacyPolicy)
                        }

                        SettingsActionCell(
                            title: "Terms of Use",
                            detail: "The rules that bind every seal.",
                            symbol: "doc.text.fill",
                            tint: CavePalette.ember
                        ) {
                            openPolicy(.termsOfUse)
                        }
                    }
                }

                CaveSection(title: "Expedition", subtitle: "Motion and a clean restart.") {
                    VStack(alignment: .leading, spacing: metrics.sectionGap) {
                        CavePanel(elevated: false) {
                            Toggle(isOn: Binding(
                                get: { store.reduceMotionPreference },
                                set: { store.setReduceMotionPreference($0) }
                            )) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Reduce Motion")
                                        .font(CaveType.heading())
                                        .foregroundStyle(CavePalette.ink)
                                    Text("Keeps card strikes quieter in battle.")
                                        .font(CaveType.caption())
                                        .foregroundStyle(CavePalette.inkDim)
                                }
                            }
                            .tint(CavePalette.ember)
                        }

                        SettingsActionCell(
                            title: "Restart Expedition",
                            detail: "Return coins, gear, and seals to the first gallery.",
                            symbol: "arrow.counterclockwise",
                            tint: CavePalette.ruby
                        ) {
                            confirmRestart = true
                        }

                        CavePanel(elevated: false) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(store.stageTitle)
                                    .font(CaveType.heading())
                                    .foregroundStyle(CavePalette.ink)
                                ProgressTrack(title: "Expedition", value: store.expeditionProgress, tint: CavePalette.gold)
                                Text("\(store.gold) coins · \(store.gems) rubies · staff \(store.staffRank)/\(store.maxGearRank)")
                                    .font(CaveType.caption())
                                    .foregroundStyle(CavePalette.inkDim)
                                    .monospacedDigit()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, metrics.gutter)
            .padding(.top, 4)
            .padding(.bottom, metrics.tabBarClearance)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clearScrollBackground()
    }


    private func openPolicy(_ link: AppLinks) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

private struct SettingsActionCell: View {
    var title: String
    var detail: String
    var symbol: String
    var tint: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            CavePanel(elevated: false) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: symbol)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(tint)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(tint.opacity(0.18)))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(CaveType.heading())
                            .foregroundStyle(CavePalette.ink)
                        Text(detail)
                            .font(CaveType.body(.subheadline))
                            .foregroundStyle(CavePalette.inkDim)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(CavePalette.inkDim)
                        .padding(.top, 12)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(minHeight: 44)
        .accessibilityLabel(title)
        .accessibilityHint(detail)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environmentObject(QuestStore(defaults: UserDefaults(suiteName: "settings.preview") ?? .standard))
}
