//
//  AppDelegate+UserStatistics.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+UserStatistics.h"
#import "DataOperation.h"
@implementation AppDelegate (UserStatistics)

- (void)configUserStatistics{
    self.userStatistics = (UserStatistics *)[[DataOperation sharedDataOperation]queryData:@"UserStatistics"];
    if (!self.userStatistics) {
        self.userStatistics = (UserStatistics *)[[DataOperation sharedDataOperation] creatManagedObj:@"UserStatistics"];
    }
}

#pragma mark - 数据统计
-(void)addStatistics:(NSDictionary *)statisticsDic {
    
    if ([statisticsDic[@"viewkey"] isNotBlank]) {
        //判断用户进入的页面和离开时的界面是否为同一个页面 如果是则统计用户数据
        if ([self.viewkey isEqualToString:statisticsDic[@"viewkey"]]||[self.main_viewkey isEqualToString:statisticsDic[@"viewkey"]]){
            self.userStatistics.viewkey = statisticsDic[@"viewkey"];
        }else{
            return;
        }
    }else{
        return;
    }
    
    if (self.userData.userID) {
        self.userStatistics.userid = self.userData.userID;
    }
    
    if (self.userData.communityid) {
        self.userStatistics.communityid = self.userData.communityid;
    }
    
    if ([statisticsDic[@"postid"] isNotBlank]) {
        self.userStatistics.postid = statisticsDic[@"postid"];
    }else {
        self.userStatistics.postid = @"";
    }
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
    self.userStatistics.endtime = [NSString stringWithFormat:@"%ld",timeSp];
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

@end
