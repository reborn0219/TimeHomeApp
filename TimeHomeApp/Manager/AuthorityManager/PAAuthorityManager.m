//
//  PAAuthorityManager.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAAuthorityManager.h"
#import "PAAuthorityRequest.h"

//页面跳转所需
#import "AppDelegate+Route.h"
#import "CTMediator+PAParkingActions.h"
#import "CTMediator+PARecommendationActions.h"
#import "CTMediator+PANewNoticeMediator.h"
#import "CTMediator+PASuggestMediatorActions.h"

@interface PAAuthorityManager()

@property (nonatomic,strong) NSMutableDictionary *communityAuthModelDic;//社区的权限配置

@end

@implementation PAAuthorityManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PAAuthorityManager)

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        self.communityAuthModelDic =  [UserDefaultsStorage getDataforKey:@"PA_AUTHORITY_DIC"];
    }
    
    return self;
}

-(void)fetchAuthorityWithCommunityId:(NSString*)communityId{
    
    PAAuthorityRequest *api = [[PAAuthorityRequest alloc]initWithCommunityId:communityId];
    
    [api requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSLog(@"权限获取成功");
        
        NSArray *authorityArray = [NSArray yy_modelArrayWithClass:[PAAuthorityModel class] json:responseModel.data];
        
        if (!_communityAuthModelDic) {
            _communityAuthModelDic = [NSMutableDictionary dictionary];
        }
        
        if (authorityArray) {
            [_communityAuthModelDic setObject:authorityArray forKey:communityId];
        }
        
        [UserDefaultsStorage saveData:_communityAuthModelDic  forKey:@"PA_AUTHORITY_DIC"];
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
         NSLog(@"权限获取失败");
    }];
}


-(void)updateAuthorityWithcommunityId:(NSString *)communityId andArray:(NSArray*)authorityArray{
    if (!_communityAuthModelDic) {
        _communityAuthModelDic = [NSMutableDictionary dictionary];
    }
    if (authorityArray) {
        [_communityAuthModelDic setObject:authorityArray forKey:communityId];
    }
    [UserDefaultsStorage saveData:_communityAuthModelDic  forKey:@"PA_AUTHORITY_DIC"];
}


//获取某社区指定资源的权限模型
-(PAAuthorityModel *)authorityWithCommunityId:(NSString*)communityId sourceId:(NSString*)sourceId{
    
    NSArray *authorityArray = [self.communityAuthModelDic objectForKey:communityId];
    
    for (PAAuthorityModel *authorityModel in authorityArray) {
        if ([sourceId isEqualToString:authorityModel.sourceId]) {
            return authorityModel;
        }
    }
    
    return nil;
}

-(BOOL)verifyAuthorityWithCommunityId:(NSString*)communityId sourceId:(NSString*)sourceId{
    
    NSString *tmpCommunityId = communityId;
    
    if (!communityId) {
        AppDelegate *appDelegate = GetAppDelegates;
        tmpCommunityId = appDelegate.userData.communityid;
    }
    
    if (!sourceId) {
        return YES;
    }
    
    PAAuthorityModel *authModel = [self authorityWithCommunityId:tmpCommunityId sourceId:sourceId];
    
    if (authModel) {
        NSLog(@"资源ID:%@,名称:%@,是否可用:%@,下一个资源ID:%@",authModel.sourceId,authModel.name,authModel.enable?@"YES":@"NO",authModel.nextSourceId);
        
        if (authModel.enable == NO) {
            [AppDelegate showToastMsg:@"此功能暂未开通" Duration:3];
            return NO;
        }
        
        /*暂时使用硬编码进行页面路由*/
        if (authModel.nextSourceId) {//事件需要进行跳转
            
            if ([authModel.nextSourceId isEqualToString:@"901000000001"]) {//跳转至新车位管理
                
                // 这里 param dict 的 value 也可以 传 model
                UIViewController *viewController = [[CTMediator sharedInstance] pa_mediator_PAParkingViewControllerWithParams:nil];
                
                AppDelegate *appDelegate = GetAppDelegates;
                
                [appDelegate pushViewController:viewController];
                
                return NO;
            } else if ([authModel.nextSourceId isEqualToString:@"834792374289"]) {
                
                UIViewController * viewController = [[CTMediator sharedInstance]pa_mediator_PARecommendationViewControllerWithParams:nil];
                
                AppDelegate *appDelegate = GetAppDelegates;
                
                [appDelegate pushViewController:viewController];

                return NO;
            } else if ([authModel.nextSourceId isEqualToString:@"906000000001"]){
                
                UIViewController * viewController = [[CTMediator sharedInstance]pa_mediator_PANewNoticeControllerWithParams:nil];
                AppDelegate *appDelegate = GetAppDelegates;
                [appDelegate pushViewController:viewController];
                return NO;
            } else if ([authModel.nextSourceId isEqualToString:@"905000000001"]){
                //新投诉建议
                UIViewController * controller = [[CTMediator sharedInstance]pa_mediator_PANewSuggestControllerWithParams:nil];
                AppDelegate *appDelegate = GetAppDelegates;
                [appDelegate pushViewController:controller];
                return NO;
            }
        }
    }
    
    return YES;
    
}

@end
