//
//  VehicleAlertVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VehicleAlertVC.h"

@interface VehicleAlertVC ()

{

    NSString * msgTitle;
    BOOL show;
    BOOL success;
    BOOL fault;
    BOOL isBinding;
    BOOL isLight;
}
@end

@implementation VehicleAlertVC


#pragma mark - 单例初始化
- (IBAction)closeAction:(id)sender {
    if (self.block!=nil) {
        self.block(0);
    }
    [self dismiss];

}
+(instancetype)shareVehicleAlert
{
    
    VehicleAlertVC * shareVehicleAlert = [[self alloc] initWithNibName:@"VehicleAlertVC" bundle:nil];
    return shareVehicleAlert;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.confirmBtn.layer.borderWidth = 1;
    self.confirmBtn.layer.borderColor = PURPLE_COLOR.CGColor;
    self.closeBtn.layer.borderWidth = 1;
    self.closeBtn.layer.borderColor = UIColorFromRGB(0x949494).CGColor;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleLb.text = msgTitle;
    if (show) {
        
        self.middleLayout.constant = 0;
        [self.closeBtn setHidden:NO];

    }else
    {
        [self.closeBtn setHidden:YES];
        self.middleLayout.constant = -(SCREEN_WIDTH-20)/2+5;

    }
    
    if (success) {
        
        [self.backImg setBackgroundColor:PURPLE_COLOR];
        self.backImg.image = [UIImage imageNamed:@"弹框-已成功-图标"];
//        [self.imgBtn setImage:[UIImage imageNamed:@"弹框-已成功-图标"] forState:UIControlStateNormal];
        
    }else
    {
        [self.backImg setBackgroundColor:UIColorFromRGB(0x4E4F50)];
//        [self.imgBtn setImage:[UIImage imageNamed:@"弹框-不成功-图标"] forState:UIControlStateNormal];
        self.backImg.image = [UIImage imageNamed:@"弹框-不成功-图标"];

    }
    
    if (isBinding) {
        [self.backImg setBackgroundColor:UIColorFromRGB(0x4E4F50)];
        if (isLight) {
            [self.backImg setBackgroundColor:UIColorFromRGB(0x8c8c8c)];
        }
        self.backImg.image = [UIImage imageNamed:@"弹窗-解除绑定底图标"];
    }
    
    if(fault){
        
        [self.backImg setBackgroundColor:UIColorFromRGB(0x4E4F50)];
        self.backImg.image = [UIImage imageNamed:@"车库开闸-弹窗背景图标"];
    }
}
/**
 *  是否显示绑定
 */
-(void)showithTitle:(NSString *)title :(UIViewController *)VC  ShowCancelBtn:(BOOL)isShow ISBinding:(BOOL)isOK isLignt:(BOOL)light {
    
    msgTitle = title;
    show = isShow;
    isBinding = isOK;
    isLight = light;
    
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

-(void)showithTitle:(NSString *)title
     viewcontroller:(UIViewController *)VC
      ShowCancelBtn:(BOOL)isShow
            isFault:(BOOL)isFault{
    
    msgTitle = title;
    show = isShow;
    fault = isFault;
    
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

-(void)showithTitle:(NSString *)title :(UIViewController *)VC  ShowCancelBtn:(BOOL)isShow ISSuccess:(BOOL)isOK
{
    msgTitle = title;
    show = isShow;
    success = isOK;
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)confirmAction:(id)sender {

    if (self.block!=nil) {
        self.block(1);
    }
    [self dismiss];
}
@end
