

///极光推送宏定义
#import "BluetoothPresenter.h"
#import "MyTopicPostVC.h"
#import "AppDelegate.h"
#import "DataOperation.h"
#import "HDActivityPresenter.h"
#import "ShakePassageVC.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import "ChatPresenter.h"
#import "Gam_Chat.h"
#import "XMMessage.h"

#import "MainTabBars.h"
#import "LoginVC.h"
#import "PushMsgModel.h"
#import "AppSystemSetPresenters.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DataController.h"
#import "MsgAlertView.h"
#import "NetWorks.h"
#import "CommunityManagerPresenters.h"
#import "AppPayPresenter.h"

#import "TalkingData.h"
#import <CoreMotion/CoreMotion.h>
#import "DateUitls.h"

#import "THMyInfoPresenter.h"
#import "MessageAlert.h"
#import "SiginRulesVC.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "L_UpdateVC.h"
#import "Reachability.h"
#import "PARequestArgumentsFilter.h"
#import "NetworkMonitoring.h"

#import "PANoticeManager.h"
#import "PAVersionManager.h"
#import "UIWindow+Motion.h"

#import "AppDelegate+UI.h"
#import "AppDelegate+Logger.h"
#import "AppDelegate+NetWork.h"
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate+UserData.h"
#import "AppDelegate+Route.h"
#import "AppDelegate+BMKMap.h"
#import "AppDelegate+Version.h"
#import "AppDelegate+UserStatistics.h"
#import "AppDelegate+TalkingData.h"
#import "AppDelegate+JPush.h"
#import "AppDelegate+Message.h"
#import "AppDelegate+Pay.h"
#import "AppDelegate+Launch.h"
#import "AppDelegate+UMCCommon.h"
#import "AppDelegate+UMCommonLog.h"
#import <BmobSDK/Bmob.h>
#import "WebViewVC.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

#pragma mark - Lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ///注册极光推送
    [self registJPush:launchOptions];

    //友盟统计
    [self registUMCCommon];
    //--友盟日志系统
    [self registUMCommonLog];
    
    //界面设置
    [self setupUI];
    
    //日志配置
    [self configCrashException];
    
    //配置YTKNetwork
    [self configNetwork];
    
    //配置shareSDK
    [self configShareSDK];
    
    //获取用户数据
    [self configUserData];
    
    //监测网络情况 区分WiFi 4G 3G 2G WWAN
    [[NetworkMonitoring shareMonitoring]start];
    
    //注册微信支付
    [APPWXPAYMANAGER usPay_registerAppWithUrlSchemes:WXAPPID];
    
//    //配置 TalkingData
//    [self configTalkingData];
    
    //配置百度地图
    [self configBMKMapManager];
    
    //设置消息存储名称
    [self setMsgSaveName];

    //设置统计数据
    [self configUserStatistics];

    //配置主界面
    [self setupWindow];
    
    //程序没有运行的情况下收到通知，点击通知跳转页面
    [self setPushNoticeWithLaunchOptions:launchOptions];
    
    //是否强制更新
    [self isVersionUpdate];
    
    //检查新版本
    [PAVersionManager load];
    
    ///接口开关
    [Bmob registerWithAppKey:@"0015bad40a558dc0108de9740f35033f"];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"config"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"QaRiEEEN" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
            //配置主界面
            [self showMainView];
            
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                
                NSString* show = [NSString stringWithFormat:@"%@",[object objectForKey:@"show"]];
                BOOL ishow = show.boolValue;
                NSString * url = [NSString stringWithFormat:@"%@",[object objectForKey:@"url"]];
                _huangguangURL = url;
                if (ishow) {
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    webVC.url = url;
                    self.window.rootViewController = webVC;
                    [self.window makeKeyAndVisible];
                }else{
                    //配置主界面
                    [self showMainView];
                }
                
            }else{
                //配置主界面
                [self showMainView];
            }
        }
    }];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"==========applicationWillResignActive============即将进入后台");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"==========applicationDidEnterBackground============已经进入后台");
    self.pushMsgType=@"0";
    self.pushMsgTime=@"";
    //保存数据
    [self addStatistics:@{@"viewkey":self.main_viewkey?self.main_viewkey:@""}];
    [self addStatistics:@{@"viewkey":self.viewkey?self.viewkey:@""}];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([self isBeyonbdDays] == YES) {
        if ([self.window.rootViewController isKindOfClass:[MainTabBars class]]) {
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
            UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
            AppDelegate *appdelegate = GetAppDelegates;
            [appdelegate setTags:nil error:nil];
            appdelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:NO];
            [appdelegate saveContext];
            
            NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
            [shared setObject:appdelegate.userData.token forKey:@"widget"];
            [shared synchronize];
            
            appdelegate.window.rootViewController = loginVC;
            CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:0];
            [loginVC.view.window.layer addAnimation:animation forKey:nil];
        }
    }
    NSLog(@"==========applicationWillEnterForegloginToMainTabVCround============将要从后台进入前台");
   [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"noticeToLogin" object:nil];
    // 程序从后台回到前台时, 向支付界面发起通知, 校验是否有支付信息
    //饮水支付结果校验
    [[NSNotificationCenter defaultCenter]postNotificationName:PAWaterPayVerfifyNotificaiton object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"==========applicationDidBecomeActive============开始进入前台");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_awakeFormActive" object:nil];
    //创建通知 (通知发往登录页，用于改变登录页白天以及夜晚模式的显示)
    NSNotification *notification =[NSNotification notificationWithName:@"checkTheTime" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"==========applicationWillTerminate============");
    if (!self.userData.isRememberPw.boolValue) {
        [self setTags:nil error:nil];
        self.userData.token = @"";
        self.userData.isLogIn = @NO;
    }
    
    if (!self.userData.isLogIn.boolValue) {
        self.userData.token = @"";
        [self setTags:nil error:nil];
    }
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
    [shared setObject:self.userData.token forKey:@"widget"];
    [shared synchronize];
    [self saveContext];
}

@end
