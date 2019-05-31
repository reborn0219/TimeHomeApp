//
//  UserActivity.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserActivity.h"

@implementation UserActivity

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    UserActivity *activity = [[UserActivity alloc] init];
    if (activity) {
        
        activity.gototype = [self.gototype copyWithZone:zone];
        activity.endtype = [self.endtype copyWithZone:zone];
        activity.communityid = [self.communityid copyWithZone:zone];
        activity.communityname = [self.communityname copyWithZone:zone];
        activity.title = [self.title copyWithZone:zone];
        activity.remarks = [self.remarks copyWithZone:zone];
        activity.begindate = [self.begindate copyWithZone:zone];
        activity.enddate = [self.enddate copyWithZone:zone];
        activity.picurl = [self.picurl copyWithZone:zone];
        activity.gotourl = [self.gotourl copyWithZone:zone];
        activity.systime = [self.systime copyWithZone:zone];
        activity.content = [self.content copyWithZone:zone];
        
    }
    return activity;
}

@end

