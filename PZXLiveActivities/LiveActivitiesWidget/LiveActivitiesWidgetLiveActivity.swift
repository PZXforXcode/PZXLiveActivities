//
//  LiveActivitiesWidgetLiveActivity.swift
//  LiveActivitiesWidget
//
//  Created by pzx on 2023/4/19.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PZXProgressBar: View {
    var foregroundColor: Color
    var backgroundColor: Color
    var process: CGFloat  // 进度值，范围 0.0 - 1.0

    var body: some View {
        let height: CGFloat = 5.0

        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景条
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
                    .frame(height: height)

                // 前景条，表示进度
                RoundedRectangle(cornerRadius: 10)
                    .fill(foregroundColor)
                    .frame(width: geometry.size.width * min(max(process, 0), 1), height: height) // 动态计算宽度
                    .animation(.linear, value: process)  // 添加动画
            }
        }
        .frame(height: height) // 限制进度条高度
    }
}
struct ActivityView: View {
    var activityName: String
    var activityPrice: String
    @State var activityProgress: CGFloat = 0.0  // 进度值

    
    var body: some View {
        VStack {
            HStack(spacing:0) {
                leftView()//图片
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                RightView(activityName: activityName,activityPrice: activityPrice)//右边的数据
    //            RightView(activityName: activityName)
                    .padding(.trailing,30)
            }
            PZXProgressBar(foregroundColor: .orange, backgroundColor: .white, process: activityProgress)
                .padding(.horizontal,20)
                .padding(.bottom,20)

        }
//        .background(Color.yellow.opacity(0.7))
        .frame(width: .infinity,alignment: .leading)
    }
    
}

struct RightView: View {
    var activityName: String
    var activityPrice: String

 
    
    var body: some View {
        let spaceHeight = 18.0
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
            .padding(.vertical,16)
            Spacer()
            VStack(alignment: .trailing, content: {
                Text("当前费用: \(activityPrice)")
//                Text("当前费用: RM 9.8")
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

//基础类
struct LiveActivitiesWidgetLiveActivity: Widget {
    
    func setProgress(status:Int) -> CGFloat{
        
        switch status {
        case 1:
            return 0.25
        case 2:
            return 0.5
        case 3:
            return 0.75
        case 4:
            return 1.0
        default:
            return 0.0
        }
    }
    
    var body: some WidgetConfiguration {
        
        ///通知样式
        ActivityConfiguration(for: LiveActivitiesData.self) { context in
    
            // Lock screen/banner UI goes here
            ActivityView(activityName: context.state.name,activityPrice: context.state.price,activityProgress: setProgress(status: context.state.status))
                .activitySystemActionForegroundColor(Color.blue.opacity(0.9))
//            ActivityView(activityName: context.state.name)
                .background(Color.blue.opacity(0.7))
//                .activityBackgroundTint(Color.white.opacity(0.8))// 背景色
//                .activityBackgroundTint(Color.blue.opacity(0.7))// 背景色
//                .activitySystemActionForegroundColor(Color.blue.opacity(0.9))
            // 系统操作的按钮字体色 //无效？
                .widgetURL(URL(string: "no = \(context.state.no)"))


        }

        ///灵动岛样式
    dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
//                    Text("朱宇航心率88💓")
//                    Text("状态: \(context.state.name)")
//                        .font(Font.system(size: 14))
//                        .padding()

                }
                DynamicIslandExpandedRegion(.trailing) {
//                    Text("杨芮淇心率:87💓")
//                    Text("SOC: 45%")
//                        .font(Font.system(size: 14))
//                        .padding()

                }
                DynamicIslandExpandedRegion(.bottom) {
//                    Text("葛飞👦🏻")
//                    PZXProgressBar(foregroundColor: .orange, backgroundColor: .white, process: 0.4)
//                        .padding()
                    // more content
                }
            } compactLeading: {
//                Text("朱宇航心率")
//                Text("状态: \(context.state.name)")
//                    .font(Font.system(size: 12))

            } compactTrailing: {
//                Text("SOC: 45%")
//                    .font(Font.system(size: 12))

            } minimal: {
//                Text("迷你")
//                Text("SOC: 45%")
//                    .font(Font.system(size: 12))
            }
            .widgetURL(URL(string: "http://www.apple.com"))
//            .keylineTint(Color.red)
        }
    }
}

struct LiveActivitiesWidgetLiveActivity_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            
            LiveActivitiesData(numberOfPizzas: 0, totalAmount: "", orderNumber: "")
//                .previewContext(LiveActivitiesData.ContentState(name: "测试",status: 1), viewKind: .content)
                .previewContext(LiveActivitiesData.ContentState(name: "测试", price: "RM 8.8", no: "no0", status: 1), viewKind: .content)
                }
       }
}

