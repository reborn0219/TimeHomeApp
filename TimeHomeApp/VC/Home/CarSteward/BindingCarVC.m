//
//  BindingCarVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//


#import "BindingCarVC.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CarCell.h"
#import "IntelligentGarageVC.h"
#import "CarManagerPresenter.h"
#import "VehicleAlertVC.h"
#import "QrCodeScanningVC.h"
#import "VehicleManagementVC.h"
#import "CarStewardFirstVC.h"

@interface BindingCarVC ()<AVCaptureMetadataOutputObjectsDelegate,BackValueDelegate>

@end

@implementation BindingCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"绑定设备";
    self.tabBarController.tabBar.hidden = YES;
    [self theUserInterface];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createBackBarButton];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}

#pragma mark -- UI
- (void)theUserInterface {
    
    _downButton.layer.masksToBounds =YES;
    _downButton.layer.borderColor = (UIColorFromRGB(0x949494)).CGColor;
    _downButton.layer.borderWidth = 1.0f;
    
    _bindButton.layer.masksToBounds =YES;
    _bindButton.layer.borderColor = PURPLE_COLOR.CGColor;
    _bindButton.layer.borderWidth = 1.0f;
    _bindButton.backgroundColor = BLACKGROUND_COLOR;
    
    _carNumberLabel.text = _carNameStr;
    _carOtherName.text = _carOtherNameStr;
    
    _scaningView.layer.borderColor = UIColorFromRGB(0xA7A7A7).CGColor;
    _scaningView.layer.borderWidth = 1.0f;
}

- (void)createBackBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    
    [button setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
}



- (void)backButtonClick {
    
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[VehicleManagementVC class]]) {
            [self.navigationController popToViewController:VC animated:YES];
            return ;
        }

    }
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[CarStewardFirstVC class]]) {
            [self.navigationController popToViewController:VC animated:YES];
            return ;
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];

    
}

#pragma mark -- 按钮点击
//扫码点击
- (IBAction)downButtonCLick:(id)sender {
    
    if (![self canOpenCamera]) {
        return;
    }
    
    QrCodeScanningVC * QrCodeVc=[[QrCodeScanningVC alloc]init];
    QrCodeVc.delegate=self;
    [self.navigationController pushViewController:QrCodeVc animated:YES];
    
    NSLog(@"扫描");
}
-(void)backValue:(NSString *)value
{
    self.firstTX.text=value;
}



#pragma mark -- 按钮点击
//绑定按钮点击
- (IBAction)bindButtonClick:(id)sender {
    
    
    if (_firstTX.text.length == 0) {
        
        [self showToastMsg:@"序列号不能为空" Duration:3.0f];
        
    }else {
        
        if ([XYString isBlankString:_uCarID]) {
            return;
        }
        
        @WeakObj(self)
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        
        [CarManagerPresenter bindingCarInfoWithID:_uCarID withStr:self.firstTX.text AndBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];

                if (resultCode == SucceedCode) {
                    
                    VehicleAlertVC * vc = [[VehicleAlertVC alloc] init];
                    [vc showithTitle:@"设备已绑定成功！" :self ShowCancelBtn:NO ISSuccess:YES];
                    vc.block = ^(NSInteger type)
                    {
                        for (UIViewController *VC in self.navigationController.viewControllers) {
                            if ([VC isKindOfClass:[VehicleManagementVC class]]) {
                                [selfWeak.navigationController popToViewController:VC animated:YES];
                                return ;
                            }

                        }
                        for (UIViewController *VC in self.navigationController.viewControllers) {
                            if ([VC isKindOfClass:[CarStewardFirstVC class]]) {
                                [selfWeak.navigationController popToViewController:VC animated:YES];
                                return ;
                            }
                            
                        }
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                    };
                    
                }else
                {
                    if ([data isKindOfClass:[NSString class]]) {
                        if (![XYString isBlankString:data]) {
                            VehicleAlertVC *alertVC = [[VehicleAlertVC alloc] init];
                            [alertVC showithTitle:data :self ShowCancelBtn:NO ISSuccess:NO];
                        }else {
                            [selfWeak showToastMsg:@"网络连接错误" Duration:3.0];
                        }
                    }
                }
            });
        }];
    }
    
    NSLog(@"绑定");
}


@end
