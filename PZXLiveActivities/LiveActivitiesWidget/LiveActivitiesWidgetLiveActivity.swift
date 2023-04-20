//
//  LiveActivitiesWidgetLiveActivity.swift
//  LiveActivitiesWidget
//
//  Created by pzx on 2023/4/19.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct LiveActivitiesWidgetLiveActivity: Widget {
    
    
    var body: some WidgetConfiguration {
        
        
        ///通知样式
        ActivityConfiguration(for: LiveActivitiesData.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                
                Text(timerInterval: context.state.timer, countsDown: true)
                    .bold()
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                Text(context.state.name).foregroundColor(Color.white)

            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        }
        ///灵动岛样式
    dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("朱宇航心率88💓")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("杨芮淇心率:87💓")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("葛飞👦🏻")
                    // more content
                }
            } compactLeading: {
                Text("朱宇航心率")
            } compactTrailing: {
                Text("杨芮淇心率")
            } minimal: {
                Text("迷你")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

//struct LiveActivitiesWidgetLiveActivity_Previews: PreviewProvider {
//    static let attributes = LiveActivitiesWidgetAttributes(name: "Me")
//    static let contentState = LiveActivitiesWidgetAttributes.ContentState(value: 3)
//
//    static var previews: some View {
//        attributes
//            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
//            .previewDisplayName("Island Compact")
//        attributes
//            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
//            .previewDisplayName("Island Expanded")
//        attributes
//            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
//            .previewDisplayName("Minimal")
//        attributes
//            .previewContext(contentState, viewKind: .content)
//            .previewDisplayName("Notification")
//    }
//}
