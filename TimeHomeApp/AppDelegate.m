

///极光推送宏定义

#import "BluetoothPresenter.h"

#import "MyTopicPostVC.h"
#import "AppDelegate.h"
#import "DataOperation.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HDActivityPresenter.h"
#import <JMessage/JMessage.h>
#import "ShakePassageVC.h"
//------分享------------------

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "ChatPresenter.h"
#import "Gam_Chat.h"
#import "XMMessage.h"
#import "DateUitls.h"
#import "MainTabBars.h"
#import "LoginVC.h"
#import "PushMsgModel.h"
#import "AppSystemSetPresenters.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DataController.h"
#import "MsgAlertView.h"
#import "NetWorks.h"
#import "CommunityManagerPresenters.h"
#import "LoginVC.h"
#import "AppPayPresenter.h"
#import <sys/utsname.h>
#import "TalkingData.h"
#import <CoreMotion/CoreMotion.h>

#import "LogInPresenter.h"
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

@interface AppDelegate ()<BMKGeneralDelegate,WXApiDelegate,WeiboSDKDelegate>
{
    BMKMapManager* _mapManager;
    NSString *trackViewURL;//appstore地址
    BOOL canGetNewMessage;
    LogInPresenter * logInPresenter;
    Reachability *hostReach;
}
@property (nonatomic, copy) YYPlaySound * yyObj;

@end

@implementation AppDelegate

-(void)sendMeg
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //获取已登录用户
    PAUser *user = [[PAUserManager sharedPAUserManager]user];
    
    
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    ///监测网络情况 区分WiFi 4G 3G 2G WWAN
    [[NetworkMonitoring shareMonitoring]start];
    
    //配置YTKNetwork
    [self configNetwork];
    
    NSLog(@"=======================应用程序启动==========================");
    
    //    [[UIButton appearance] setExclusiveTouch:YES];/** 防止按钮连点 */
    //    [self performSelector:@selector(sendMeg) withObject:nil afterDelay:10];
    
    ///注册微信支付
    [APPWXPAYMANAGER usPay_registerAppWithUrlSchemes:WXAPPID];
    [TalkingData sessionStarted:@"4C8A8FAEBA294E6DB701FF33A9FB3635" withChannelId:@"AppStore"];
    
    canGetNewMessage = YES;
    self.window.backgroundColor = BLACKGROUND_COLOR;
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BDMAP_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图启动失败!");
    }
    ///取出用户数据
    _userData = (UserData *)[[DataOperation sharedDataOperation]queryData:@"UserData"];
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
    [shared setObject:_userData.token forKey:@"widget"];
    [shared setObject:SERVER_URL forKey:@"url"];
    [shared setObject:kCarError_SEVER_URL forKey:@"newUrl"];
    [shared synchronize];
    
    if (!_userData) {
        _userData = (UserData *)[[DataOperation sharedDataOperation]creatManagedObj:@"UserData"];
        _userData.isGuide = [[NSNumber alloc]initWithBool:NO];
    }
    [self setMsgSaveName];/** 设置消息存储名称 */
    
    
    _userStatistics = (UserStatistics *)[[DataOperation sharedDataOperation]queryData:@"UserStatistics"];
    if (!_userStatistics) {
        _userStatistics = (UserStatistics *)[[DataOperation sharedDataOperation] creatManagedObj:@"UserStatistics"];
    }
    
    NSLog(@"--liuliuliuliuliuliu--%@",_userStatistics.viewkey);
    
    ///获取错误日志
    CrashException * crash=[CrashException sharedInstance];
    [crash installExceptionHandler];
    
    ///去掉返回箭头
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    ///注册极光推送
    [self registJPush:launchOptions];
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:ShareSDKAPPKEY
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeTencentWeibo),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeFacebook),
                            @(SSDKPlatformTypeTwitter),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeQZone)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeSinaWeibo:
                         {
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             
                         }
                             break;
                         case SSDKPlatformTypeWechat:
                         {
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                         }
                             break;
                         case SSDKPlatformTypeQQ:
                         {
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                         }
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:SinaWeiboAppKey
                                                appSecret:SinaWeiboAppSecret
                                              redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeTencentWeibo:
                      //设置腾讯微博应用信息
                      [appInfo SSDKSetupTencentWeiboByAppKey:TencentWeiboAppKey
                                                   appSecret:TencentWeiboAppSecret
                                                 redirectUri:@"http://www.sharesdk.cn"];
                      break;
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:WXAPPID
                                            appSecret:WXAPPSECRET];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:QQAPPID
                                           appKey:QQAPPKEY
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
    
    self.pushMsgType=@"0";
    self.pushMsgTime=@"";
    [self loginToMainTabVC:[self checkVersionNeedLogin]];/** 判断是否已登录跳转到主页 */
    
    if (launchOptions) {
        
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        
        if (remoteNotification) {
            
            
            UIApplication *app=[UIApplication sharedApplication];
            app.applicationIconBadgeNumber=0;
            
            self.pushMsgType = [[remoteNotification objectForKey:@"type"] stringValue];
            self.pushMsgTime = [[remoteNotification objectForKey:@"sendtime"] stringValue];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setDictionary:remoteNotification];
            [dic setObject:@YES forKey:@"isclick"];
            if (![self isBeyonbdDays]) {
                [self performSelector:@selector(pushNotice:) withObject:dic afterDelay:1.0];
            }
            
            
        }
        
    }
    
    [self isVersionUpdate];/** 是否强制更新 */
    
    return YES;
    
}
#pragma mark - 获取当前网络状态
/**
 获取当前网络状态
 */
