//
//  CaveArt.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import SwiftUI

struct TigerMageArt: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(CavePalette.ash)
                .frame(width: 8, height: 128)
                .offset(x: 58, y: 18)
            Circle()
                .fill(CavePalette.lapis)
                .frame(width: 22, height: 22)
                .overlay(Circle().stroke(CavePalette.gold, lineWidth: 3))
                .offset(x: 58, y: -52)

            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(CavePalette.ash)
                .frame(width: 78, height: 72)
                .offset(y: 40)
            Capsule()
                .fill(CavePalette.gold)
                .frame(width: 54, height: 14)
                .offset(y: 16)

            Circle()
                .fill(CavePalette.mane)
                .frame(width: 86, height: 86)
            HStack(spacing: 40) {
                Ear()
                Ear()
            }
            .offset(y: -48)
            Capsule()
                .fill(CavePalette.lapis)
                .frame(width: 92, height: 26)
                .overlay(
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { index in
                            Capsule()
                                .fill(index.isMultiple(of: 2) ? CavePalette.gold : CavePalette.lapis)
                                .frame(width: 8, height: 18)
                        }
                    }
                )
                .offset(y: -30)
            HStack(spacing: 18) {
                Eye()
                Eye()
            }
            .offset(y: -4)
            Capsule()
                .fill(CavePalette.gold.opacity(0.9))
                .frame(width: 28, height: 10)
                .offset(y: 18)
        }
        .frame(width: 170, height: 190)
        .accessibilityLabel("Tiger mage with a staff")
    }
}

struct BoneCatArt: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(CavePalette.lapis)
                .frame(width: 70, height: 18)
                .rotationEffect(.degrees(-28))
                .offset(x: 48, y: 28)
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(CavePalette.lapis.opacity(0.85))
                .frame(width: 64, height: 48)
                .offset(y: 28)
            Circle()
                .stroke(CavePalette.bone, lineWidth: 4)
                .background(Circle().fill(CavePalette.lapis))
                .frame(width: 62, height: 62)
            HStack(spacing: 28) {
                Ear(fill: CavePalette.bone)
                Ear(fill: CavePalette.bone)
            }
            .offset(y: -34)
            HStack(spacing: 16) {
                Circle().fill(.black).frame(width: 8, height: 8)
                Circle().fill(.black).frame(width: 8, height: 8)
            }
            .offset(y: -2)
        }
        .frame(width: 150, height: 150)
        .accessibilityLabel("Skeletal cat")
    }
}

struct GraveHoundArt: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(CavePalette.ash)
                .frame(width: 108, height: 58)
                .offset(y: 24)
            Circle()
                .fill(CavePalette.mane)
                .frame(width: 70, height: 70)
                .offset(x: 28, y: -8)
            Circle()
                .fill(Color(red: 0.12, green: 0.07, blue: 0.05))
                .frame(width: 34, height: 28)
                .offset(x: 46, y: 2)
            Capsule()
                .fill(CavePalette.ruby.opacity(0.85))
                .frame(width: 12, height: 16)
                .offset(x: 58, y: 10)
            HStack(spacing: 16) {
                Circle().fill(CavePalette.ink).frame(width: 7, height: 7)
                Circle().fill(CavePalette.ink).frame(width: 7, height: 7)
            }
            .offset(x: 30, y: -16)
        }
        .frame(width: 160, height: 140)
        .accessibilityLabel("Grave hound")
    }
}

struct EmberKingArt: View {
    var body: some View {
        ZStack {
            Flame()
                .fill(CavePalette.ember)
                .frame(width: 28, height: 48)
                .offset(x: 58, y: -20)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(CavePalette.ash)
                .frame(width: 6, height: 54)
                .offset(x: 58, y: 16)
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(red: 0.16, green: 0.08, blue: 0.06))
                .frame(width: 72, height: 78)
                .offset(y: 28)
            Capsule()
                .fill(CavePalette.gold)
                .frame(width: 64, height: 12)
                .offset(y: 4)
            Circle()
                .fill(CavePalette.bone)
                .frame(width: 58, height: 58)
                .offset(y: -24)
            Crown()
                .fill(CavePalette.gold)
                .frame(width: 70, height: 28)
                .offset(y: -56)
            HStack(spacing: 14) {
                Circle().fill(CavePalette.cave).frame(width: 7, height: 7)
                Circle().fill(CavePalette.cave).frame(width: 7, height: 7)
            }
            .offset(y: -26)
        }
        .frame(width: 170, height: 170)
        .accessibilityLabel("Crowned figure with a torch")
    }
}

private struct Ear: View {
    var fill: Color = CavePalette.mane

    var body: some View {
        Triangle()
            .fill(fill)
            .frame(width: 22, height: 26)
    }
}

private struct Eye: View {
    var body: some View {
        Capsule()
            .fill(CavePalette.ink)
            .frame(width: 14, height: 8)
            .overlay(alignment: .bottom) {
                Circle()
                    .fill(CavePalette.cave)
                    .frame(width: 5, height: 5)
            }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct Crown: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.25, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct Flame: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.maxX, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.minX, y: rect.midY)
        )
        return path
    }
}
