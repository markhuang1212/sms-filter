//
//  MessageFilterExtension.swift
//  SMS Filter Extension
//
//  Created by HUANGMENG on 27/8/2020.
//

import IdentityLookup

let suiteName = "grounp.dev.hmplayrgound.sms-filter"

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling {
    
    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        // First, check whether to filter using offline data (if possible).
        let offlineAction = self.offlineAction(for: queryRequest)

        let response = ILMessageFilterQueryResponse()
        response.action = offlineAction

        completion(response)
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> ILMessageFilterAction {
        // Replace with logic to perform offline check whether to filter first (if possible).
        
        var words = ["退订","TD","td"]
        
        let ud = UserDefaults(suiteName: suiteName)
        
        if let words_user_raw = ud?.data(forKey: "filteredWords") {
            words = try! JSONDecoder().decode([String].self, from: words_user_raw)
        }
        
        for word in words {
            if queryRequest.messageBody?.contains(word) ?? false {
                return .junk
            }
        }
        
        return .allow
    }

}
