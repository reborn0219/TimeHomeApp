//
//  AppDelegate+NetWork.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+NetWork.h"
#import "NetworkMonitoring.h"

@implementation AppDelegate (NetWork)
-(void)configNetwork{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    //为所有YTKNetwork 的API统一添加参数
    //    PARequestArgumentsFilter *urlFilter = [PARequestArgumentsFilter filterWithArguments:@{@"appId": @"APP_H5"}];
    //    [config addUrlFilter:urlFilter];
    config.baseUrl = PA_NEW_SEVER_URL;
    config.cdnUrl = SERVER_PIC_URL;
}



@end
