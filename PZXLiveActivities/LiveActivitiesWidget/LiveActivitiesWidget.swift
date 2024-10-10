//
//  LiveActivitiesWidget.swift
//  LiveActivitiesWidget
//
//  Created by pzx on 2023/4/19.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), sharedData: "无数据", startDate: Date()) // PZX修改: 增加 startDate 属性
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), sharedData: "暂无数据", startDate: Date()) // PZX修改: 增加 startDate 属性
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
//        let startDate = Date()
        
        ///传值数据
        ///这两个2选一 生效
        if let sharedDefaults = UserDefaults(suiteName: appGroupKey) {
            let sharedData = sharedDefaults.string(forKey: dataKey)
            //获取开始时间，
            let startDate : Date = sharedDefaults.object(forKey: timeDataKey) as! Date

//            let entry = SimpleEntry(date: Date(), sharedData: sharedData ?? "", startDate: startDate) // PZX修改: 增加 startDate 属性
            let entry = SimpleEntry(date: Date(), sharedData: "计时器01", startDate: startDate) // PZX修改: 增加 startDate 属性

            entries.append(entry)
        }
        

        // 小组件 一天有 40 ～ 70 次刷新机会
        ///这两个2选一 生效
//        if let sharedDefaults = UserDefaults(suiteName: appGroupKey) {
//            let sharedData = sharedDefaults.string(forKey: dataKey)
//            //获取开始时间，
//            let startDate : Date = sharedDefaults.object(forKey: timeDataKey) as! Date
//
//            var time = ((24 * 60 * 60)/40)
//            if #available(iOS 16, *) {
//                time = ((24 * 60 * 60)/70)
//            }
//            
//           for second in 0 ..< time {
//               let entryDate = Calendar.current.date(byAdding: .second, value: second, to: startDate)!
//                let entry = SimpleEntry(date: entryDate, sharedData: "计时器", startDate: startDate)
//                entries.append(entry)
//            }
//        }
//   
        
//        每分钟刷新一次
//        let refreshDate = Calendar.current.date(byAdding: .minute, value:1, to: Date())!
//        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        let timeline = Timeline(entries: entries, policy: .atEnd)

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let sharedData : String
    let startDate: Date // PZX新增: 添加 startDate 用来记录计时器的起始时间
    
}

// PZX新增: 封装时间格式化函数
func formattedElapsedTime(from startDate: Date, to currentDate: Date) -> String {
    let elapsedSeconds = Int(currentDate.timeIntervalSince(startDate))

    if elapsedSeconds < 3600 {
        // 1 小时以内，显示分钟和秒
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return "\(minutes) 分 \(seconds) 秒前"
    } else if elapsedSeconds < 86400 {
        // 1 小时到 24 小时之间，显示小时和分钟
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        return "\(hours) 小时 \(minutes) 分钟前"
    } else {
        // 超过 24 小时，显示天数
        let days = elapsedSeconds / 86400
        return "\(days) 天前"
    }
}


struct LiveActivitiesWidgetEntryView : View {
    var entry: Provider.Entry
    
    
    
    var body: some View {
        if #available(iOSApplicationExtension 17.0, *) {
            VStack { // 用 VStack 包裹视图
    
                // PZX修改: 将计时器显示为 "X分X秒" 格式
                Group{
                    
                    Text("\(entry.startDate, style: .relative)前")
                        .multilineTextAlignment(.center) // 设置文本居中对齐
                        .contentTransition(.identity)

//                    Text(formattedElapsedTime(from: entry.startDate, to: entry.date))
                    //关闭动画
                        .contentTransition(.identity)
                    Text(entry.sharedData)
                    Text("我是Widget")
                }
                .font(Font.system(size: 12))
    
                
            }
            .padding() // 添加 padding 增加布局空间
            .containerBackground(Color.white, for: .widget)
        } else {
            // Fallback on earlier versions
            VStack { // 用 VStack 包裹视图
                Text(entry.date, style: .time)
                Text(entry.sharedData)
            }
            .padding() // 添加 padding 增加布局空间
        } // 使用 Color 作为背景样式，适配系统动态背景
        // 应用容器背景，使背景适配系统动态背景
    }
    
}

struct LiveActivitiesWidget: Widget {
    let kind: String = "LiveActivitiesWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LiveActivitiesWidgetEntryView(entry: entry)
                .widgetURL(URL(string: Widget_KEY))
        }
        .configurationDisplayName("My Widget PZX")
        .description("This is an example widget. PZX")
    }
}

struct LiveActivitiesWidget_Previews: PreviewProvider {
    static var previews: some View {
        LiveActivitiesWidgetEntryView(entry: SimpleEntry(date: Date(), sharedData: "无数据", startDate: Date())) // PZX修改: 增加 startDate 属性
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
