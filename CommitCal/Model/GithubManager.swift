//
//  GithubManager.swift
//  CommitCal
//
//  Created by apple on 3/1/24.
//

import Foundation
import Alamofire
import SwiftSoup

class GithubManager {
    
    func getUser(userName: String, done: @escaping (GitHubUser) -> Void) {
        let url = "https://api.github.com/users/\(userName)"
        
        AF.request(url, headers: nil)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let user):
                    do {
                        let resultData = try JSONDecoder().decode(GitHubUser.self, from: user)
                        done(resultData)
                    } catch {
                        print("ERROR - \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    func getStreak(userName: String, done: @escaping ([ContributeData]?) -> Void) {
        let url = "https://github.com/users/\(userName)/contributions"
        
        AF.request(url, headers: nil)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    guard let html = String(data: data, encoding: .utf8) else {
                        return
                    }
                    
                    let contributeDataList = self.parseHtmltoData(html: html)
                    let mystreaks = self.parseHtmltoDataForCount(html: html)
                    
                    done(contributeDataList)
                case .failure(let error):
                    print("Error - \(error)")
                    done(nil)
                }
            }
    }
    
    private func parseHtmltoData(html: String) -> [ContributeData] {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]
    
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let rects: Elements = try doc.getElementsByTag(ParseKeys.rect)
            let tooltips: Elements = try doc.getElementsByTag(ParseKeys.tooltip)
            let days: [Element] = rects.array().filter { $0.hasAttr(ParseKeys.date) }
            let sortedDays = sortDaysByDate(days, with: isoDateFormatter)
            let weekend = sortedDays.suffix(364)
            
            var tooltipsTextById = [String: String]()
            for tooltip in tooltips.array() {
                let id = try tooltip.attr("for")
                let text = try tooltip.text()
                tooltipsTextById[id] = text
            }
            
            let updatedWeekend = weekend.map { element -> Element in
                let id = element.id()
                if let tooltipText = tooltipsTextById[id] {
                    do {
                        try element.text(tooltipText)
                    } catch {
                        print("DEBUG - \(error)")
                    }
                }
                return element
            }
         
            let contributeDataList = updatedWeekend.map(mapFunction)
            return contributeDataList
            
        } catch {
            return []
        }
    }
    
    private func sortDaysByDate(_ days: [Element], with dateFormatter: ISO8601DateFormatter) -> [Element] {
        return days.sorted { (element1, element2) -> Bool in
            guard let date1 = try? element1.attr(ParseKeys.date),
                  let date2 = try? element2.attr(ParseKeys.date),
                  let date1Value = dateFormatter.date(from: date1),
                  let date2Value = dateFormatter.date(from: date2) else {
                return false
            }
            return date1Value < date2Value
        }
    }
    
    private func mapFunction(ele : Element) -> ContributeData {
        guard let attr = ele.getAttributes() else { return ContributeData(count: 0, weekend: "", date: "") }
        let date: String = attr.get(key: ParseKeys.date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current

        let dateForWeekend = dateFormatter.date(from: date)
        guard let weekend = dateForWeekend?.dayOfWeek() else { return ContributeData(count: 0, weekend: "", date: "")}
        
        do {
            if let count = try selectCountFrom(sentence: ele.text()) {
                return ContributeData(count: count, weekend: weekend, date: date)
            } else {
                return ContributeData(count: 0, weekend: "", date: "")
            }
        } catch {
            return ContributeData(count: 0, weekend: "", date: "")
        }
    }
    
    private func selectCountFrom(sentence: String) -> Int? {
        guard let firstVerse = sentence.components(separatedBy: " ").first else {
            return nil
        }
        guard let integerValue = Int(firstVerse) else {
            return 0
        }
        return integerValue
    }
    
    private func parseHtmltoDataForCount(html: String) -> ContributeData {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let rects: Elements = try doc.getElementsByTag(ParseKeys.rect)
            let days: [Element] = rects.array().filter { $0.hasAttr(ParseKeys.date) }
            let count = days.suffix(1000)
            var contributeLastDate = count.map(mapFunction)
            contributeLastDate.sort{ $0.date > $1.date }
            for index in 0 ..< contributeLastDate.count {
                if contributeLastDate[index].count == .zero {
                    return contributeLastDate[index]
                }
                if index == (contributeLastDate.count - 1) {
                    return ContributeData(
                        count: 1000,
                        weekend: contributeLastDate[index].weekend,
                        date: contributeLastDate[index].date
                    )
                }
            }
            return ContributeData(count: 0, weekend: "", date: "")
        } catch {
            return ContributeData(count: 0, weekend: "", date: "")
        }
    }
}
