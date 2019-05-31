//
//  AppDelegate.h
//  TimeHomeApp
//
//  Created by us on 16/1/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CrashException.h"
#import "UserData.h"
#import "PAUserData.h"
#import "UserStatistics.h"
#import "PAAuthority.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

//#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BOOL canGetNewMessage;
    BMKMapManager* _mapManager;
    NSString *trackViewURL;//appstore地址
}
@property(strong,nonatomic)  NSString* huangguangURL;

///用户数据
@property(strong,nonatomic)  PAUserData* userData;
///统计数据
@property (nonatomic, strong) UserStatistics *userStatistics;
///页面开始时间
@property (nonatomic, copy)   NSString *beginTime;
///登录时间
@property (nonatomic, copy)   NSString *loginTime;
///界面KEY值
@property (nonatomic, copy)   NSString *viewkey;

@property (nonatomic, copy)   NSString *main_viewkey;
@property (nonatomic, copy)   NSString *main_beginTime;

@property (strong, nonatomic) UIWindow *window;


///积分是否升级
@property(nonatomic,copy) NSString * isupgrade;

///点击通知的类型
@property(nonatomic,copy) NSString * pushMsgType;
///点击通知 时间
@property(nonatomic,copy) NSString * pushMsgTime;

////-----------------消息存储标记------------
///电梯消息
@property(nonatomic,strong) NSString *liftMsg;
///个人消息
@property(nonatomic,strong) NSString *PersonalMsg;
///社区公告消息
@property(nonatomic,strong) NSString *CommunityNotification;
///社区新闻消息
@property(nonatomic,strong) NSString *CommunityNews;
///社区活动消息
@property(nonatomic,strong) NSString *CommunityActivitys;
///维修消息
@property(nonatomic,strong) NSString * RepairMsg;
///投诉消息
@property(nonatomic,strong) NSString *ComplainMsg;
///帖子消息
@property(nonatomic,strong) NSString *BBSMsg;
///聊天消息
@property(nonatomic,strong) NSString * ChatMsg;

///数据管理器（临时数据库）
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
///数据模型器
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
///数据连接器
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end