+ (NSString *)getNetWorkStates {
    
    return [[NetworkMonitoring shareMonitoring] state];
    
}

- (void)pushNotice:(id)object {
    
    NSDictionary * cjson   = object;
    
    NSMutableDictionary * userInfo_dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([cjson objectForKey:@"cjson"]) {
        
        [userInfo_dic setDictionary:cjson];
        
    }
    [userInfo_dic setObject:[cjson objectForKey:@"type"] forKey:@"type"];
    [userInfo_dic setObject:@YES forKey:@"isclick"];
    
    NSDictionary * dic = [userInfo_dic objectForKey:@"cjson"];
    NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    
    
    if (type.integerValue == 30101) {
        
        [self synchronousChatData:dic :@""];
        
    }else {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:userInfo_dic];
        
    }
    
    
    
}
#pragma mark - 检测推送是否打开

- (BOOL)checkNotifitionIsOpen {
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if (UIUserNotificationTypeNone == setting.types) {
        NSLog(@"推送关闭 8.0");
        return NO;
    }
    else
    {
        NSLog(@"推送打开 8.0");
        return YES;
    }
    
}

#pragma mark - 判断是否已登录跳转到主页
/**
 判断是否已登录跳转到主页
 */
- (void)loginToMainTabVC:(BOOL)notNeedLogin {
    
    
    /**
     *  判断是否已登录 - 性别，小区为空跳转到完善资料界面
     */
    if(notNeedLogin&&[_userData.isRememberPw boolValue] && _userData.isLogIn.boolValue && self.userData.sex.intValue != 0 && ![self.userData.communityid isEqualToString:@"0"] && ![XYString isBlankString:self.userData.communityid] && ![self isBeyonbdDays]) {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
        MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
        self.window.rootViewController=MainTabBar;
        [AppSystemSetPresenters getBindingTag];
        MainTabBar.tabBarController.tabBar.hidden = NO;
        MainTabBar.hidesBottomBarWhenPushed = NO;
    }
}
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    NSLog(@"request====%@",request);
}
/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSLog(@"response====%@",response);
}

