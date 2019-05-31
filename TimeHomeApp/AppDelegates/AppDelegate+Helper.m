//
//  AppDelegate+Helper.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+Helper.h"
#import <sys/utsname.h>
#import "DateUitls.h"
#import "NetworkMonitoring.h"
#import "CommunityManagerPresenters.h"
@implementation AppDelegate (Helper)
#pragma mark - 获取手机型号
- (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"])  return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,4"])  return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"])  return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,5"])  return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"])  return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone10,6"])  return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

#pragma mark ----- 判断60天未登录
- (BOOL)isBeyonbdDays {
    NSString *nowTimeStr = [DateUitls getTodayDateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *beginTime = [userDefaults objectForKey:@"beginLoginTime"];
    NSInteger days = [DateUitls calcDaysFromBeginForString:nowTimeStr today:beginTime];
    if (days > 60) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"1" forKey:@"clearPassWord"];
        [userDefaults synchronize];
        self.userData.isLogIn = @NO;
        [self saveContext];
        return YES;
    }
    return NO;
}

#pragma mark - 获取当前网络状态
+ (NSString *)getNetWorkStates {
    return [[NetworkMonitoring shareMonitoring] state];
}

#pragma mark 获取当前显示的UIViewController
- (UIViewController *)getCurrentViewController{
    UIViewController *appRootVC =self.window.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark - 检查用户版本是否需要重新登录
-(BOOL)checkVersionNeedLogin{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString * lastVsersion = [[NSUserDefaults standardUserDefaults]objectForKey:IOS_LAST_VERSION_NO];
    if ([lastVsersion isNotBlank]) {
        if (lastVsersion.integerValue<currentVersion.integerValue) {
            self.userData.isLogIn = @NO;
            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:IOS_LAST_VERSION_NO];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self saveContext];
            ///首页蒙版
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"needTheView"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            return NO;
        }
    }else {
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:IOS_LAST_VERSION_NO];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"needTheView"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return YES;
    }
    ///首页蒙版
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"needTheView"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return YES;
}

//显示消息提示并自动消失
+(void)showToastMsg:(NSString *)message Duration:(float)duration {
    if(![message isNotBlank]) {
        return;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    
    showview.alpha = 1.0f;
    showview.layer.cornerRadius  =5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    label.frame = CGRectMake(10, 10, LabelSize.width, LabelSize.height);
    label.text  = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 0; //
    
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width)/2-10, SCREEN_HEIGHT/2, LabelSize.width+20, LabelSize.height+20);
    //    [UIView animateWithDuration:duration animations:^{
    //        showview.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        [showview removeFromSuperview];
    //    }];
    
    //    window.userInteractionEnabled = NO;
    
    // 第一步：将view宽高缩至无限小（点）
    showview.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                0.9, 0.9);
    [UIView animateWithDuration:0.2 animations:^{
        // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
        showview.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            // 第三步： 以动画的形式将view恢复至原始大小
            showview.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration / 2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                    showview.transform =
                    CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                        showview.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                        
                    } completion:^(BOOL finished) {
                        
                        // 第三步： 移除
                        [showview removeFromSuperview];
                        //                        window.userInteractionEnabled = YES;
                        
                    }];
                    
                }];
                
            });
            
        }];
        
    }];
}

//获取蓝牙设备权限数据
-(void)getBlueTouchData{
    [CommunityManagerPresenters getUserBluetoothUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                
                NSArray *array=(NSArray *)data;
                if([data isKindOfClass:[NSArray class]])
                {
                    if(array==nil||array.count==0)
                    {
                        return ;
                    }
                    [UserDefaultsStorage saveData:array forKey:@"UserUnitKeyArray"];
                }
            }
            else
            {
                //                 [self showToastMsg:data Duration:5.0];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *errmessage = data[@"errmsg"];
                    
                    [UserDefaultsStorage saveData:@[] forKey:@"UserUnitKeyArray"];
                    [UserDefaultsStorage saveData:errmessage forKey:@"Blue_errmessage"];
                }
            }
        });
    }];
}

@end
