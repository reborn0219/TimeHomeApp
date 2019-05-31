//
//  AppDelegate+Version.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+Version.h"
#import "AppSystemSetPresenters.h"
#import "NetWorks.h"
#import "L_UpdateVC.h"

@implementation AppDelegate (Version)
#pragma mark - 是否需要强制更新
/**
 是否需要强制更新 (返回参数为errcode ,errmsg,updstate, updstate 1为强制更新，2为普通更新，3为不更新，errcode统一返回0)
 */
- (void)isVersionUpdate {
    
    [AppSystemSetPresenters isVersionUpdWithVersion:kCurrentVersion UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (resultCode == SucceedCode) {
                
                NSString *updateState = [NSString stringWithFormat:@"%@",data[@"updstate"]];
                
                if (updateState.integerValue == 1) {
                    /** 强制更新 */
                    [self updateSoftVersionWithUpdateState:1];
                    
                }else if (updateState.integerValue == 2) {
                    /** 普通更新 */
                    [self updateSoftVersionWithUpdateState:2];
                    
                }else if (updateState.integerValue == 3) {
                    /** 不更新 */
                    
                }
                
            }
            
        });
        
    }];
    
}

#pragma ---------    检测版本升级
-(void)updateSoftVersionWithUpdateState:(NSInteger)updateState {
    
    NSString * versionStr = [[NSUserDefaults standardUserDefaults]objectForKey:IOS_VERSION_UPGRADE];
    
    if (![versionStr isNotBlank]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:IOS_VERSION_UPGRADE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }else  {
        
        versionStr = [NSString stringWithFormat:@"%ld",versionStr.integerValue+1];
        if(versionStr.integerValue > 1000){
            versionStr  = @"1";
        }
        [[NSUserDefaults standardUserDefaults]setObject:versionStr forKey:IOS_VERSION_UPGRADE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    //NSData *postData = [@"" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    //NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:APP_URL]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20];
    //设置http-header:Content-Type。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    //[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    //[request setHTTPBody:postData];
    
    [NetWorks NSURLSessionVersionForRequst:request CompleteBlock:^(id  _Nullable data, ResultCode resultCode, NSError * _Nullable Error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode) {
                
                if (data) {
                    
                    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"==%@",aString);
                    
                    NSDictionary * jsonDic=[DataController dictionaryWithJsonData:data];
                    NSNumber * resultCount=[jsonDic objectForKey:@"resultCount"];
                    if (resultCount.integerValue==1) {
                        
                        NSArray* infoArray = [jsonDic objectForKey:@"results"];
                        
                        if (infoArray.count>0) {
                            
                            NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
                            
                            NSString* appStoreVersion = [releaseInfo objectForKey:@"version"];
                            NSString * appstoreV = appStoreVersion;
                            
                            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                            
                            appStoreVersion=[appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:IOS_LAST_VERSION_NO];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                            NSLog(@"苹果商店版本号： %@",appStoreVersion);
                            NSLog(@"用户当前版本号： %@",currentVersion);
                            
                            if (updateState == 1) {
                                /** 强制更新 */
                                if (currentVersion.intValue < appStoreVersion.intValue ) {
                                    
                                    trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                                    NSString* msg =[releaseInfo objectForKey:@"releaseNotes"];
                                    
                                    UIViewController *currentVC = [self getCurrentViewController];
                                    L_UpdateVC *updateVC = [L_UpdateVC getInstance];
                                    updateVC.type = 1;
                                    [updateVC showVC:currentVC withMsg:msg withVersion:appstoreV cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                        
                                        if (index == 1) {
                                            
                                            UIApplication *application = [UIApplication sharedApplication];
                                            [application openURL:[NSURL URLWithString:trackViewURL]];
                                            exit(0);
                                            
                                        }
                                        
                                    }];
                                    
                                    //                                    MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
                                    //
                                    //                                    [msgV showMsgViewForMsg:[NSString stringWithFormat:@"有新版本%@开始体验吧",appstoreV] btnOk:@"确定" btnCancel:@"" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index){
                                    //
                                    //                                        if(index==100) {
                                    //
                                    //                                            UIApplication *application = [UIApplication sharedApplication];
                                    //                                            [application openURL:[NSURL URLWithString:trackViewURL]];
                                    //                                            exit(0);
                                    //                                        }
                                    //
                                    //                                    }];
                                    
                                }
                                
                            }else if (updateState == 2) {
                                /** 普通更新 */
                                
                                if (currentVersion.intValue < appStoreVersion.intValue && (versionStr.integerValue % 3 == 0)) {
                                    
                                    trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                                    NSString* msg = [releaseInfo objectForKey:@"releaseNotes"];
                                    
                                    UIViewController *currentVC = [self getCurrentViewController];
                                    L_UpdateVC *updateVC = [L_UpdateVC getInstance];
                                    [updateVC showVC:currentVC withMsg:msg withVersion:appstoreV cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                        
                                        if (index == 1) {
                                            
                                            UIApplication *application = [UIApplication sharedApplication];
                                            [application openURL:[NSURL URLWithString:trackViewURL]];
                                            
                                        }
                                        
                                    }];
                                    
                                    //                                    MsgAlertView * msgV = [MsgAlertView sharedMsgAlertView];
                                    //
                                    //                                    [msgV showMsgViewForMsg:[NSString stringWithFormat:@"有新版本%@开始体验吧",appstoreV] btnOk:@"确定" btnCancel:@"以后再说" blok:^(id  _Nullable data, UIView * _Nullable view, NSInteger index){
                                    //
                                    //                                        if(index==100) {
                                    //                                            UIApplication *application = [UIApplication sharedApplication];
                                    //                                            [application openURL:[NSURL URLWithString:trackViewURL]];
                                    //                                        }
                                    //                                    }];
                                }
                            }
                        }
                    }
                }
            }
        });
    }];
}
@end
