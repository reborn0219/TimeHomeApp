//
//  NetworkMonitoring.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "NetworkMonitoring.h"
#import "Reachability.h"


@interface NetworkMonitoring()


@property (nonatomic, copy)   UpDateViewsBlock block;
@property (nonatomic, strong) Reachability *reachabilityManager;
@property (nonatomic, copy) NSString *netWorkState;
@end
@implementation NetworkMonitoring

#pragma mark - 单例
+ (instancetype)shareMonitoring{
    
    static NetworkMonitoring *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 初始化网络监听管理类
-(Reachability *)reachabilityManager
{
    if (!_reachabilityManager) {
        
        _reachabilityManager = [Reachability reachabilityForInternetConnection];
    }
    
    return _reachabilityManager;
}
#pragma mark -注册通知开始监听
-(void)start
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    ///初始化网络状态为可用
    self.netWorkState = @"Wifi";
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"netState"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.reachabilityManager startNotifier];
    

}
-(void)needCallBack:(UpDateViewsBlock)block{
    self.block = block;
}
#pragma mark - 移除监听
-(void)stop
{
    [self.reachabilityManager stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
}

#pragma mark - 网络变化回调
-(void)reachabilityChanged:(NSNotification *)note{
    
    Reachability *curReach = [note object];
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    
    if (status == NotReachable){
        
        if (self.block) {
            self.block(@"NoNetWork",FailureCode);
        }
        self.netWorkState = @"NoNetWork";
        ///网络状态可用
        [[NSUserDefaults standardUserDefaults]setObject:@NO forKey:@"netState"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else
    {
        ///网络状态不可用
        [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"netState"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        switch (status) {
                
            case ReachableViaWiFi:{
                
                self.netWorkState = @"Wifi";
                
                if (self.block) {
                    
                    self.block(@"Wifi",SucceedCode);
                }
    
            }
                break;
            case kReachableVia2G:{
                self.netWorkState = @"2G";

        
                if (self.block) {
                    self.block(@"2G",SucceedCode);
                }
            }
                break;
            case kReachableVia3G:{
                self.netWorkState = @"3G";

                if (self.block) {
                    self.block(@"3G",SucceedCode);
                }
            }
                break;
            case kReachableVia4G:{
                
                self.netWorkState = @"4G";

                if (self.block) {
                    self.block(@"4G",SucceedCode);
                }
            }
                break;
                
            case ReachableViaWWAN:{
                
                self.netWorkState = @"WWAN";
                
                if (self.block) {
                    self.block(@"WWAN",SucceedCode);
                }
            }
                break;
            default:
                break;
        }
        
    }
    NSLog(@"---当前网络状态--%@--",self.netWorkState);
        
}
#pragma mark - 获取网络状态

-(NSString *)state{
    
    return self.netWorkState;
}

@end
