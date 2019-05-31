//
//  AppDelegate+UMCommonLog.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/9/12.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+UMCommonLog.h"
#import <UMCommonLog/UMCommonLogHeaders.h>

@implementation AppDelegate (UMCommonLog)

-(void)registUMCommonLog{
    [UMCommonLogManager setUpUMCommonLogManager];
}
@end
