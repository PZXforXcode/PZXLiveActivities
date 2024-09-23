//
//  LiveActivitiesData.swift
//  PZXLiveActivities
//
//  Created by pzx on 2023/4/19.
//

import Foundation
import ActivityKit

public struct LiveActivitiesData: ActivityAttributes {
    
    public typealias LiveActivitiesStatus = ContentState

    
    public struct ContentState: Codable, Hashable {
        var name: String
        var price: String
        var no: String
        var status : Int //1待接单， 2配送中 3已完成
    }

    var numberOfPizzas: Int
    var totalAmount: String
    var orderNumber: String

}
