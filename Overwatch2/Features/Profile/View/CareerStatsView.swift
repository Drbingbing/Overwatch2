//
//  CareerStatsView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/5.
//

import SwiftUI
import ComposableArchitecture

struct CareerStatsView: View {
    
    var careerStats: [String: [PlatformStats.GamePlayKind.CareerStat]?]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Career Stats".uppercased())
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                Spacer()
            }
            
            if let careerStats = careerStats["all-heroes"], let careerStats {
                VStack(spacing: 12) {
                    ForEach(careerStats, id: \.label) { careerStat in
                        VStack(spacing: 8) {
                            if let s = careerStat.stats {
                                ForEach(s, id: \.key) { stats in
                                    CareerStatLabel(title: stats.label, value: stats.value)
                                    Divider()
//                                    if stats.key != careerStat.stats.last?.key {
//                                        Divider()
//                                    }
                                }
                            }
                        }
                        .modifier(CareerStatSectionModifier(title: careerStat.label.rawValue))
                        .modifier(CareerStatCardModifier())
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

private struct CareerStatLabel: View {
    
    var title: String
    var value: Double
    
    var body: some View {
        HStack(spacing: 20) {
            Text(title)
                .font(.system(size: 20, weight: .medium, design: .rounded))
            Spacer()
            Text(displayTime)
                .font(.system(size: 20, weight: .medium, design: .rounded))
        }
    }
    
    var displayTime: String {
        if title.contains("Time") {
            let hour = Int(value / 3600)
            let min = Int(value.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds = Int(value.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
            
            var result: [String] = [
                String(format: "%02d", min),
                String(format: "%02d", seconds)
            ]
            if hour > 0 {
                result.insert(String(hour), at: 0)
            }
            
            return result.joined(separator: ":")
        }
        
        return String(format: "%.f", value)
    }
}

private struct CareerStatCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background {
                LinearGradient(
                    colors: [
                        Color(hex: "E9ECEF"),
                        Color(hex: "FFFFFF")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct CareerStatSectionModifier: ViewModifier {
    
    var title: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(.blue)
                .font(.system(size: 20, weight: .medium, design: .rounded))
            
            content
        }
    }
}

#Preview {
    
    return ScrollView {
        CareerStatsView(
            careerStats: [
                "all-heroes": [
                    PlatformStats.GamePlayKind.CareerStat(
                        category: .best,
                        label: .best,
                        stats: [
                            .init(
                                key: "eliminations_most_in_game", 
                                label: "Eliminations - Most in Game",
                                value: 61
                            ),
                            .init(
                                key: "final_blows_most_in_game",
                                label: "Final Blows - Most in Game",
                                value: 37
                            ),
                            .init(
                                key: "objective_time_most_in_game",
                                label: "Objective Time - Most in Game",
                                value: 377
                            )
                        ]
                    )
                ]
            ]
        )
    }
    .background {
        LinearGradient(
            colors: [Color(hex: "ABC4FF"), Color(hex: "E2EAFC")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
