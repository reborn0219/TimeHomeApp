//
//  ZSY_ProblemsLoggingVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_ProblemsLoggingVC.h"

@interface ZSY_ProblemsLoggingVC ()

@end

@implementation ZSY_ProblemsLoggingVC
+(instancetype)shareProblemsLoggingVC
{
    static ZSY_ProblemsLoggingVC * shareProblemsLoggingVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareProblemsLoggingVC = [[self alloc] initWithNibName:@"ZSY_ProblemsLoggingVC" bundle:nil];
        
    });
    return shareProblemsLoggingVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _cancelButton.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
//    _cancelButton.layer.borderWidth = 1.0f;
    
    [_cancelButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    
    _phoneNumberBtn.layer.borderColor = TEXT_COLOR.CGColor;
    _phoneNumberBtn.layer.borderWidth = 1.0f;
    [_phoneNumberBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    
    _helpButton.layer.borderColor = TEXT_COLOR.CGColor;
    _helpButton.layer.borderWidth = 1.0f;
    [_helpButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
}

-(void)show:(UIViewController * )VC
{
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismiss];
}


///点击回调
- (IBAction)phoneNumberClick:(id)sender {
    [self dismiss];
    if(self.block)
    {
        self.block(nil,nil,1);
    }

}

- (IBAction)helpClcik:(id)sender {
    [self dismiss];
    if(self.block)
    {
        self.block(nil,nil,2);
    }

}
- (IBAction)cancelClick:(id)sender {
    [self dismiss];
}

@end
