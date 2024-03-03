//
//  ChartView.swift
//  CommitCal
//
//  Created by apple on 3/1/24.
//

import SwiftUI
import Kingfisher

struct ChartView: View {
    @Environment(\.displayScale) var displayScale
    @StateObject private var viewmodel = ChartViewModel()
    @State private var isSummit = false
    @State private var renderedImage = Image(systemName: "photo")
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            renderView
            
            if viewmodel.user != nil, viewmodel.isSumit {
                HStack {
                    Button(action: {
                        viewmodel.maxStreakCount = 0
                        viewmodel.totalContribute = 0
                        viewmodel.longestDate = 0
                        viewmodel.longestContribute = 0
                        viewmodel.startDate = ""
                        viewmodel.endDate = ""
                        
                        viewmodel.user = nil
                        viewmodel.userName = ""
                        viewmodel.isSumit = false
                        viewmodel.streak = []
                        
                    }) {
                        Image(systemName: "repeat")
                    }
//                    ShareLink(
//                        item: renderedImage,
//                        preview: SharePreview(
//                            "MyStreak",
//                            image: renderedImage
//                        )
//                    )
//                    .labelStyle(.iconOnly)
                }
                .padding(12)
                .foregroundStyle(Color.text)
            }
        }
        .onChange(of: viewmodel.isloading) { old, new in
            if old == true, new == false {
                render()
            }
        }
    }
    
    var renderView: some View {
        RenderView(viewmodel: viewmodel)
    }
    
    @MainActor func render() {
        let renderer = ImageRenderer(content: renderView)

        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

#Preview {
    ChartView()
}