#pragma mark - 极光推送
-(void)registJPush:(NSDictionary *)launchOptions
{
    
    /**
     *极光
     *
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
-(void)didRegisterAction:(NSNotification *)notification
{
    NSLog(@"Registration ID===%@",notification.userInfo);
}

#pragma mark - 消息分类处理统计计数
/*
-(void)dealPushMsg:(NSDictionary *)dic :(NSString *)message :(NSString *)type {
    
    switch (type.integerValue) {
            
        case 10001://10001	个人消息：你的账户被多次举报请不要再违规
        case 10002://后台为用户重置密码：您的账号密码已重置为此手机号的后六位，请使用登录
        case 10003://请下载时代社区App地址[下载地址],开启您的时代。账号为手机号，密码手机号后六位
        case 10101://获得车位权限：您已获得车位[车位名称]的使用权限
        case 10102://失去车位权限：您已失去车位[车位名称]的使用权限
        case 10103://获得房产权限：您已获得房产[门牌号]的操作权限
        case 10104://失去房产权限：您已失去房产[门牌号]的操作权限
        case 10105://业主变更后台审核通过：您已通过XX小区的业主认证，去试试业主专享功能吧~
        case 10106://业主变更审核不通过：您未通过XX小区的业主认证，请填写准确信息后再次提交申请
        case 10113://车牌纠错推送
            
        case 10121://社区认证审核成功 您在时代社区1栋2单元2908室的房产认证成功，恭喜您成为该社区的认证业主。 map{“id”:”123dfdf3er13df”,”state”:1}
        case 10122://社区认证审核失败 您在时代社区1栋2单元2908室的房产认证审核失败，失败原因：您提供的业主信息有误，房产信息不对。 map{“id”:”123dfdf3er13df”,”state”:2}
            
        case 60001://大赛：审核通过：恭喜，您上传的摄影大赛作品[作品名称]已经审核通过，作品编号XX
        case 60002://大赛：未审核通过：非常遗憾，您上传的摄影大赛作品[作品名称]未审核通过
        case 20301://反馈回复
        case 30001://点赞
        case 30002://评论
        case 30003://回复评论
        case 30091:///帖子审核不通过
        case 30092:///帖子(删除)
        case 30093:///带红包帖子审核不通过推送
        case 30094:///用户禁言推送
        case 30999:///红包过期
        case 30292:///投票贴(投票时间结束)
        case 30311:///问答帖(收到奖励后推送)
        case 30312:///问答帖(采纳后推送)
        case 30392:///问答帖(奖励退回的推送)
        case 30492:///房产贴(房产贴线上时间到期)
        case 30501:///微信核销
        case 50001://车辆锁定状态出库：车辆[车牌号]的防盗装置发出警报，请立即处理
        case 50202://二轮车共享接口推送
        case 50203://二轮车定时锁车解锁修改接口推送
        case 50209://后台删除自行车
        case 90101:////新增定运营定制推送消息
        case 90201:////新增定运营定制推送消息
        case 90202:////新增定运营定制推送消息
        case 80001://赠送票券推送
        case 80002://即将到期兑换券推送
        {
            
            ///权限变更以后重新获取用户蓝牙摇一摇权限
            [self getBlueTouchData];
            [self addMsgCount:dic :message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
            
        }
            break;
        case 50002://您的车辆已入库
        {
            [AppDelegate showToastMsg:@"您的车辆已入库" Duration:2.5f];
            [self addMsgCount:dic :message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
            
        }
            break;
        case 50003://您的车辆已出库
        {
            
            [AppDelegate showToastMsg:@"您的车辆已出库" Duration:2.5f];
            [self addMsgCount:dic :message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
            
        }
            break;
            
            
        case 20001://社区公告：[公告]公告标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///community notification
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.CommunityNotification];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type = [dic objectForKey:@"type"];
            
            //            pushMsg.content = message;
            
            NSDictionary *diction = [message mj_JSONObject];
            if(pushMsg.content!=nil&&pushMsg.content.length>0)
            {
                pushMsg.content=[NSString stringWithFormat:@"%@,%@",pushMsg.content,[diction objectForKey:@"content"]];
            }
            else
            {
                pushMsg.content=[diction objectForKey:@"content"];
            }
            
            num = [NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg = num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.CommunityNotification];
            ///收到个人聊天消息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
        }
            break;
        case 20002://社区新闻：[新闻]新闻标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.CommunityNews];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.CommunityNews];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 20003://社区活动：[活动]活动标题 map:{“id”:”2323”,”gotourl”:”http://...”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.CommunityActivitys];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.CommunityActivitys];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
            
            //-----------------------报修相关推送----------------------------------------------
            
        case 20101://物业已接收：XX物业已接收您的报修申请，正在分派维修人员 map:{“id”:”2323”}
            
        case 20102://维修处理中：维修人员[姓名]正在处理您的报修  map:{“id”:”2323”,“visitlinkman”:”张三”,”visitlinkphone”:”1232323232”}
            
        case 20103://物业驳回：您的报修因[驳回原因]被驳回，请完善信息后重新提交 map:{“id”:”2323”}
            
        case 20104://暂不维修：XX物业暂时无法处理你的报修申请 map:{“id”:”2323”}
            
        case 20105://已完成 待评价：您的报修已处理完成，给个评价吧  map:{“id”:”2323”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.RepairMsg];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            
            NSDictionary * map=[dic objectForKey:@"map"];
            if(pushMsg.content!=nil&&pushMsg.content.length>0)
            {
                pushMsg.content=[NSString stringWithFormat:@"%@,%@",pushMsg.content,[map objectForKey:@"id"]];
            }
            else
            {
                pushMsg.content=[map objectForKey:@"id"];
            }
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.RepairMsg];
            ///收到个人聊天消息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 20201://投诉回复：您的投诉XX物业已回复 map:{“id”:”2323”}
        {
            ///计数统计 按识别码
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.ComplainMsg];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
                pushMsg.content=@"";
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            
            NSDictionary * map=[dic objectForKey:@"map"];
            if(pushMsg.content!=nil&&pushMsg.content.length>0)
            {
                pushMsg.content=[NSString stringWithFormat:@"%@,%@",pushMsg.content,[map objectForKey:@"id"]];
            }
            else
            {
                pushMsg.content=[map objectForKey:@"id"];
            }
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.ComplainMsg];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
            
        case 30101://收到个人聊天消息：“昵称：内容” 滑动查看，最多显示两行 map:{“maxid”:1221,”userid”:”dsfd”,”userpic”:”http://...”,”nickname”:””,”msgtype”:”1”}
        {
            [self synchronousChatData:dic :message];
        }
            break;
        case 50201://你的自行车疑似被盗
        {
            //自行车被盗报警
            [self addMsgCount:dic :message];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
        }
            break;
        case 70001://摇摇通行电梯操作
        {
            NSNumber * num;
            PushMsgModel * pushMsg=(PushMsgModel * )[UserDefaultsStorage getDataforKey:self.liftMsg];
            if (pushMsg==nil) {
                pushMsg=[PushMsgModel new];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            NSInteger tmp=pushMsg.countMsg.integerValue;
            pushMsg.type=[dic objectForKey:@"type"];
            pushMsg.content=message;
            num=[NSNumber numberWithInteger:++tmp];
            pushMsg.countMsg=num;
            [UserDefaultsStorage saveData:pushMsg forKey:self.liftMsg];
            
            ///摇摇通行电梯操作
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
            
        }
#pragma mark 车辆出库入库消息
            //给未注册手机号添加车位
        case 200309:{
            break;
        }
            //给未注册手机号关联车牌号
        case 200310:{
            break;
        }
            
            break;
            
        default:
            break;
    }
    
}
 */
#pragma mark - 透传消息
-(void)receiveMessage:(NSNotification *)notification
{
    NSLog(@"自定义消息======%@=====",notification.userInfo);
    NSString * message = [notification.userInfo objectForKey:@"content"];
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *pushDic =  [DataController dictionaryWithJsonData:jsonData];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setDictionary:pushDic];
    [dic setObject:@NO forKey:@"isclick"];
    NSLog(@"===消息处理==%@",message);
    NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    
    //[self dealPushMsg:dic :message :type];
    
    [PANoticeManager managerOldReceiveMessage:dic message:message type:type];
    [PANoticeManager manageJPushReceiveMessage:dic];
}
#pragma mark - 设置推送标签

- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error
{
    
    NSLog(@"设置tags");
    
    if (aTag==nil||aTag.count==0) {
        
        [JPUSHService setTags:[NSSet set] callbackSelector:nil object:nil];
    }
    else
    {
        NSSet * setTag = [NSSet setWithArray:aTag];
        
        [JPUSHService setTags:setTag callbackSelector:@selector(bieMingLog) object:nil];
        
    }
    
    return YES;
}
-(void)networkDidRegister:(NSNotification *)notification
{
    //创建设备别名
    NSLog(@"推送registid创建设备别名==%@", [JPUSHService registrationID]);
    
}
-(void)bieMingLog
{
    NSLog(@"创建成功！");
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.usnoon.050804.TimeHomeApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TimeHomeApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TimeHomeApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES,NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        /** 闪退代码 */
        //            abort();
        NSLog(@"应用应该崩溃了，暂时注释掉崩溃的代码");
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
    
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            /** 闪退代码 */
            //            abort();
            NSLog(@"应用应该崩溃了，暂时注释掉崩溃的代码");
        }
    }
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"百度地图联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"百度地图授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //    rootViewController.deviceTokenValueLabel.text =
    //    [NSString stringWithFormat:@"%@", deviceToken];
    //    rootViewController.deviceTokenValueLabel.textColor =
    //    [UIColor colorWithRed:0.0 / 255
    //                    green:122.0 / 255
    //                     blue:255.0 / 255
    //                    alpha:1];
    NSString * _deviceToken = @"";
    _deviceToken = [[NSString stringWithFormat:@"%@", deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", _deviceToken);
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", _deviceToken]);
    
    [JPUSHService registerDeviceToken:deviceToken];
    
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
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

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"推送消息===%@",userInfo);
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive) {
        
        NSLog(@"收到通知= 点击==fetchCompletionHandler=:%@", [self logDic:userInfo]);
        self.pushMsgType =[NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"type"] integerValue]];
        self.pushMsgTime=[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"sendtime"]];
        NSLog(@"pushMsgType====%@   pushTitle===%@",self.pushMsgType,self.pushMsgTime);
        
    }else if([UIApplication sharedApplication].applicationState==UIApplicationStateActive)
    {
        
        NSLog(@"收到通知===fetchCompletionHandler=:%@", [self logDic:userInfo]);
        AudioServicesPlaySystemSound(1007);
        
    }else {
        
        NSLog(@"收到通知22===fetchCompletionHandler=:%@", [self logDic:userInfo]);
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
    
}

#pragma mark - 收到苹果推送----点击进入
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive) {
        
        if (![self isBeyonbdDays]) {
            
            [PANoticeManager manageNotification:userInfo];

            [PANoticeManager managerOldNotification:userInfo];
            
            NSLog(@"收到通知= 点击==fetchCompletionHandler=:%@", [self logDic:userInfo]);
            self.pushMsgType =[NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"type"] integerValue]];
            
            self.pushMsgTime=[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"sendtime"]];
            
            NSLog(@"pushMsgType====%@   pushTitle===%@",self.pushMsgType,self.pushMsgTime);
            /*
            NSMutableDictionary * userInfo_dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            
            if ([userInfo objectForKey:@"cjson"]) {
                
                [userInfo_dic setDictionary:userInfo];
                
            }
            [userInfo_dic setObject:[userInfo objectForKey:@"type"] forKey:@"type"];
            [userInfo_dic setObject:@YES forKey:@"isclick"];
            
            
            NSDictionary * dic = [userInfo objectForKey:@"cjson"];
            NSString * type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
            
            if (type.integerValue == 30101) {
                
                [self synchronousChatData:dic :@""];
                
            }else
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:userInfo_dic];
            }
             */
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

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
    NSLog(@"收到通知===didReceiveLocalNotification=:%@", @"");
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    //    [NSPropertyListSerialization propertyListFromData:tempData
    //                                     mutabilityOption:NSPropertyListImmutable
    //                                               format:NULL
    //                                     errorDescription:NULL];
    return str;
}


