//
//  AppDelegate+Pay.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/27.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+Pay.h"
#import "AppPayPresenter.h"

@implementation AppDelegate (Pay)

#pragma mark - 微信支付回调--------2016.12.5修改
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL isWeixin = [APPWXPAYMANAGER usPay_handleUrl:url];
    if (isWeixin) {
        return isWeixin;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL isWeixin = [APPWXPAYMANAGER usPay_handleUrl:url];
    if (isWeixin) {
        return isWeixin;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (APPWXPAYMANAGER.appAlipayCallBack) {
                APPWXPAYMANAGER.appAlipayCallBack(resultDic);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            if (APPWXPAYMANAGER.appAlipayCallBack) {
                APPWXPAYMANAGER.appAlipayCallBack(resultDic);
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    BOOL isWeixin = [APPWXPAYMANAGER usPay_handleUrl:url];
    if (isWeixin) {
        return isWeixin;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (APPWXPAYMANAGER.appAlipayCallBack) {
                APPWXPAYMANAGER.appAlipayCallBack(resultDic);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            if (APPWXPAYMANAGER.appAlipayCallBack) {
                APPWXPAYMANAGER.appAlipayCallBack(resultDic);
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

@end
