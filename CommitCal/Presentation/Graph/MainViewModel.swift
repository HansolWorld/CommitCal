//
//  MainViewModel.swift
//  CommitCal
//
//  Created by apple on 3/1/24.
//

import Foundation

class MainViewModel: ObservableObject {
    let githubManager = GithubManager()
    var maxStreakCount = 0
    var totalContribute = 0
    var longestDate = 0
    var longestContribute = 0
    var startDate = ""
    var endDate = ""
    
    @Published var user: GitHubUser?
    @Published var userName = ""
    @Published var isSumit = false
    @Published var streak: [ContributeData] = []
    @Published var isloading = false
    
    func getUser() {
        self.isSumit = true
        githubManager.getUser(userName: userName) { user in
            self.user = user
        }
    }
    
    func getStreak() {
        isloading = true
        var longestDate = 0
        var longestContribution = 0
        self.streak = []
        
        githubManager.getStreak(userName: userName) { contributeData in
            if let contributeData = contributeData {
                self.maxStreakCount = contributeData.map {$0.count}.max()!

                var emptyCount = 0
                if contributeData.first?.weekend == "Sun" {
                    emptyCount = 6
                } else if contributeData.first?.weekend == "Mon" {
                    emptyCount = 5
                } else if contributeData.first?.weekend == "Tue" {
                    emptyCount = 4
                } else if contributeData.first?.weekend == "Wed" {
                    emptyCount = 3
                } else if contributeData.first?.weekend == "Thu" {
                    emptyCount = 2
                } else if contributeData.first?.weekend == "Fri" {
                    emptyCount = 1
                }
                
                self.streak = Array(repeating: ContributeData(count: 0, weekend: "", date: ""), count: emptyCount)
                self.streak += contributeData
                
                self.totalContribute = contributeData.first?.count ?? 0
                self.startDate = contributeData.first?.date ?? ""
                self.endDate = contributeData.last?.date ?? ""
                
                for index in 1..<contributeData.count {
                    self.totalContribute += contributeData[index].count
                    let contributeCount = contributeData[index - 1].count
                    if contributeCount != 0 {
                        longestDate += 1
                        longestContribution += contributeCount
                    } else {
                        if self.longestDate < longestDate {
                            self.longestDate = longestDate
                            self.longestContribute = longestContribution
                        }
                        longestDate = 0
                        longestContribution = 0
                    }
                }
            }
            
            self.isloading = false
        }
    }
    
    static let dummyStreak: [ContributeData] = {
        var contributeDatas: [ContributeData] = []
        let today = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yy-MM-dd"
        
        let weekDateFormatter = DateFormatter()
        weekDateFormatter.dateFormat = "E"
        
        for count in 0..<364 {
            let date = Calendar.current.date(byAdding: .day, value: -count, to: today)!
            
            contributeDatas.append(
                ContributeData(
                    count: Int.random(in: 0..<15),
                    weekend: weekDateFormatter.string(from: date),
                    date: dateformatter.string(from: date))
            )
        }
        
        contributeDatas.reverse()
        return contributeDatas
    }()
}
