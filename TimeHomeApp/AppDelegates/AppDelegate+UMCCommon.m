//
//  AppDelegate+UMCCommon.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/9/12.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+UMCCommon.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

@implementation AppDelegate (UMCCommon)
-(void)registUMCCommon{
    
    [UMConfigure initWithAppkey:@"5a503011b27b0a27bc0002d4" channel:@"AppStore"];
    [MobClick setScenarioType:E_UM_GAME|E_UM_DPLUS];
    [UMConfigure setLogEnabled:YES];

}
@end
