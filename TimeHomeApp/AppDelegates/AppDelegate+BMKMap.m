//
//  AppDelegate+BMKMap.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+BMKMap.h"

@implementation AppDelegate (BMKMap)

- (void)configBMKMapManager{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BDMAP_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"百度地图启动失败!");
    }
}

- (void)onGetNetworkState:(int)iError{
    if (0 == iError) {
        NSLog(@"百度地图联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError{
    if (0 == iError) {
        NSLog(@"百度地图授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
