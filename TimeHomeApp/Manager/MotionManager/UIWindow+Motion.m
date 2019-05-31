//
//  UIWindow+Motion.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UIWindow+Motion.h"
#import "ShakePassageVC.h"
#import "AppDelegate.h"
@implementation UIWindow (Motion)

- (BOOL)canBecomeFirstResponder {//默认是NO，所以得重写此方法，设成YES
    return YES;
}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self shakeOpenDoor];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"shake");
}

/**
 摇一摇开门
 */
-(void)shakeOpenDoor
{
    AppDelegate * delegate = GetAppDelegates;
    // 未登录或者登录失效情况下 return
    if (![delegate.userData.token isNotBlank]) {
        return;
    }
    NSString *resipower = [UserDefaultsStorage getDataforKey:@"resipower"];
    if ([resipower integerValue] == 1) {
        NSArray * blueTooths = (NSArray *)[UserDefaultsStorage getDataforKey:@"UserUnitKeyArray"];
        if (blueTooths.count==0||blueTooths==nil) {
            
            NSString * blueErrmessage = (NSString *)[UserDefaultsStorage getDataforKey:@"Blue_errmessage"];
            if ([XYString isBlankString:blueErrmessage]) {
                
                [AppDelegate showToastMsg:@"请联系物业开通摇一摇通行服务" Duration:2.5f];
            }else{
                
                [AppDelegate showToastMsg:blueErrmessage Duration:2.5f];
            }
            
            return;
        }
        
        [YYPlaySound playSoundWithResourceName:@"sharke" ofType:@"wav"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
        ShakePassageVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"ShakePassageVC"];
        pmvc.isStart=YES;
        pmvc.hidesBottomBarWhenPushed = YES;
        UIViewController * currentController = [self getCurrentVC];
        [currentController.navigationController pushViewController:pmvc animated:YES];
        
    }else {
        [AppDelegate showToastMsg:@"请先认证为本小区的业主，您才可以使用此功能" Duration:3.0f];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

//获取当前屏幕显示的viewcontroller

- (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
    
}
@end
