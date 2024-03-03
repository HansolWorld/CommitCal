//
//  RenderView.swift
//  CommitCal
//
//  Created by apple on 3/3/24.
//

import SwiftUI
import Kingfisher

struct RenderView: View {
    @ObservedObject var viewmodel: ChartViewModel
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(.all)
            VStack(spacing: 4) {
                HeaderView()
                SnapShotView(viewmodel: viewmodel)
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        if let user = viewmodel.user, viewmodel.isSumit {
            HStack(spacing: 8) {
                KFImage(URL(string: user.avatar_url))
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(user.name ?? " ")
                                .font(.headline.weight(.bold))
                            Text(user.login)
                                .font(.subheadline.weight(.bold))
                        }
                    }
                    Label("\(user.followers) followers·\(user.following) following", systemImage: "person.2")
                        .font(.caption)
                }
                Spacer()
            }
            .font(.headline)
            .frame(height: 60)
            .foregroundStyle(Color.text)
            .padding(12)
        } else {
            HStack {
                TextField("", text: $viewmodel.userName)
                    .placeholder(when: viewmodel.userName.isEmpty) {
                        Text("Github Nickname")
                            .foregroundStyle(Color.subText)
                    }
                    .padding(8)
                    .onSubmit {
                        viewmodel.getStreak()
                        viewmodel.getUser()
                        viewmodel.isSumit = true
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke()
                    }
                    .background {
                        Color.subBackground
                    }
                Button(action: {
                    viewmodel.getStreak()
                    viewmodel.getUser()
                    viewmodel.isSumit = true
                }) {
                    Text("Search")
                        .padding(8)
                        .foregroundColor(Color.text)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke()
                        }
                        .background {
                            Color.subBackground
                        }
                }
            }
            .font(.headline)
            .frame(height: 60)
            .foregroundStyle(Color.text)
            .padding(12)
        }
    }
}