#pragma  mark -------------获取当前显示的UIViewController-------------
- (UIViewController *)getCurrentViewController
{
    UIViewController *appRootVC =self.window.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
////显示消息提示并自动消失
+(void)showToastMsg:(NSString *)message Duration:(float)duration {
    
    if([XYString isBlankString:message]) {
        return;
    }
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    
    showview.alpha = 1.0f;
    showview.layer.cornerRadius  =5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    
    UILabel *label = [[UILabel alloc]init];
    
    CGSize LabelSize = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    label.frame = CGRectMake(10, 10, LabelSize.width, LabelSize.height);
    label.text  = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 0; //
    
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width)/2-10, SCREEN_HEIGHT/2, LabelSize.width+20, LabelSize.height+20);
    //    [UIView animateWithDuration:duration animations:^{
    //        showview.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        [showview removeFromSuperview];
    //    }];
    
    //    window.userInteractionEnabled = NO;
    
    // 第一步：将view宽高缩至无限小（点）
    showview.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                0.9, 0.9);
    [UIView animateWithDuration:0.2 animations:^{
        // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
        showview.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            // 第三步： 以动画的形式将view恢复至原始大小
            showview.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration / 2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                    showview.transform =
                    CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                        showview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                        
                    } completion:^(BOOL finished) {
                        
                        // 第三步： 移除
                        [showview removeFromSuperview];
                        //                        window.userInteractionEnabled = YES;
                        
                    }];
                    
                }];
                
            });
            
        }];
        
    }];
    
}

#pragma mark - 设置消息存储名称
/**
 设置消息存储名称
 */
-(void)setMsgSaveName
{
    ////-----------------消息存储标记------------
    ///个人消息
    self.PersonalMsg = [NSString stringWithFormat:@"PersonalMsg%@",_userData.userID];
    ///社区公告
    self.CommunityNotification = [NSString stringWithFormat:@"CommunityNotification%@%@",_userData.userID,_userData.communityid];
    ///社区新闻
    self.CommunityNews = [NSString stringWithFormat:@"CommunityNews%@%@",_userData.communityid,_userData.userID];
    ///社区活动
    self.CommunityActivitys = [NSString stringWithFormat:@"CommunityActivitys%@%@",_userData.communityid,_userData.userID];
    ///维修
    self.RepairMsg = [NSString stringWithFormat:@"RepairMsg%@%@",_userData.communityid,_userData.userID];
    ///投诉
    self.ComplainMsg = [NSString stringWithFormat:@"ComplainMsg%@%@",_userData.communityid,_userData.userID];
    
    ///聊天
    self.BBSMsg=[NSString stringWithFormat:@"BBSMsg%@",_userData.userID];
    self.ChatMsg=[NSString stringWithFormat:@"ChatMsg%@",_userData.userID];
    
    ///电梯
    self.liftMsg=[NSString stringWithFormat:@"liftMsg%@",_userData.userID];
}

#pragma mark - 是否需要强制更新
/**
 是否需要强制更新 (返回参数为errcode ,errmsg,updstate, updstate 1为强制更新，2为普通更新，3为不更新，errcode统一返回0)
 */
- (void)isVersionUpdate {
    
    [AppSystemSetPresenters isVersionUpdWithVersion:kCurrentVersion UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            UIViewController *currentVC = [self getCurrentViewController];
            //            L_UpdateVC *updateVC = [L_UpdateVC getInstance];
            //            [updateVC showVC:currentVC withMsg:@"" withVersion:@"2.5.2" cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
            //
            //            }];
            
            if (resultCode == SucceedCode) {
                
                NSString *updateState = [NSString stringWithFormat:@"%@",data[@"updstate"]];
                
                if (updateState.integerValue == 1) {
                    /** 强制更新 */
                    [self updateSoftVersionWithUpdateState:1];
                    
                }else if (updateState.integerValue == 2) {
                    /** 普通更新 */
                    [self updateSoftVersionWithUpdateState:2];
                    
                }else if (updateState.integerValue == 3) {
                    /** 不更新 */
                    
                }
                
            }
            
        });
        
    }];
    
}

