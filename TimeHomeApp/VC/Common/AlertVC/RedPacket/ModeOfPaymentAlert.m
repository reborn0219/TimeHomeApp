//
//  ModeOfPaymentAlert.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ModeOfPaymentAlert.h"
#import "UIButtonImageWithLable.h"
@interface ModeOfPaymentAlert ()

@end

@implementation ModeOfPaymentAlert
+(instancetype)sharePaymentVC
{
    static ModeOfPaymentAlert * shareProblemsLoggingVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareProblemsLoggingVC = [[self alloc] initWithNibName:@"ModeOfPaymentAlert" bundle:nil];
        
    });
    return shareProblemsLoggingVC;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}


- (void) setUpUI {
    if ([XYString isBlankString:_moneyStr]) {
        _moneyStr = @"";
    }
    
    _moneyLabel.text = [NSString stringWithFormat:@"支付金额:￥ %.2f",[_moneyStr floatValue]];
    
    [_alipayBtn setTopImage:[UIImage imageNamed:@"发布-弹窗-选择支付方式-支付宝图标"] withTitle:@"支付宝" forState:UIControlStateNormal];
    [_alipayBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    [_weChatBtn setTopImage:[UIImage imageNamed:@"发布-弹窗-选择支付方式-微信图标"] withTitle:@"微信" forState:UIControlStateNormal];
    [_balanceBtn setTopImage:[UIImage imageNamed:@"发布-弹窗-选择支付方式-余额图标"] withTitle:@"余额" forState:UIControlStateNormal];

}

-(void)show:(UIViewController * )VC
{
    _moneyLabel.text = [NSString stringWithFormat:@"支付金额:￥%.2f",[_moneyStr floatValue]];
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
    [self dismissViewControllerAnimated:NO completion:nil];
}

///点击半透明区域结束
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [self dismiss];
//}

/**
 支付宝
 */
- (IBAction)alipayClick:(id)sender {
    [self dismiss];
    if(self.block) {
        self.block(nil,nil,0);
    }
}

/**
 微信
 */
- (IBAction)weChatClick:(id)sender {
    [self dismiss];
    if(self.block) {
        self.block(nil,nil,1);
    }
}

/**
 余额
 */
- (IBAction)balanceBtnClick:(id)sender {
    [self dismiss];
    if(self.block) {
        self.block(nil,nil,2);
    }
    
    
    
}

/**
 关闭按钮
 */
- (IBAction)closeClick:(id)sender {
    [self dismiss];
}

@end
