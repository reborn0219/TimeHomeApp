//
//  PANewHomeService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/7/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeService.h"
#import "PANewHomeNewsRequest.h"
#import "PANewHomeActivityRequest.h"
#import "PANewHomeMenuRequest.h"
#import "PANewHomeBannerRequest.h"
#import "PANewHomeNoticeRequest.h"
#import "PANewHomeAlertRequest.h"
#import "PushMsgModel.h"
#import "PANewHomeSettingInfoRequest.h"
#import "PANewHomeResidenceRequest.h"
#import "PANewHomeParkingRequest.h"
#import "PANewHomeUserAuthRequest.h"
#import "PANewHomeSignInRequest.h"
#import "PANewHomeWaitcertinfoRequest.h"
#import "PANewHomeUserSignRequest.h"
@implementation PANewHomeService
/**
 加载zaker新闻数据
 
 @param success 成功
 @param failed 失败
 */
- (void)loadNewsDataSuccess:(ServiceSuccessBlock)success failed:(ServiceFailedBlock)failed{
    PANewHomeNewsRequest * req = [[PANewHomeNewsRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        //重写request.responseData
        NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        self.newsArray = [NSArray yy_modelArrayWithClass:[PANewHomeNewsModel class] json:jsonDic[@"list"]];
        success(self);

    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failed(self,@"网络错误");
    }];
    
}

/**
 加载活动数据
 
 @param success 成功
 @param failed 失败
 */
- (void)loadActivityDataSuccess:(ServiceSuccessBlock)success failed:(ServiceFailedBlock)failed{
    
    PANewHomeActivityRequest * req = [[PANewHomeActivityRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        //重写request.responseData
        NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        self.activityArray = [NSArray yy_modelArrayWithClass:[PANewHomeActivityModel class] json:jsonDic[@"list"]];
        success(self);
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failed(self,@"网络错误");
    }];
}
/**
 加载menuData
 
 @param success 成功
 @param failed 失败
 */
- (void)loadMenuDataSuccess:(ServiceSuccessBlock)success failed:(ServiceFailedBlock)failed{
    PANewHomeMenuRequest * req = [[PANewHomeMenuRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        //重写request.responseData
        NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        self.menuArray =jsonDic[@"list"];
        success(self);
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failed(self,@"网络错误");
    }];

}



- (void)loadBannerSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    self.bannerArray = [NSMutableArray array];
    PANewHomeBannerRequest *req = [[PANewHomeBannerRequest alloc]init];
    @weakify(self);
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        @strongify(self);
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:NULL];
        NSInteger errcode=[[responseDict objectForKey:@"errcode"] intValue];
        if (errcode == 0) {
            NSArray *bannerArray = [responseDict objectForKey:@"list"];
            [bannerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PANewHomeBannerModel *bannerModel = [PANewHomeBannerModel yy_modelWithJSON:obj];
                [self.bannerArray addObject:bannerModel];
            }];
        }
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,error.localizedDescription);
    }];
}

- (void)loadNoticeSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    self.noticeArray = [NSMutableArray array];
    PANewHomeNoticeRequest *req = [[PANewHomeNoticeRequest alloc]init];
    @weakify(self);
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        @strongify(self);
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:NULL];
        NSInteger errcode=[[responseDict objectForKey:@"errcode"] intValue];
        if (errcode == 0) {
            NSArray *noticeArray = [responseDict objectForKey:@"list"];
            [noticeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PANewHomeNoticeModel *noticeModel = [PANewHomeNoticeModel yy_modelWithJSON:obj];
                [self.noticeArray addObject:noticeModel];
            }];
            
            NSString * noreadcount = [responseDict objectForKey:@"noreadcount"];
            if(noreadcount.integerValue <=0){
                noreadcount = @"0";
            }
            AppDelegate *appDelegate = GetAppDelegates;
            PushMsgModel * pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.CommunityNotification];
            if (pushMsg == nil) {
                pushMsg = [[PushMsgModel alloc] init];
                pushMsg.countMsg=[[NSNumber alloc]initWithInt:0];
            }
            pushMsg.countMsg = [NSNumber numberWithInteger:noreadcount.integerValue];
            [UserDefaultsStorage saveData:pushMsg forKey:appDelegate.CommunityNotification];
            success(self);
        }        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,error.localizedDescription);
    }];
}

