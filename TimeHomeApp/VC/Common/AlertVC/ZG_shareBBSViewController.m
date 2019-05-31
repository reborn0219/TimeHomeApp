//
//  ZG_shareBBSViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/8/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZG_shareBBSViewController.h"

@interface ZG_shareBBSViewController ()

@end

@implementation ZG_shareBBSViewController

#pragma mark - 初始化
+(instancetype)shareZG_shareBBSVC{
    
    ZG_shareBBSViewController * ZG_shareBBS= [[ZG_shareBBSViewController alloc] initWithNibName:@"ZG_shareBBSViewController" bundle:nil];
    return ZG_shareBBS;
}

#pragma mark - 关闭VC
-(void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)showInVC:(UIViewController *)VC with:(NSString *)infoStr {
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)weChatFriend:(id)sender {
    
    if (self.buttonDidClickBlock) {
        [self dismiss];
        self.buttonDidClickBlock(@"weChatFriendClick");
    }
}

- (IBAction)weChatList:(id)sender {
    
    if (self.buttonDidClickBlock) {
        [self dismiss];
        self.buttonDidClickBlock(@"weChatListClick");
    }
}

- (IBAction)BBSClick:(id)sender {
    
    if (self.buttonDidClickBlock) {
        [self dismiss];
        self.buttonDidClickBlock(@"BBSClick");
    }
}

- (IBAction)canelButtonClick:(id)sender {
    
    [self dismiss];
}

@end
