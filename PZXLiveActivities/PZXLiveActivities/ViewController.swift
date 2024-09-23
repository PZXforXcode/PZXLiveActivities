//
//  ViewController.swift
//  PZXLiveActivities
//
//  Created by pzx on 2023/4/19.
//
/**
 下面的命令放在命令行可以通过推送实时改变 实时活动数据
 
 //注意事项
 AuthKey_5S685SDQG3.p8 要在文件目录下执行
 timestamp 时间要用当前时间 不然差的太远会导致推送收不到
 
 export TEAM_ID=KCNSS22SRZ
 export TOKEN_KEY_FILE_NAME=AuthKey_5S685SDQG3.p8
 export AUTH_KEY_ID=5S685SDQG3
 export DEVICE_TOKEN=807198a534f30cf2fda2b86f048e17ddeb7b816660f878b5c9dc6b061e36122a06ef99d8043fa874a1880b24718244231b79516065c263f258ce9ce63002393f98a02315142143c02aa3e957cff2e8a4
 export APNS_HOST_NAME=api.sandbox.push.apple.com

 export JWT_ISSUE_TIME=$(date +%s)
 export JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
 export JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
 export JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
 export JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
 export AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

 curl -v \
 --header "apns-topic:com.pingalax.EICharge.push-type.liveactivity" \
 --header "apns-push-type:liveactivity" \
 --header "authorization: bearer $AUTHENTICATION_TOKEN" \
 --data \
 '{"Simulator Target Bundle": "com.pingalax.EICharge",
 "aps": {
     "timestamp":'"$JWT_ISSUE_TIME"',
    "event": "update",
     "sound":"default",
          "content-state": {
              "name": "变化000",
              "status": 2
          },
 //加这个有声音
  "alert": {
              "title": "Delivery Update",
              "body": "Your pizza order will arrive soon."
          }
 }}' \
 --http2 \
 https://${APNS_HOST_NAME}/3/device/$DEVICE_TOKEN
 */
import UIKit
import ActivityKit
import SwiftUI
import WidgetKit

class ViewController: UIViewController {

    @IBOutlet weak var redLabel: UILabel!
    var num = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ///存储数据 传给 Widget
        let sharedDefaults = UserDefaults(suiteName: appGroupKey)
        sharedDefaults?.set("存储文字0", forKey: dataKey)
        sharedDefaults?.synchronize()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name(Widget_KEY), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Widget_KEY), object: nil)

    }
    
    
    @IBAction func saveTextButtonPressed(_ sender: Any) {
        
        ///存储数据 传给 Widget
        num += 1
        let String = "存储文字\(num)"
        let sharedDefaults = UserDefaults(suiteName: appGroupKey)
        sharedDefaults?.set(String, forKey: dataKey)
        sharedDefaults?.synchronize()
        //主动刷新Widget
        WidgetCenter.shared.reloadTimelines(ofKind: "LiveActivitiesWidget")
//
//        WidgetCenter.shared.reloadAllTimelines()

    }
    @objc func handleNotification() {
        
        redLabel.textColor = .red

        
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        StartLiveActivities()

        ///延迟五秒调用
        ///看是否会主动弹出
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) { [self] in
//            
//
//            UpdateData()
//        }
        
   
        
    }
    
    func StartLiveActivities() {
        
        
        if ActivityAuthorizationInfo().areActivitiesEnabled == true {
            
        }
        
        //初始化静态数据
        let liveActivitiesAttributes = LiveActivitiesData(numberOfPizzas: 5, totalAmount:"￥99", orderNumber: "23456")

        //初始化动态数据
        let initialContentState = LiveActivitiesData.LiveActivitiesStatus(name: "初始", price: "RM 9.9", status: 1)

        
        
        do {
            //启用灵动岛
            //灵动岛只支持Iphone，areActivitiesEnabled用来判断设备是否支持，即便是不支持的设备，依旧可以提供不支持的样式展示
            if ActivityAuthorizationInfo().areActivitiesEnabled == true{
                
            }
            let deliveryActivity = try Activity<LiveActivitiesData>.request(
                attributes: liveActivitiesAttributes,
                contentState: initialContentState,
                pushType: .token)
            //判断启动成功后，获取推送令牌 ，发送给服务器，用于远程推送Live Activities更新
            //不是每次启动都会成功，当已经存在多个Live activity时会出现启动失败的情况
            if deliveryActivity.activityState == .active{
                _ = deliveryActivity.pushToken
                
                print("deliveryActivity.pushToken = \(String(describing: deliveryActivity.pushToken))")

            }
//            deliveryActivity.pushTokenUpdates //监听token变化
            print("Current activity id -> \(deliveryActivity.id)")
            
            Task {
                          // 监听 push token 更新
                          for await pushToken in deliveryActivity.pushTokenUpdates {
                              let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
                              //打印推送令牌
                              print("pushTokenString = \(pushTokenString)")
                              // 上传 push token 给服务端，用于推送更新 Live Activity
//                              uploadTokenToService(pushTokenString)
                          }
            }
            
            
        } catch (let error) {
            print("Error info -> \(error.localizedDescription)")
        }
        
     
    }
    
    
    func UpdateData(){
        
        Task{
            
            let data = LiveActivitiesData.LiveActivitiesStatus(name: "充电中", price: "RM 11.0", status: 3)
            
            for activity in Activity<LiveActivitiesData>.activities {
                await activity.update(using: data)
            }
        }
 
        
    }
    
}