- (void)loadAlertSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANewHomeAlertRequest *req = [[PANewHomeAlertRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:NULL];
        NSInteger errcode=[[responseDict objectForKey:@"errcode"] intValue];
        if (errcode == 0) {
            self.alertDict = [responseDict objectForKey:@"map"];
            success(self);
        }
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,error.localizedDescription);
    }];
    
}
/**
 获取消息设置类
 
 @param success success description
 @param failure failure description
 */
- (void)loadSettingInfoSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANewHomeSettingInfoRequest * req = [[PANewHomeSettingInfoRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
         NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        self.noticeSet = [AppNoticeSet yy_modelWithJSON:jsonDic[@"map"]];
        AppNoticeSet *appNoticeSet = [AppNoticeSet yy_modelWithJSON:jsonDic[@"map"]];
        
        if ([appNoticeSet.shockopen isEqualToString:@"0"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kCloseShakeOrNot];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kCloseShakeOrNot];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        if ([appNoticeSet.voiceopen isEqualToString:@"0"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kCloseSoundOrNot];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kCloseSoundOrNot];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        if ([appNoticeSet.carremind isEqualToString:@"0"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kAlertSoundOrNot];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:kAlertSoundOrNot];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }

        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,@"网络错误");
        
    }];
}
/**
 获取个人住宅信息
 
 @param success success description
 @param failure failure description
 */
- (void)loadResidenceSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANewHomeResidenceRequest * req = [[PANewHomeResidenceRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = jsonDic[@"list"];
        if (!array||array.count==0) {
            self.haveHouse = NO;
        } else{
            self.haveHouse = YES;
        }
        success(self);

    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,@"网络错误");
    }];
}

/**
 获取个人车位信息
 
 @param success success description
 @param failure failure description
 */
- (void)loadParkingDataSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANewHomeParkingRequest * req = [[PANewHomeParkingRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = jsonDic[@"list"];
        if (!array||array.count==0) {
            self.haveParking = NO;
        } else{
            self.haveParking = YES;
        }
        success(self);

    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
    }];
}
/**
 获取个人权限信息
 
 @param success success description
 @param failure failure description
 */
- (void)loadUserAuthDataSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANewHomeUserAuthRequest * req = [[PANewHomeUserAuthRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * resultDic = jsonDic[@"map"];
        NSString * resipower = [NSString stringWithFormat:@"%@",resultDic[@"isresipower"]];
        [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
        self.resipower = [resultDic[@"isresipower"]integerValue];
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
    }];
}

/**
 获取用户签到设置
 
 @param success success description
 @param failure failure description
 */
- (void)loadUserSignSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANewHomeSignInRequest * req = [[PANewHomeSignInRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
    }];
}

/**
 获得当前社区的待认证房产与车位
 
 @param communityId 社区ID
 @param success success description
 @param failure failure description
 */
- (void)loadWaitCertInfoWithCommunityId:(NSString *)communityId success:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANewHomeWaitcertinfoRequest * req = [[PANewHomeWaitcertinfoRequest alloc]initWithCommunityId:communityId];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        
        self.waitHouseArray = [NSArray yy_modelArrayWithClass:[L_ResiListModel class] json:jsonDic[@"resilist"]];
        self.waitParkingArray = [NSArray yy_modelArrayWithClass:[L_ResiCarListModel class] json:jsonDic[@"parklist"]];
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(self,@"服务器压力过大,请稍后重试");
    }];
}

/**
 获取当前用户签到详情
 
 @param success success description
 @param failure failure description
 */
- (void)loadUserSignInfoSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure{
    PANewHomeUserSignRequest * req = [[PANewHomeUserSignRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSMutableDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = jsonDic[@"map"];
        self.firshShowSignUp = [dic [@"isfirst"] boolValue];
        self.isSignUp = [dic[@"issign"] boolValue];
        NSLog(@"%@",dic);
        self.signUpDic = [NSDictionary dictionaryWithDictionary:dic];
        success(self);
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
    }];
}



@end