#pragma ---------    检测版本升级
-(void)updateSoftVersionWithUpdateState:(NSInteger)updateState {
    
    NSString * versionStr = [[NSUserDefaults standardUserDefaults]objectForKey:IOS_VERSION_UPGRADE];
    
    if ([XYString isBlankString:versionStr]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:IOS_VERSION_UPGRADE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }else  {
        
        versionStr = [NSString stringWithFormat:@"%ld",versionStr.integerValue+1];
        if(versionStr.integerValue > 1000){
            versionStr  = @"1";
        }
        [[NSUserDefaults standardUserDefaults]setObject:versionStr forKey:IOS_VERSION_UPGRADE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    //NSData *postData = [@"" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:APP_URL]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    //设置http-header:Content-Type。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    //[request setHTTPBody:postData];
    
    [NetWorks NSURLSessionVersionForRequst:request CompleteBlock:^(id  _Nullable data, ResultCode resultCode, NSError * _Nullable Error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode) {
                
                if (data) {
                    
                    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"==%@",aString);
                    
                    NSDictionary * jsonDic=[DataController dictionaryWithJsonData:data];
                    NSNumber * resultCount=[jsonDic objectForKey:@"resultCount"];
                    if (resultCount.integerValue==1) {
                        
                        NSArray* infoArray = [jsonDic objectForKey:@"results"];
                        
                        if (infoArray.count>0) {
                            
                            NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
                            
                            NSString* appStoreVersion = [releaseInfo objectForKey:@"version"];
                            NSString * appstoreV = appStoreVersion;
                            
                            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                            
                            appStoreVersion=[appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:IOS_LAST_VERSION_NO];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                            NSLog(@"苹果商店版本号： %@",appStoreVersion);
                            NSLog(@"用户当前版本号： %@",currentVersion);
                            
                            if (updateState == 1) {
                                /** 强制更新 */
                                if (currentVersion.intValue < appStoreVersion.intValue ) {
                                    
                                    trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                                    NSString* msg =[releaseInfo objectForKey:@"releaseNotes"];
                                    
                                    UIViewController *currentVC = [self getCurrentViewController];
                                    L_UpdateVC *updateVC = [L_UpdateVC getInstance];
                                    updateVC.type = 1;
                                    [updateVC showVC:currentVC withMsg:msg withVersion:appstoreV cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                        
                                        if (index == 1) {
                                            
                                            UIApplication *application = [UIApplication sharedApplication];
                                            [application openURL:[NSURL URLWithString:trackViewURL]];
                                            exit(0);
                                            
                                        }
                                        
                                    }];
                                    
                                    //                                    MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
                                    //
                                    //                                    [msgV showMsgViewForMsg:[NSString stringWithFormat:@"有新版本%@开始体验吧",appstoreV] btnOk:@"确定" btnCancel:@"" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index){
                                    //
                                    //                                        if(index==100) {
                                    //
                                    //                                            UIApplication *application = [UIApplication sharedApplication];
                                    //                                            [application openURL:[NSURL URLWithString:trackViewURL]];
                                    //                                            exit(0);
                                    //                                        }
                                    //
                                    //                                    }];
                                    
                                }
                                
                            }else if (updateState == 2) {
                                /** 普通更新 */
                                
                                if (currentVersion.intValue < appStoreVersion.intValue && (versionStr.integerValue % 3 == 0)) {
                                    
                                    trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                                    NSString* msg = [releaseInfo objectForKey:@"releaseNotes"];
                                    
                                    UIViewController *currentVC = [self getCurrentViewController];
                                    L_UpdateVC *updateVC = [L_UpdateVC getInstance];
                                    [updateVC showVC:currentVC withMsg:msg withVersion:appstoreV cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                        
                                        if (index == 1) {
                                            
                                            UIApplication *application = [UIApplication sharedApplication];
                                            [application openURL:[NSURL URLWithString:trackViewURL]];
                                            
                                        }
                                        
                                    }];
                                    
                                    //                                    MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
                                    //
                                    //                                    [msgV showMsgViewForMsg:[NSString stringWithFormat:@"有新版本%@开始体验吧",appstoreV] btnOk:@"确定" btnCancel:@"以后再说" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index){
                                    //
                                    //                                        if(index==100) {
                                    //                                            UIApplication *application = [UIApplication sharedApplication];
                                    //                                            [application openURL:[NSURL URLWithString:trackViewURL]];
                                    //                                        }
                                    //                                    }];
                                }
                            }
                        }
                    }
                }
            }
        });
    }];
}

///获取蓝牙设备权限数据
-(void)getBlueTouchData
{
    
    [CommunityManagerPresenters getUserBluetoothUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                
                NSArray *array=(NSArray *)data;
                if([data isKindOfClass:[NSArray class]])
                {
                    if(array==nil||array.count==0)
                    {
                        return ;
                    }
                    [UserDefaultsStorage saveData:array forKey:@"UserUnitKeyArray"];
                }
            }
            else
            {
                //                 [self showToastMsg:data Duration:5.0];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *errmessage = data[@"errmsg"];
                    
                    [UserDefaultsStorage saveData:@[] forKey:@"UserUnitKeyArray"];
                    [UserDefaultsStorage saveData:errmessage forKey:@"Blue_errmessage"];
                }
            }
            
        });
        
    }];
    
}

