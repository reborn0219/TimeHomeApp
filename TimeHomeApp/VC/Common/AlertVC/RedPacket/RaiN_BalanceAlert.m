//
//  RaiN_BalanceAlert.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_BalanceAlert.h"
#import "BBSMainPresenters.h"
@interface RaiN_BalanceAlert ()

@end

@implementation RaiN_BalanceAlert
+(instancetype)shareshowBalanceVC
{
    static RaiN_BalanceAlert * shareProblemsLoggingVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareProblemsLoggingVC = [[self alloc] initWithNibName:@"RaiN_BalanceAlert" bundle:nil];
        
    });
    return shareProblemsLoggingVC;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
//    _canUseStr = @"0";
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    _needPayLabel.text = [NSString stringWithFormat:@"支付金额：%.2f元",[_needPayStr floatValue]];
}

/**
 获取我的余额
 */
- (void)loadData {
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BBSMainPresenters getMyBalabceAndUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                //成功
                _canUseStr = data[@"map"][@"balance"];
                _canUseLabel.text = [NSString stringWithFormat:@"可用余额：%.2f元",[_canUseStr floatValue]];
            }else {
                //失败
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }
        });
    }];
}

-(void)show:(UIViewController * )VC
{
//    [self loadData];
    _canUseLabel.text = [NSString stringWithFormat:@"可用余额：%.2f元",[_canUseStr floatValue]];
    _needPayLabel.text = [NSString stringWithFormat:@"支付金额：%.2f元",[_needPayStr floatValue]];
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    
    
    [VC presentViewController:self animated:YES completion:^{
        
    }];
    
}
-(void)dismiss
{
    _needPayStr = @"";
    _canUseStr = @"";
    
    _canUseLabel.text = @"";
    _needPayLabel.text = @"";
    [self dismissViewControllerAnimated:NO completion:nil];
}

/**
 确定点击
 */
- (IBAction)okClick:(id)sender {
    
//    if ([_needPayStr floatValue] > [_canUseStr floatValue]) {
//        [self showToastMsg:@"余额不足" Duration:3.0f];
//        return;
//    }
    
    [self dismiss];
    if(self.block){
        self.block(nil,nil,0);
    }
}

/**
 关闭按钮点击
 */
- (IBAction)closeClick:(id)sender {
    [self dismiss];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
