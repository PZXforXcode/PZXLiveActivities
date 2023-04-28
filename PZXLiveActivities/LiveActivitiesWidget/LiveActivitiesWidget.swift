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
        SimpleEntry(date: Date(),sharedData: "无数据")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), sharedData:"暂无数据")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        ///传值数据
        if let sharedDefaults = UserDefaults(suiteName: appGroupKey) {
            let sharedData = sharedDefaults.string(forKey: dataKey)
            let entry = SimpleEntry(date: Date(), sharedData: sharedData ?? "")
            entries.append(entry)
        }


        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let sharedData : String
}

struct LiveActivitiesWidgetEntryView : View {
    var entry: Provider.Entry
    


    var body: some View {
        Text(entry.date, style: .time)
        Text(entry.sharedData)
    }
        
}

struct LiveActivitiesWidget: Widget {
    let kind: String = "LiveActivitiesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LiveActivitiesWidgetEntryView(entry: entry)
                .widgetURL(URL(string: Widget_KEY))
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct LiveActivitiesWidget_Previews: PreviewProvider {
    static var previews: some View {
        LiveActivitiesWidgetEntryView(entry: SimpleEntry(date: Date(),sharedData: "无数据"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