#pragma mark - 微信支付回调--------2016.12.5修改
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    BOOL isWeixin = [APPWXPAYMANAGER usPay_handleUrl:url];
    if (isWeixin) {
        return isWeixin;
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //    NSLog(@"url=====%@ \n  sourceApplication=======%@ \n  annotation======%@", url, sourceApplication, annotation);
    
    BOOL isWeixin = [APPWXPAYMANAGER usPay_handleUrl:url];
    if (isWeixin) {
        return isWeixin;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (APPWXPAYMANAGER.appAlipayCallBack) {
                APPWXPAYMANAGER.appAlipayCallBack(resultDic);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            if (APPWXPAYMANAGER.appAlipayCallBack) {
                APPWXPAYMANAGER.appAlipayCallBack(resultDic);
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    return YES;
    
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    
    
    BOOL isWeixin = [APPWXPAYMANAGER usPay_handleUrl:url];
    if (isWeixin) {
        return isWeixin;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (APPWXPAYMANAGER.appAlipayCallBack) {
                APPWXPAYMANAGER.appAlipayCallBack(resultDic);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            if (APPWXPAYMANAGER.appAlipayCallBack) {
                APPWXPAYMANAGER.appAlipayCallBack(resultDic);
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    return YES;
}

#pragma mark - 获取手机型号

- (NSString *)iphoneType {
    
    //    需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"])  return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,4"])  return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"])  return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,5"])  return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"])  return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone10,6"])  return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

#pragma mark - 检查用户版本是否需要重新登录

-(BOOL)checkVersionNeedLogin
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString * lastVsersion = [[NSUserDefaults standardUserDefaults]objectForKey:IOS_LAST_VERSION_NO];
    if (![XYString isBlankString:lastVsersion]) {
        
        if (lastVsersion.integerValue<currentVersion.integerValue) {
            _userData.isLogIn = @NO;
            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:IOS_LAST_VERSION_NO];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self saveContext];
            
            ///首页蒙版
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"needTheView"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            return NO;
        }
        
    }else {
        
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:IOS_LAST_VERSION_NO];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"needTheView"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return YES;
        
    }
    ///首页蒙版
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"needTheView"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return YES;
}

#pragma mark - 数据统计

-(void)addStatistics:(NSDictionary *)statisticsDic {
    
    if (![XYString isBlankString:statisticsDic[@"viewkey"]]) {
        
        //判断用户进入的页面和离开时的界面是否为同一个页面 如果是则统计用户数据
        if (
            [self.viewkey      isEqualToString:statisticsDic[@"viewkey"]]||
            [self.main_viewkey isEqualToString:statisticsDic[@"viewkey"]]
            )
        {
            
            _userStatistics.viewkey = statisticsDic[@"viewkey"];
            
        }else
        {
            return;
        }
        
    }else
    {
        return;
    }
    
    if (self.userData.userID) {
        _userStatistics.userid = self.userData.userID;
    }
    if (self.userData.communityid) {
        _userStatistics.communityid = self.userData.communityid;
    }
    if (![XYString isBlankString:statisticsDic[@"postid"]]) {
        _userStatistics.postid = statisticsDic[@"postid"];
    }else {
        _userStatistics.postid = @"";
    }
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
    _userStatistics.endtime = [NSString stringWithFormat:@"%ld",timeSp];
    
    [self saveContext];
    
}
-(void)markStatistics:(NSString *)viewkey {
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
    
    if ([viewkey isEqualToString:ShouYe]||[viewkey isEqualToString:LinQu]||[viewkey isEqualToString:WoDe]||[viewkey isEqualToString:XiaoXi]) {
        
        self.main_viewkey = viewkey;
        self.main_beginTime = [NSString stringWithFormat:@"%ld",timeSp];
        
    }else {
        
        self.viewkey = viewkey;
        self.beginTime = [NSString stringWithFormat:@"%ld",timeSp];
        
    }
    
}


#pragma mark -- 上传用户统计数据
-(void)uploadStatisticsData
{
#if 0
    NSArray * arr = [[DataOperation sharedDataOperation]queryDataStatistics:@"UserStatistics"];
    NSArray * dicArr = [UserStatistics mj_keyValuesArrayWithObjectArray:arr];
    
    if (@"上传数据成功以后") {
        
        ///删除上传后数据
        //[[DataOperation sharedDataOperation]deleteStatisticsData:arr];
        
    }else{
        
    }
#endif
}

//MARK: - 获取当前时间
- (void)getNowTime {
    NSString *beginTimeStr = [DateUitls getTodayDateFormatter:@"YYYY:mm:dd"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:beginTimeStr forKey:@"beginLoginTime"];//保存登录时间
    //    [userDefaults setObject:_TF_Account.text forKey:@"userPhoneNumber"];//保存用户账号
    
}

#pragma mark - app消息计数

-(void)addMsgCount:(NSDictionary *)dic :(NSString *)message {
    
    NSNumber * num;
    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.PersonalMsg];
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    NSInteger tmp=pushMsg.countMsg.integerValue;
    pushMsg.type=[dic objectForKey:@"type"];
    pushMsg.content=message;
    num=[NSNumber numberWithInteger:++tmp];
    pushMsg.countMsg=num;
    [UserDefaultsStorage saveData:pushMsg forKey:self.PersonalMsg];
}

#pragma mark - 同步聊天消息
-(void)synchronousChatData:(NSDictionary *)dic :(NSString *)message
{
    
    [self addMsgCount:dic :message];
    ///计数统计 按识别码
    NSNumber * num;
    PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:self.ChatMsg];
    if (pushMsg==nil) {
        pushMsg=[PushMsgModel new];
        pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
    }
    NSInteger tmp=pushMsg.countMsg.integerValue;
    pushMsg.type=[dic objectForKey:@"type"];
    pushMsg.content = message;
    num=[NSNumber numberWithInteger:++tmp];
    pushMsg.countMsg = num;
    [UserDefaultsStorage saveData:pushMsg forKey:self.ChatMsg];
    
    NSNumber * maxid = [[NSUserDefaults standardUserDefaults]objectForKey:@"maxid"];
    
    ///根据用户ID 存储maxid
    if ([XYString isBlankString:self.userData.userID]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:maxid forKey:self.userData.userID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (maxid == nil) {
        maxid = @(0);
    }
    NSLog(@"------------聊天maxid打印%@",maxid);
    if (canGetNewMessage) {
        canGetNewMessage = NO;
        [ChatPresenter getUserGamSync:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                canGetNewMessage = YES;
                
                if(resultCode == SucceedCode)
                {
                    NSArray * list = data;
                    NSLog(@"聊天消息获取---------%@",data);
                    
                    for (int i = 0;i<list.count ;i++) {
                        
                        NSDictionary * map  = [list objectAtIndex:i];
                        NSString * content = [map objectForKey:@"content"];
                        NSString * fileurl = [map objectForKey:@"fileurl"];
                        NSString * msgtype = [map objectForKey:@"msgtype"];
                        NSString * senduserid = [map objectForKey:@"senduserid"];
                        NSString * sendusername = [map objectForKey:@"sendusername"];
                        NSString * senduserpic = [map objectForKey:@"senduserpic"];
                        NSString * systime = [map objectForKey:@"systime"];
                        //                                NSString * type = [map objectForKey:@"type"];
                        NSDate * systime_date = [DateUitls DateFromString:systime DateFormatter:@"YYYY-MM-dd HH:mm:ss"];
                        
                        Gam_Chat * GC = (Gam_Chat *)[[DataOperation sharedDataOperation]creatManagedObj:@"Gam_Chat"];
                        GC.chatID = senduserid;
                        GC.sendID = senduserid;
                        
                        GC.isFirstMsg = @(YES);
                        GC.systime = systime_date;
                        GC.headPicUrl = senduserpic;
                        
                        [[DataOperation sharedDataOperation] queryData:@"Gam_Chat" withHeadPicUrl:senduserpic andChatID:senduserid andnikeName:sendusername];
                        
                        GC.isRead = @(NO);
                        GC.ownerType = @(XMMessageOwnerTypeOther);
                        GC.sendName = sendusername;
                        if(_userData!=nil&&_userData.userID!=nil)
                        {
                            GC.userID=_userData.userID;
                            GC.receiveID = self.userData.userID;
                            
                        }
                        GC.msgType = @(msgtype.integerValue);
                        ///0 文字 1 照片 2 语音
                        if (msgtype.integerValue==0) {
                            GC.cellIdentifier = @"XMTextMessageCell";
                            GC.content = content;
                            
                        }
                        else if(msgtype.integerValue==1)
                        {
                            GC.cellIdentifier = @"XMImageMessageCell";
                            GC.contentPicUrl = fileurl;
                            GC.content = @"[图片]";
                            
                        }else if(msgtype.integerValue==2)
                        {
                            GC.cellIdentifier = @"XMVoiceMessageCell";
                            GC.voiceUrl = fileurl;
                            NSLog(@"录音文件－－－%@",fileurl);
                            GC.seconds = @(content.intValue);
                            GC.content = @"[语音]";
                            GC.voiceUnRead = @(YES);
                        }else if(msgtype.integerValue == 3)
                        {
                            
                            GC.cellIdentifier = @"XMMImageTextMessageCell";
                            GC.contentPicUrl = fileurl;
                            GC.content = content;
                        }else
                        {
                            GC.cellIdentifier = @"XMTextMessageCell";
                            GC.content = content;
                        }
                        
                        
                        [[DataOperation sharedDataOperation]save];
                        
                    }
                    
                    ///收到个人聊天消息
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:dic];
                    
                }
                
            });
            
        } withMaxID:[NSString stringWithFormat:@"%@",maxid]];
        
    }
    
}


