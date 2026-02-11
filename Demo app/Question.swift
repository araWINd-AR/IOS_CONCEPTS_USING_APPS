//
//  Question.swift
//  ICEBREAKER_S26
//
//  Created by Aravind Ganipisetty on 2/4/26.
//




import Foundation

class Question {
    var id: String
    var text: String
    
    init?(id: String, data: [String: Any]){
        guard let text = data["text"] as? String
        else {
            return nil
        }
        self.id = id
        self.text = text
    }
}
