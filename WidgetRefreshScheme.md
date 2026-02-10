# Widget startDate 刷新方案

本方案描述如何在主工程（App）的特定生命周期（如 `viewWillAppear` 或 App 冷热启动）中刷新 Widget 的 `entry.startDate`。

## 核心原理

1.  **App Groups 数据共享**: 利用 `UserDefaults(suiteName: appGroupKey)` 在主 App 和 Widget Extension 之间共享数据。
2.  **WidgetCenter 刷新机制**: 使用 `WidgetCenter.shared.reloadTimelines` 主动触发 Widget 的时间线刷新。

## 实现步骤

### 1. 确保 App Groups 配置正确

确保主工程 target 和 Widget Extension target 都添加了相同的 App Groups Capability，并且代码中使用了正确的 Group ID（即 `appGroupKey`）。

### 2. 定义刷新逻辑的方法

在 `ViewController.swift` 或统一的工具类中定义一个刷新 Widget 时间的方法。

```swift
func refreshWidgetTime() {
    // 1. 获取共享的 UserDefaults
    if let sharedDefaults = UserDefaults(suiteName: appGroupKey) {
        // 2. 更新开始时间为当前时间
        sharedDefaults.set(Date(), forKey: timeDataKey)
        // 3. 强制同步（虽然系统会自动同步，但为了保险）
        sharedDefaults.synchronize()
        
        print("已更新 Widget startDate: \(Date())")
        
        // 4. 请求 Widget 刷新
        // ofKind 参数需要与 Widget 定义中的 kind 保持一致
        WidgetCenter.shared.reloadTimelines(ofKind: "LiveActivitiesWidget") 
    }
}
```

### 3. 在生命周期中调用

#### 场景 A: 页面显示时 (viewWillAppear)

如果希望每次进入该页面都刷新：

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // 刷新 Widget 时间
    refreshWidgetTime()
    
    // 原有的逻辑...
    NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name(Widget_KEY), object: nil)
}
```

#### 场景 B: App 冷启动与热启动 (App Lifecycle)

为了覆盖 App 从后台进入前台（热启动）的情况，建议监听 `UIApplication.willEnterForegroundNotification` 通知。

在 `viewDidLoad` 中添加观察者：

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // ... 原有代码 ...
    
    // 监听 App 进入前台（热启动）
    NotificationCenter.default.addObserver(self, 
                                           selector: #selector(handleAppWillEnterForeground), 
                                           name: UIApplication.willEnterForegroundNotification, 
                                           object: nil)
                                           
    // 如果需要冷启动时也刷新，可以直接在这里调用，或者依赖 viewWillAppear
    refreshWidgetTime()
}

// 处理进入前台通知
@objc func handleAppWillEnterForeground() {
    print("App 进入前台，刷新 Widget 时间")
    refreshWidgetTime()
}

// 记得在 deinit 或适当时机移除通知（iOS 9+ 其实如果不持有 block 可以不手动移除，但习惯上在 viewWillDisappear 或 deinit 移除）
deinit {
    NotificationCenter.default.removeObserver(self)
}
```

### 4. Widget 端的适配 (已存在，无需修改)

检查 `LiveActivitiesWidget.swift` 中的 `Provider`，确保它在 `getTimeline` 时读取了最新的 `timeDataKey`。

```swift
// LiveActivitiesWidget.swift

func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    // 读取共享数据
    if let sharedDefaults = UserDefaults(suiteName: appGroupKey) {
        // 获取最新的开始时间
        let startDate = sharedDefaults.object(forKey: timeDataKey) as? Date ?? Date()
        
        // 创建 Entry
        let entry = SimpleEntry(date: Date(), sharedData: ..., startDate: startDate)
        entries.append(entry)
    }
    
    // ...
    completion(timeline)
}
```

## 总结

通过在 `ViewController` 的 `viewWillAppear` 和 `willEnterForegroundNotification` 监听中更新 Shared UserDefaults 并调用 `WidgetCenter.reloadTimelines`，可以实现 App 侧对 Widget 时间的重置控制。
