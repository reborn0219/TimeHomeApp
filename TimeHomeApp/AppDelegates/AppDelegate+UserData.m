//
//  AppDelegate+UserData.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+UserData.h"
#import "DataOperation.h"
@implementation AppDelegate (UserData)

-(void)configUserData{
    
  
    //提取持久化的用户数据
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_STORAGE_KEY];
    self.userData = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    if (!self.userData) {
        self.userData = [[PAUserData alloc]init];
        self.userData.isGuide = [[NSNumber alloc]initWithBool:NO];
    }
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
    [shared setObject:self.userData.token?:@"" forKey:@"widget"];
    [shared setObject:SERVER_URL forKey:@"url"];
    [shared setObject:kCarError_SEVER_URL forKey:@"newUrl"];
    [shared synchronize];
    
   
}

@end
