//
//  MainTabBars.m
//  TimeHomeApp
//
//  Created by us on 16/1/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MainTabBars.h"
#import "PushMsgModel.h"
#import "UITabBar+Badge.h"
#import "LS_MessageVC.h"
#import "Gam_Chat.h"
#import "Gam_UnreadMsg.h"
#import "DataOperation.h"

#import "PANewHomeViewController.h"
#import "BBSTabVC.h"
#import "LS_MessageVC.h"
#import "MyTabVC.h"
#import "PAWebViewController.h"
@interface MainTabBars () <UITabBarDelegate, UITabBarControllerDelegate> {
    
    UINavigationController * MessageNav;
    
    NSArray *fetchController;
    
}

@end

@implementation MainTabBars

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSLog(@"viewController===%@",((UINavigationController *)viewController).viewControllers[0]);
    
    UIViewController *currentVC = ((UINavigationController *)viewController).viewControllers[0];
    
    AppDelegate *appdelgt = GetAppDelegates;
    
    [appdelgt addStatistics:@{@"viewkey":_viewKey}];
    
    if ([currentVC isKindOfClass:[PANewHomeViewController class]]) {
        [appdelgt markStatistics:ShouYe];
        _viewKey = ShouYe;
    }
    if ([currentVC isKindOfClass:[BBSTabVC class]]) {
        [appdelgt markStatistics:LinQu];
        _viewKey = LinQu;
        
    }
    if ([currentVC isKindOfClass:[LS_MessageVC class]]) {
        [appdelgt markStatistics:XiaoXi];
        _viewKey = XiaoXi;
        
    }
    if ([currentVC isKindOfClass:[MyTabVC class]]) {
        [appdelgt markStatistics:WoDe];
        _viewKey = WoDe;
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBarView];
    self.tabBar.tintColor = TABBAR_COLOR;
    
    self.delegate = self;
    
    _viewKey = ShouYe;
    
    AppDelegate *appdelgt = GetAppDelegates;
    [appdelgt markStatistics:ShouYe];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAdvertisementWebViewController) name:@"AdvertisementWebView" object:nil];
    
    if (self.showAd) {
        [self showAdvertisementWebViewController:self.adWebview];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushMessages:) name:@"Notification_Msg" object:nil];
    ///设置消息标记
    [self setTabBarBadges];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AppDelegate *appdelgt = GetAppDelegates;
    [appdelgt addStatistics:@{@"viewkey":_viewKey}];
    
}


-(void)initTabBarView
{
    UIStoryboard * home=[UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    UINavigationController * homeNav = (UINavigationController *)[home instantiateViewControllerWithIdentifier:@"homeNav"];
    
    
    UIStoryboard * Message=[UIStoryboard storyboardWithName:@"Message" bundle:nil];
    MessageNav = (UINavigationController *)[Message instantiateViewControllerWithIdentifier:@"MessageNav"];
    
    UIStoryboard * my=[UIStoryboard storyboardWithName:@"MyTab" bundle:nil];
    UINavigationController * myNav = (UINavigationController *)[my instantiateViewControllerWithIdentifier:@"myNav"];
    
    UIStoryboard * BBS=[UIStoryboard storyboardWithName:@"BBS" bundle:nil];
    UINavigationController * BBSNav = (UINavigationController *)[BBS instantiateViewControllerWithIdentifier:@"BBSNav"];
    
    [self setViewControllers:@[homeNav,BBSNav,MessageNav,myNav]];
    
    [self.view layoutIfNeeded];
}

-(void)receivePushMessages:(NSNotification*) aNotification
{
    [self setTabBarBadges];
}
 ///底部设置消息标记
-(void)setTabBarBadges
{
    AppDelegate *appDelegate = GetAppDelegates;

    [self.tabBar hideBadgeOnItemIndex:0];
    [self.tabBar hideBadgeOnItemIndex:1];
    [self.tabBar hideBadgeOnItemIndex:2];
    [self.tabBar hideBadgeOnItemIndex:3];
    
    PushMsgModel * pushMsg;

    
    ///个人消息
    PushMsgModel * pushMsg1;
    pushMsg1=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.PersonalMsg];
    
    
    ///聊天消息通知
    NSInteger tmp1=pushMsg1.countMsg.integerValue;
    
    NSInteger rowCount=0;
    
//    fetchController = [[DataOperation sharedDataOperation]getChatGoupListData];
//    Gam_Chat * GCT;
//    for(NSInteger i=0;i<fetchController.count;i++)
//    {
//        GCT=[fetchController objectAtIndex:i];
//        
//        rowCount+=GCT.countMsg.integerValue;
//    }
//    
    
    if (pushMsg1!=nil) {
        
        
        if(tmp1>0 || rowCount>0) {
            
            MessageNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",tmp1 + rowCount];
            
        }else {
            
            
            pushMsg1.countMsg=[[NSNumber alloc]initWithInt:0];
            pushMsg1.content=@"";
            [UserDefaultsStorage saveData:pushMsg1 forKey:appDelegate.PersonalMsg];
            MessageNav.tabBarItem.badgeValue = nil;
        }
        
    }
    
    ///我的 维修
    pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.RepairMsg];
    if (pushMsg!=nil) {
        NSInteger tmp=pushMsg.countMsg.integerValue;
        if(tmp>0)
        {
            [self.tabBar showBadgeOnItemIndex:3];
        }
    }
    ///我的 投诉
    pushMsg=(PushMsgModel *)[UserDefaultsStorage getDataforKey:appDelegate.ComplainMsg];
    if (pushMsg!=nil) {
        NSInteger tmp=pushMsg.countMsg.integerValue;
        if(tmp>0)
        {
            [self.tabBar showBadgeOnItemIndex:3];
        }
    }
}

- (void)showAdvertisementWebViewController:(PAWebViewController *)webview{
 
    //PAWebViewController * webview = notification.object;
    UINavigationController * nav = [self.viewControllers firstObject];
    [nav pushViewController:webview animated:YES];
}

@end
