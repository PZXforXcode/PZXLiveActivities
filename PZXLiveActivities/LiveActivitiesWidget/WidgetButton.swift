//
//  TimerToggle.swift
//  PZXLiveActivities
//
//  Created by 彭祖鑫 on 2024/9/29.
//

import SwiftUI
import WidgetKit
import AppIntents
import UIKit

// 使用 ControlWidget 协议来定义一个基础控件,定义了一个新的结构体 WidgetToggle，它实现了 ControlWidget 协议。
struct WidgetButton: ControlWidget {
    // body属性表示该 WidgetButton 中包含的控件列表。
    var body: some ControlWidgetConfiguration {
        // // 这是一个静态配置，用于定义控件的结构：外观和行为。
        StaticControlConfiguration(
            kind: "com.apple.ControlWidgetButton"
        ) {
            // 定义了一个打开容器App的控件，
            ControlWidgetButton(action: OpenAppIntent()) {
                Label("WidgetButton", image: "PPTEST.symbols")
            } actionLabel: { isActive in
                Label("WidgetButton", image: "PPTEST.symbols")
            }
            
        }
        .displayName("pzx")
        .description("Pzx")
    }
}


struct OpenAppIntent: AppIntent {
    
    static var title: LocalizedStringResource { "Open App" }
    static var openAppWhenRun:Bool = true
    func perform() async throws -> some IntentResult {
        return .result()
    }
}





//
//#Preview {
//    WidgetButton()
//}
