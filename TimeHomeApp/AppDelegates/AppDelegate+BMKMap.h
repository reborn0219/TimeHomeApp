//
//  AppDelegate+BMKMap.h
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (BMKMap)<BMKGeneralDelegate>

//配置百度地图
- (void)configBMKMapManager;

@end
