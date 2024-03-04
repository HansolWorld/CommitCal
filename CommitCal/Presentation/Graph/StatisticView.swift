//
//  StatisticView.swift
//  CommitCal
//
//  Created by apple on 3/3/24.
//

import SwiftUI

struct StatisticView: View {
    let colums = [
        GridItem(.flexible(maximum: .infinity), spacing: 12),
        GridItem(.flexible(maximum: .infinity), spacing: 12)
    ]
    
    @ObservedObject var viewmodel: MainViewModel

    var body: some View {
        VStack {
            Spacer()
            if !viewmodel.isSumit {
                Text("Please enter a nickname, and Summit")
                    .font(.title3)
                    .foregroundStyle(Color.subText)
            } else if viewmodel.user == nil, viewmodel.isSumit {
                Text("Non-existent user")
                    .font(.title3)
                    .foregroundStyle(Color.subText)
            } else if viewmodel.isloading {
                Text("Loding...")
                    .font(.title3)
                    .foregroundStyle(Color.subText)
            } else if viewmodel.streak.reduce(0, { return $0 + $1.count }) == 0 {
                Text("There is no contribution")
                    .font(.title3)
                    .foregroundStyle(Color.subText)
            } else {
                ThreeDBarGraphView(data: viewmodel.streak, max: viewmodel.maxStreakCount)
                    .scaledToFit()
            }
            Spacer()
            VStack(alignment: .leading) {
                if !viewmodel.startDate.isEmpty {
                    Text("\(viewmodel.startDate) ~ \(viewmodel.endDate)")
                        .font(.caption)
                        .foregroundStyle(Color.subText)
                } else {
                    Text("00.00.0 ~ 00.00.00")
                        .font(.caption)
                        .foregroundStyle(Color.subText)
                }
                LazyVGrid(columns: colums, spacing: 12) {
                    TotalView()
                    MaxView()
                    LogestTotalView()
                    LogestView()
                }
            }
            .padding(12)
        }
    }
    
    @ViewBuilder
    func LogestView() -> some View {
        VStack {
            Text("Longest Day")
                .font(.subheadline)
            Spacer()
            VStack(spacing: 4) {
                Text("\(viewmodel.longestDate)")
                    .font(.title)
                Text("Days")
                    .font(.caption2)
            }
        }
        .modifier(TextModifier())
    }
    
    @ViewBuilder
    func LogestTotalView() -> some View {
        VStack {
            Text("Longest Contribute")
                .font(.subheadline)
            Spacer()
            VStack(spacing: 4) {
                Text("\(viewmodel.longestContribute)")
                    .font(.title)
                Text("Contributions")
                    .font(.caption2)
            }
        }
        .modifier(TextModifier())
    }
    
    @ViewBuilder
    func TotalView() -> some View {
        VStack {
            Text("1 Year Total")
                .font(.subheadline)
            Spacer()
            VStack(spacing: 4) {
                Text("\(viewmodel.totalContribute)")
                    .font(.title)
                Text("Contributions")
                    .font(.caption2)
            }
        }
        .modifier(TextModifier())
    }
    
    @ViewBuilder
    func MaxView() -> some View {
        VStack {
            Text("Busiest Day")
                .font(.subheadline)
            Spacer()
            VStack(spacing: 4) {
                Text("\(viewmodel.maxStreakCount)")
                    .font(.title)
                Text("Contributions")
                    .font(.caption2)
            }
        }
        .modifier(TextModifier())
    }
}

#Preview {
    StatisticView(viewmodel: MainViewModel())
}
