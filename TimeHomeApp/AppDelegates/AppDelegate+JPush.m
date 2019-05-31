//
//  AppDelegate+JPush.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "PANoticeManager.h"
#import "AppDelegate+Message.h"
@implementation AppDelegate (JPush)

#pragma mark - JPush init
-(void)registJPush:(NSDictionary *)launchOptions{
    
    /**
     *极光
     **/
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
    
    
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey channel:@"" apsForProduction:isProduction];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(receiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    
    [defaultCenter addObserver:self selector:@selector(didRegisterAction:) name:kJPFNetworkDidRegisterNotification object:nil];
    
}

#pragma mark - AppDelegate RemoteNotifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * _deviceToken = @"";
    _deviceToken = [[NSString stringWithFormat:@"%@", deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", _deviceToken);
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", _deviceToken]);
    ////注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

/** apns注册失败 获取失败回调 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive) {
        NSLog(@"收到通知= 点击==fetchCompletionHandler=:%@", [self logDic:userInfo]);
        self.pushMsgType =[NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"type"] integerValue]];
        self.pushMsgTime=[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"sendtime"]];
        NSLog(@"pushMsgType====%@   pushTitle===%@",self.pushMsgType,self.pushMsgTime);
        
    }else if([UIApplication sharedApplication].applicationState==UIApplicationStateActive){
        NSLog(@"收到通知===fetchCompletionHandler=:%@", [self logDic:userInfo]);
        AudioServicesPlaySystemSound(1007);
    }else {
        NSLog(@"收到通知22===fetchCompletionHandler=:%@", [self logDic:userInfo]);
    }
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive) {
        if (![self isBeyonbdDays]) {
            [PANoticeManager manageNotification:userInfo];
            
            NSLog(@"收到通知= 点击==fetchCompletionHandler=:%@", [self logDic:userInfo]);
            self.pushMsgType =[NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"type"] integerValue]];
            
            self.pushMsgTime=[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"sendtime"]];
            
            NSLog(@"pushMsgType====%@   pushTitle===%@",self.pushMsgType,self.pushMsgTime);
            
            NSMutableDictionary * userInfo_dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            
            if ([userInfo objectForKey:@"cjson"]) {
                
                [userInfo_dic setDictionary:userInfo];
                
            }
            [userInfo_dic setObject:[userInfo objectForKey:@"type"] forKey:@"type"];
            [userInfo_dic setObject:@YES forKey:@"isclick"];

            // 序列化dic

            NSString * jsonString = [userInfo objectForKey:@"cjson"];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers              error:&err];

            NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
            
            if (type.integerValue == 30101) {
                
                [self synchronousChatData:dic :@""];
                
            }else
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:userInfo_dic];
            }
        }
        
    }else if([UIApplication sharedApplication].applicationState==UIApplicationStateActive)
    {
        
        NSLog(@"收到通知===fetchCompletionHandler=:%@", [self logDic:userInfo]);
        AudioServicesPlaySystemSound(1007);
        
    } else {
        
        NSLog(@"收到通知22===fetchCompletionHandler=:%@", [self logDic:userInfo]);
        
    }
    //[JPUSHService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    NSLog(@"收到通知===didReceiveLocalNotification=:%@", @"");
}

#pragma mark - 透传消息
-(void)receiveMessage:(NSNotification *)notification{
    NSLog(@"自定义消息======%@=====",notification.userInfo);
    NSString * message = [notification.userInfo objectForKey:@"content"];
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *pushDic =  [DataController dictionaryWithJsonData:jsonData];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setDictionary:pushDic];
    [dic setObject:@NO forKey:@"isclick"];
    NSLog(@"===消息处理==%@",message);
    NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    [self dealPushMsg:dic :message :type];
    [PANoticeManager manageJPushReceiveMessage:dic];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
    NSLog(@"推送消息==forLocalNotification=%@",@"");
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
    NSLog(@"推送消息==forRemoteNotification=%@",userInfo);
    
}
#endif

#pragma mark - 设置推送标签
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error{
    NSLog(@"设置tags");
    if (aTag==nil||aTag.count==0) {
        [JPUSHService setTags:[NSSet set] callbackSelector:nil object:nil];
    }else{
        NSSet * setTag = [NSSet setWithArray:aTag];
        [JPUSHService setTags:setTag callbackSelector:@selector(bieMingLog) object:nil];
    }
    return YES;
}

#pragma mark - 
-(void)didRegisterAction:(NSNotification *)notification{
    NSLog(@"Registration ID===%@",notification.userInfo);
}

-(void)networkDidRegister:(NSNotification *)notification{
    //创建设备别名
    NSLog(@"推送registid创建设备别名==%@", [JPUSHService registrationID]);
}

-(void)bieMingLog{
    NSLog(@"创建成功！");
}
@end
