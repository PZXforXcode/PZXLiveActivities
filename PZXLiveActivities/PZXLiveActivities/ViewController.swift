//
//  ViewController.swift
//  PZXLiveActivities
//
//  Created by pzx on 2023/4/19.
//

import UIKit
import ActivityKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        StartLiveActivities()

        ///延迟五秒调用
        ///看是否会主动弹出
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) { [self] in
            

            UpdateData()
        }
        
   
        
    }
    
    func StartLiveActivities() {
        
        
        if ActivityAuthorizationInfo().areActivitiesEnabled == true {
            
        }
        
        //初始化静态数据
        let liveActivitiesAttributes = LiveActivitiesData(numberOfPizzas: 5, totalAmount:"￥99", orderNumber: "23456")

        //初始化动态数据
        let initialContentState = LiveActivitiesData.LiveActivitiesStatus(name: "初始", status: 0, timer: Date()...Date().addingTimeInterval(15 * 60))

        
        
        do {
            //启用灵动岛
            //灵动岛只支持Iphone，areActivitiesEnabled用来判断设备是否支持，即便是不支持的设备，依旧可以提供不支持的样式展示
            if ActivityAuthorizationInfo().areActivitiesEnabled == true{
                
            }
            let deliveryActivity = try Activity<LiveActivitiesData>.request(
                attributes: liveActivitiesAttributes,
                contentState: initialContentState,
                pushType: nil)
            //判断启动成功后，获取推送令牌 ，发送给服务器，用于远程推送Live Activities更新
            //不是每次启动都会成功，当已经存在多个Live activity时会出现启动失败的情况
            if deliveryActivity.activityState == .active{
                _ = deliveryActivity.pushToken
                
                print("OKOKOKOKOK")

            }
//            deliveryActivity.pushTokenUpdates //监听token变化
            print("Current activity id -> \(deliveryActivity.id)")
        } catch (let error) {
            print("Error info -> \(error.localizedDescription)")
        }
        
     
    }
    
    
    func UpdateData(){
        
        Task{
            
            let data = LiveActivitiesData.LiveActivitiesStatus(name: "变化了", status: 1, timer: Date()...Date().addingTimeInterval(60 * 60))
            
            for activity in Activity<LiveActivitiesData>.activities {
                await activity.update(using: data)
            }
        }
 
        
    }
    
}

