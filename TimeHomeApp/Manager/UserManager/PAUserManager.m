//
//  PAUserManager.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAUserManager.h"
#import "LogInPresenter.h"
#import "AppDelegate+JPush.h"
@implementation PAUserManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PAUserManager)
-(instancetype)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(receivedTokenInvalidNotification:) name:PAUserTokenInvalidNotification object:nil];
        
    }
    
    return self;
}
-(PAUser *)user{
    return nil;
}
-(void)loginWithUserModel:(PAUser *)user{
}
-(void)logout{
    
//    self.user = nil;
//    //清空持久化的用户数据
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUserDefaultsKeyUserInfo];
//    ///删除推送注册的别名
//    [SHNotificationManager deleteAlias];
    
    AppDelegate *appDlt = GetAppDelegates;
    //重置推送设置
    [appDlt setTags:nil error:nil];
    //重置用户登陆状态
    appDlt.userData.isLogIn = @(NO);
    [appDlt saveContext];
}

#pragma mark - Notification

-(void)receivedTokenInvalidNotification:(NSNotification*)notification{
  
    [self logout];
    [LogInPresenter ReLogInForYTKNetwork];
    
}

-(void)updataUserInfo:(PAUserInfo *)userinfo{
    /*持久化用户基础信息*/
    AppDelegate *appdelegate = GetAppDelegates;
    appdelegate.userData.userID = userinfo.userID;
    appdelegate.userData.phone = userinfo.phone;
    appdelegate.userData.userpic = userinfo.userpic;
    appdelegate.userData.nickname = userinfo.nickname;
    appdelegate.userData.name = userinfo.name;
    appdelegate.userData.sex = userinfo.sex;
    appdelegate.userData.birthday = [[NSDate dateWithString:userinfo.birthday format:@"yyyy-MM-dd"] stringWithFormat:@"yyyy/MM/dd"];
    appdelegate.userData.signature = userinfo.signature;
//    appdelegate.userData.isupgrade = userinfo.isupgrade;
    appdelegate.userData.integral = userinfo.isupgrade;
//    appdelegate.userData.gradelevel = userinfo.isupgrade;
    appdelegate.userData.balance = userinfo.balance;
    [appdelegate saveContext];

}
-(void)integrationUserData:(PAUser *)user{
    
    /*持久化用户基础信息*/
    AppDelegate *appdelegate = GetAppDelegates;
    appdelegate.userData.token = user.userinfo.token;
    appdelegate.userData.userID = user.userinfo.userID;
    appdelegate.userData.phone = user.userinfo.phone;
    appdelegate.userData.userpic = user.userinfo.userpic;
    appdelegate.userData.nickname = user.userinfo.nickname;
    appdelegate.userData.name = user.userinfo.name;
    appdelegate.userData.sex = user.userinfo.sex;
    appdelegate.userData.birthday = [[NSDate dateWithString:user.userinfo.birthday format:@"yyyy-MM-dd"] stringWithFormat:@"yyyy/MM/dd"];
    appdelegate.userData.signature = user.userinfo.signature;
    appdelegate.userData.building = user.communityInfo.building;
    appdelegate.userData.residenceid = user.communityInfo.residenceid;
    appdelegate.userData.residencename = user.communityInfo.residencename;
    appdelegate.userData.selftag = @"";
    
    /*当前社区信息持久化*/
    appdelegate.userData.communityid = user.communityInfo.communityid;
    appdelegate.userData.communityname = user.communityInfo.communityname;
    appdelegate.userData.communityaddress = user.communityInfo.communityaddress;
    appdelegate.userData.countyid = user.communityInfo.countyid;
    appdelegate.userData.countyname = user.communityInfo.countyname;
    appdelegate.userData.cityid = user.communityInfo.cityid;
    appdelegate.userData.cityname = user.communityInfo.cityname;
    appdelegate.userData.lat = user.communityInfo.lat;
    appdelegate.userData.lng = user.communityInfo.lng;
    appdelegate.userData.carprefix = user.communityInfo.carprefix;
    appdelegate.userData.openmap = [user.communityInfo.powerInfo mj_keyValues];
    [appdelegate saveContext];
    /*持久化当前社区权限*/
    [UserDefaultsStorage saveData:user.communityInfo.powerInfo.isresipower forKey:@"resipower"];
    NSArray *authorityArray = [NSArray yy_modelArrayWithClass:[PAAuthorityModel class] json:user.powerConfig];
    [[PAAuthorityManager sharedPAAuthorityManager] updateAuthorityWithcommunityId:user.communityInfo.communityid andArray:authorityArray];
}

-(void)updataCommunityInfo:(PACommunityInfo *)communityInfo powerArr:(NSArray *)powerArr{
    
    /*持久化用户基础信息*/
    AppDelegate *appdelegate = GetAppDelegates;
    appdelegate.userData.building = communityInfo.building;
    appdelegate.userData.residenceid = communityInfo.residenceid;
    appdelegate.userData.residencename = communityInfo.residencename;
    appdelegate.userData.selftag = @"";
    /*当前社区信息持久化*/
    appdelegate.userData.communityid = communityInfo.communityid;
    appdelegate.userData.communityname = communityInfo.communityname;
    appdelegate.userData.communityaddress = communityInfo.communityaddress;
    appdelegate.userData.countyid = communityInfo.countyid;
    appdelegate.userData.countyname = communityInfo.countyname;
    appdelegate.userData.cityid = communityInfo.cityid;
    appdelegate.userData.cityname = communityInfo.cityname;
    appdelegate.userData.lat = communityInfo.lat;
    appdelegate.userData.lng = communityInfo.lng;
    appdelegate.userData.carprefix = communityInfo.carprefix;
    appdelegate.userData.openmap = [communityInfo.powerInfo mj_keyValues];
    [appdelegate saveContext];
    /*持久化当前社区权限*/
    [UserDefaultsStorage saveData:communityInfo.powerInfo.isresipower forKey:@"resipower"];
    NSArray *authorityArray = [NSArray yy_modelArrayWithClass:[PAAuthorityModel class] json:powerArr];
    [[PAAuthorityManager sharedPAAuthorityManager] updateAuthorityWithcommunityId:communityInfo.communityid andArray:authorityArray];
    
}
@end
