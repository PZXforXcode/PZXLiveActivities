//
//  LiveActivitiesWidgetBundle.swift
//  LiveActivitiesWidget
//
//  Created by pzx on 2023/4/19.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivitiesWidgetBundle: WidgetBundle {
    var body: some Widget {
        //Widget
        LiveActivitiesWidget()
        //实时活动+灵动岛
        LiveActivitiesWidgetLiveActivity()
        //widgetControl
//        if #available(iOSApplicationExtension 18.0, *) {
            WidgetButton()
//        OpenPhotoCalorieControlWidget()
//        }
    }
}
