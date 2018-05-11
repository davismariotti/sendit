//
//  NetworkManager.swift
//  BillSplitter
//
//  Created by gomeow on 4/29/16.
//  Copyright © 2016 Davis Mariotti. All rights reserved.
//

import UIKit

class NetworkManager {

    static let verbose = true
    //static let baseUrl: String = "http://127.0.0.1:8000/"
    static let baseUrl: String = "http://senditapi.davismariotti.com/"

    static func getTopScores(completion: @escaping (_ result: [ScoreData]?) -> Void) {
        runRequest(urlFrag: "scores/", params: [:]) {
            (response, error) -> Void in
            if error != nil {
                completion(nil)
            }
            if response != nil {
                if let data = response!.jsonToDictionary() {
                    if let _ = data["Error"] {
                        // TODO?
                    }
                    completion(nil)
                } else if let data = response!.jsonToArray() {
                    let scores = data as! [[String:Any]]
                    var scoreDatas: [ScoreData] = []
                    for score in scores {
                        let username = score["username"] as! String
                        let scoreNum = score["score"] as! Int
                        let dateString = score["date"] as! String
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: dateString)
                        scoreDatas.append(ScoreData(username: username, score: scoreNum, date: date!))
                    }
                    completion(scoreDatas)
                }
            }
        }
    }

    static func sendScore(completion: @escaping (_ success: Bool) -> Void) {
        runRequest(urlFrag: "addscore/", params: [:]) {
            (response, error) -> Void in
            if error != nil {
                completion(false)
            }
        }
    }

    private static func runRequest(urlFrag: String, params: [String: String], completion:@escaping (String?, Error?) -> ()) {
        var postString = "?"
        for (key, value) in params {
            postString +=
                "&"
                + key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                + "="
                +  value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        runRequest(urlFrag: urlFrag, body: postString.data(using: .utf8)!) {
            (data: String?, error: Error?) -> Void in
            completion(data, error)
        }
    }

    private static func runRequest(urlFrag: String, body: Data, completion:@escaping (String?, Error?) -> ()) {
        var request = URLRequest(url: URL(string: self.baseUrl + urlFrag)!)
        request.httpMethod = "POST"
        request.httpBody = body
        URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let data = data, let dataString = String(data: data, encoding: String.Encoding.utf8) {
                debug(o: urlFrag)
                completion(dataString, error)
            } else {
                completion(nil, error)
            }
            }.resume()
    }

    static func debug(o: Any?) {
        if verbose {
            if o != nil {
                print(o!)
            } else {
                print(o)
            }
        }
    }

}
