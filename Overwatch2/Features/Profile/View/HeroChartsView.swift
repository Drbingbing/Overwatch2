//
//  HeroChartsView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/12.
//

import SwiftUI

struct HeroChartsView: View {
    
    var label: String
    var heroes: [PlatformStats.GamePlayKind.HeroComparisons.Value]
    @Binding var showAll: Bool
    
    private var colors: [String: String] { HeroColor.primary }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            
            ForEach(heroes, id: \.hero) { comparisons in
                HeroChartView(
                    name: comparisons.hero,
                    total: comparisonValue(comparisons),
                    color: colors[comparisons.hero]!,
                    percent: percentValue(comparisons, max: heroes[0].value)
                )
            }
       
            if !showAll {
                Text("See all heroes")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .onTap { showAll.toggle() }
            }
        }
    }
    
    private func percentValue(_ comparison: PlatformStats.GamePlayKind.HeroComparisons.Value, max: Double) -> Double {
        min(comparison.value / max, 1)
    }
    
    private func comparisonValue(_ comparison: PlatformStats.GamePlayKind.HeroComparisons.Value) -> String {
        if label.contains("Time") {
            let v = secondsToHoursMinutesSeconds(seconds: comparison.value)
            return "\(String(format: "%02.f", v.hour)):\(String(format: "%02.f", v.min)):\(String(format: "%02.f", v.sec))"
        }
        if label.contains("Accuracy") {
            return "\(String(format: "%02.f", comparison.value))%"
        }
        return "\(String(format: "%02.f", comparison.value))"
    }
    
    private func secondsToHoursMinutesSeconds(seconds: Double) -> (hour: Double, min: Double, sec: Double) {
        return (
            seconds/3600,
            seconds.truncatingRemainder(dividingBy: 3600)/60,
            seconds.truncatingRemainder(dividingBy: 60)
        )
    }
}

private struct HeroChartView: View {
    
    var name: String
    var total: String
    var color: String
    var percent: Double
    
    var body: some View {
        ZStack {
            Color.white
            GeometryReader { proxy in
                Color(hex: color)
                    .offset(x: 64)
                    .frame(width: (proxy.size.width - 64) * percent)
            }
        }
        .frame(height: 64)
        .overlay {
            HStack(spacing: 20) {
                Image(imageName)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .background {
                        LinearGradient(
                            colors: [Color(hex: "92B4F4"), Color(hex: "FFFFFF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                Text(displayName)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                Spacer()
                Text(total)
                    .font(.system(size: 20, design: .rounded))
            }
            .padding(.trailing, 12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 20)
    }
    
    private var imageName: String {
        if name == "widowmaker" {
            return "widow_maker_classic_icon"
        }
        if name == "soldier-76" {
            return "soldier76_classic_icon"
        }
        if name.contains("-") {
            return name.replacingOccurrences(of: "-", with: "_") + "_classic_icon"
        }
        return name + "_classic_icon"
    }
    
    private var displayName: String {
        if name == "soldier-76" {
            return name.replacingOccurrences(of: "-", with: ":").uppercased()
        }
        if name == "lucio" {
            return "LÚCIO"
        }
        if name == "torbjorn" {
            return "TORBJÖRN"
        }
        if name.contains("-") {
            return name.replacingOccurrences(of: "-", with: " ").uppercased()
        }
        return name.uppercased()
    }
}

#Preview {
    ScrollView {
        HeroChartsView(
            label: "Time Played",
            heroes: [
                .init(hero: "ana", value: 669476),
                .init(hero: "cassidy", value: 480503),
                .init(hero: "zenyatta", value: 286677),
                .init(hero: "zarya", value: 255647)
            ],
            showAll: .constant(false)
        )
    }
    .background {
        LinearGradient(
            colors: [Color(hex: "E2EAFC"), Color(hex: "ABC4FF")],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()
    }
}
