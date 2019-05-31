//
//  AppDelegate+Route.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+Route.h"
#import "MainTabBars.h"
#import "AppSystemSetPresenters.h"
#import "LoginVC.h"
@implementation AppDelegate (Route)

-(void)pushViewController:(UIViewController *)viewController{

    UINavigationController *nav;
    
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)self.window.rootViewController;
    }else if([self.window.rootViewController isKindOfClass:[UITabBarController class]]){
        
        UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
        
        if ([tabVC.viewControllers[tabVC.selectedIndex] isKindOfClass:[UINavigationController class]]) {
            nav = tabVC.viewControllers[tabVC.selectedIndex];
        }
    }
    
    [nav pushViewController:viewController animated:YES];
    
}

#pragma mark - 判断是否已登录跳转到主页
/**
 判断是否已登录跳转到主页
 */
- (void)loginToMainTabVC:(BOOL)notNeedLogin {
    /**
     *  判断是否已登录 - 性别，小区为空跳转到完善资料界面
     */
    if(notNeedLogin&&[self.userData.isRememberPw boolValue] && self.userData.isLogIn.boolValue && self.userData.sex.intValue != 0 && ![self.userData.communityid isEqualToString:@"0"] && [self.userData.communityid isNotBlank] && ![self isBeyonbdDays]) {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
        MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
        self.window.rootViewController=MainTabBar;
        [AppSystemSetPresenters getBindingTag];
        MainTabBar.tabBarController.tabBar.hidden = NO;
        MainTabBar.hidesBottomBarWhenPushed = NO;
        [self.window makeKeyAndVisible];
    } else{
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
        UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
        self.window.rootViewController = loginVC;
        [self.window makeKeyAndVisible];
    }
}
@end
