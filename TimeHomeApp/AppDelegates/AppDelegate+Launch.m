//
//  AppDelegate+Launch.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/9/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+Launch.h"
#import "PAGuideViewController.h"
#import "PAADViewController.h"
#import "AppDelegate+Route.h"
#import "AppDelegate+Helper.h"
#import "MainTabBars.h"
#import "AppSystemSetPresenters.h"

@implementation AppDelegate (Launch)

- (void)setupWindow{
    /*
     启动流程
     首次启动：引导页->首页
     非首次启动：广告页->首页
     */
    
    __weak typeof(self) weakSelf = self;
    
    //1.展示引导页
    NSArray * imgArr=@[@"引导页-1",@"引导页-2",@"引导页-3",@"引导页-4"];
    [PAGuideViewController showGuidePageWithImageArray:imgArr
     
                                            Completion:^(BOOL isNewVersion){
                                                
                                                if(NO == isNewVersion){
                                                    //1.展示广告页
                                                    [self showAdvertisementView];
                                                }else{
                                                    //3.展示主页
                                                    [self showMainView];
                                                }
                                            }];
}

- (void)showAdvertisementView{
    /*
    [PAADViewController showAdCompletion:^{
        //4.展示主页
        [self showMainView];
    }];
     */
    
    [PAADViewController showAdCompletion:^(BOOL show, PAWebViewController *webview) {
        if (!show) {
            [self showMainView];
        }else{
            [self loginToMainTabVC:[self checkVersionNeedLogin] showAdvertisement:webview];
        }
    }];
    
    
}
- (void)showMainView{
    [self loginToMainTabVC:[self checkVersionNeedLogin]];
}

- (void)loginToMainTabVC:(BOOL)notNeedLogin showAdvertisement:(PAWebViewController *)advert{
    /**
     *  判断是否已登录 - 性别，小区为空跳转到完善资料界面
     */
    if(notNeedLogin&&[self.userData.isRememberPw boolValue] && self.userData.isLogIn.boolValue && self.userData.sex.intValue != 0 && ![self.userData.communityid isEqualToString:@"0"] && [self.userData.communityid isNotBlank] && ![self isBeyonbdDays]) {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
        MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
        MainTabBar.showAd = YES;
        MainTabBar.adWebview = advert;
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
