//
//  LiveActivitiesWidgetLiveActivity.swift
//  LiveActivitiesWidget
//
//  Created by pzx on 2023/4/19.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ActivityView: View {
    var activityName: String
//    var price: String

    var body: some View {
        
        HStack(spacing:0) {
            leftView()
                .padding(.leading, 20)
                .padding(.trailing, 10)
//            RightView(activityName: activityName,price: price)
            RightView(activityName: activityName)

                .padding(.trailing,30)
        }
        .frame(width: .infinity,alignment: .leading)
    }
    
}

struct RightView: View {
    var activityName: String
//    var price: String

 
    
    var body: some View {
        let spaceHeight = 8.0
        HStack {
            VStack(alignment: .leading, content: {
                Text("状态：\(activityName)")
                    .font(Font.system(size: 14))
                    .foregroundColor(Color.white)
                Spacer().frame(height: spaceHeight) // 调整间距的高度
                Text("2024-09-25 14:05")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.7))
            })
            Spacer()
            VStack(alignment: .trailing, content: {
//                Text("当前费用: \(price)")
                Text("当前费用: RM 9.8")
                    .bold()
                    .font(Font.system(size: 14))
                    .foregroundColor(Color.white)
                Spacer().frame(height: spaceHeight) // 调整间距的高度
                Text("充电时长: 20min")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.7))
            })
            
          
        }
    }
}

struct leftView: View {
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("无数据图")
                .resizable()
            .frame(width: 40,height: 40)
            Spacer()
        }
        
    }
}


struct LiveActivitiesWidgetLiveActivity: Widget {
    
    
    var body: some WidgetConfiguration {
        
        
        ///通知样式
        ActivityConfiguration(for: LiveActivitiesData.self) { context in
            // Lock screen/banner UI goes here
//            ActivityView(activityName: context.state.name,price: context.state.price)
            ActivityView(activityName: context.state.name)
                .background(Color.blue.opacity(0.7))
                .activityBackgroundTint(Color.white.opacity(0.1))// 背景色
                .activitySystemActionForegroundColor(Color.black)// 系统操作的按钮字体色
                .widgetURL(URL(string: "name = \(context.state.name)"))


        }

        ///灵动岛样式
    dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
//                    Text("朱宇航心率88💓")
                }
                DynamicIslandExpandedRegion(.trailing) {
//                    Text("杨芮淇心率:87💓")
                }
                DynamicIslandExpandedRegion(.bottom) {
//                    Text("葛飞👦🏻")
                    // more content
                }
            } compactLeading: {
//                Text("朱宇航心率")
            } compactTrailing: {
//                Text("杨芮淇心率")
            } minimal: {
//                Text("迷你")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct LiveActivitiesWidgetLiveActivity_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            
            LiveActivitiesData(numberOfPizzas: 0, totalAmount: "", orderNumber: "")
                .previewContext(LiveActivitiesData.ContentState(name: "测试",status: 1), viewKind: .content)
//                .previewContext(LiveActivitiesData.ContentState(name: "测试", price: "RM 8.8", status: 1), viewKind: .content)
                }
       }
}