#pragma mark ----- 判断60天未登录
- (BOOL)isBeyonbdDays {
    
    NSString *nowTimeStr = [DateUitls getTodayDateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *beginTime = [userDefaults objectForKey:@"beginLoginTime"];
    NSInteger days = [DateUitls calcDaysFromBeginForString:nowTimeStr today:beginTime];
    //    NSInteger daysssss = [[self intervalFromLastDate:beginTime toTheDate:nowTimeStr] integerValue];
    
    if (days > 60) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"clearPassWord"];
        [userDefaults synchronize];
        _userData.isLogIn = @NO;
        [self saveContext];
        return YES;
    }
    return NO;
}

- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    //        min = [min substringToIndex:min.length-7];
    //    秒
    sen=[NSString stringWithFormat:@"%@", sen];
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    //        min = [min substringToIndex:min.length-7];
    //    分
    min=[NSString stringWithFormat:@"%@", min];
    //    小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    //        house = [house substringToIndex:house.length-7];
    house=[NSString stringWithFormat:@"%@", house];
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    return min;
}

#pragma mark - Network

// Get IP Address
- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

-(void)configNetwork{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    
    //为所有YTKNetwork 的API统一添加参数
    //    PARequestArgumentsFilter *urlFilter = [PARequestArgumentsFilter filterWithArguments:@{@"appId": @"APP_H5"}];
    //    [config addUrlFilter:urlFilter];
    
    config.baseUrl = PA_NEW_SEVER_URL;
    config.cdnUrl = SERVER_PIC_URL;
}


@end
