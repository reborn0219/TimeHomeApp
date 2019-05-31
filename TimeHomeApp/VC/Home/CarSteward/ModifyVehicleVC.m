//
//  ModifyVehicleVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ModifyVehicleVC.h"
#import "QrCodeScanningVC.h"
#import "VehicleAlertVC.h"
#import "AddCarController.h"
#import "BindingCarVC.h"
#import "CarManagerPresenter.h"
#import "VehicleManagementVC.h"
#import "CarStewardFirstVC.h"

@interface ModifyVehicleVC ()<BackValueDelegate>
@property (nonatomic, copy)NSString *tempStr;
@end

@implementation ModifyVehicleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆设置";
    [self creatTapGesture];
    _view_zero.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
    _view_zero.layer.borderWidth = 1;
    _tempStr = @"";
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"carSetTongZhi" object:nil];
    if ([_tempStr isEqualToString:@""]) {
        
        self.cardLb.text = _LS_CIFML.card;
        self.aliseLb.text = _LS_CIFML.alias;
    }
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)creatTapGesture
{
    UITapGestureRecognizer * tap_one = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewOneTouchAction:)];
    self.view_one.layer.borderColor = PURPLE_COLOR.CGColor;
    self.view_one.layer.borderWidth = 1;
    [self.view_one addGestureRecognizer:tap_one];
    
   UITapGestureRecognizer * tap_two = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTwoTouchAction:)];
    [self.view_two addGestureRecognizer:tap_two];
    
   UITapGestureRecognizer * tap_three = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewThreeTouchAction:)];
    [self.view_three addGestureRecognizer:tap_three];
    
}

///通知事件
- (void)tongzhi:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"carNumber"]);//carOtherName
    if (text.userInfo != nil) {
        _tempStr = text.userInfo[@"carNumber"];
        _cardLb.text = text.userInfo[@"carNumber"];
        _aliseLb.text = text.userInfo[@"carOtherName"];
    }else {
       
    }
    
}
#pragma mark - 触摸事件
-(void)viewOneTouchAction:(UIGestureRecognizer *)tapGesture
{
    if ([XYString isBlankString:self.scanningTF.text]) {
     
        [self showToastMsg:@"请先输入或扫描条形码获取设备序列号" Duration:2.0f];
        return;
        
    }
    @WeakObj(self);
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [CarManagerPresenter bindingCarInfoWithID:_LS_CIFML.carID withStr:self.scanningTF.text AndBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                
                
                VehicleAlertVC *alertVC = [[VehicleAlertVC alloc] init];
                [alertVC showithTitle:@"设备已绑定成功！" :self ShowCancelBtn:NO ISSuccess:YES];
                alertVC.block = ^(NSInteger type)
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
                VehicleAlertVC *alertVC = [[VehicleAlertVC alloc] init];
                [alertVC showithTitle:data :self ShowCancelBtn:NO ISSuccess:NO];

            }

        });
        
    }];
    
    
    
}
/**
 *  编辑车辆
 */
-(void)viewTwoTouchAction:(UIGestureRecognizer *)tapGesture
{

    AddCarController * setVC = [[AddCarController alloc]init];
    setVC.carInfoModel = _LS_CIFML;
    setVC.from = Modify;
    [self.navigationController pushViewController:setVC animated:YES];
    
}
-(void)viewThreeTouchAction:(UIGestureRecognizer *)tapGesture
{
    VehicleAlertVC *vc = [[VehicleAlertVC alloc] init];
    [vc showithTitle:@"您确定删除车辆吗？" :self ShowCancelBtn:YES ISSuccess: NO];
    @WeakObj(self);
    vc.block = ^(NSInteger type)
    {
        if (type == 1) {

            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
            [indicator startAnimating:self.tabBarController];
            [CarManagerPresenter deleteCarInfoWithID:selfWeak.LS_CIFML.carID AndBlock:^(id  _Nullable data, ResultCode resultCode) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [indicator stopAnimating];
                    
                    if (resultCode == SucceedCode) {
                        NSLog(@"%@",data);
                        
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                        
                    }else
                    {
                        if ([data isKindOfClass:[NSString class]]) {
                            if (![XYString isBlankString:data]) {
                                [selfWeak showToastMsg:data Duration:3.0];
                            }else {
                                [selfWeak showToastMsg:@"网络连接错误" Duration:3.0];
                            }
                        }
                    }

                });
                
            }];
        }
    };

}


- (IBAction)ScanningAction:(id)sender {
//
    if (![self canOpenCamera]) {
        return;
    }

    QrCodeScanningVC * QrCodeVc=[[QrCodeScanningVC alloc]init];
    QrCodeVc.delegate=self;
    [self.navigationController pushViewController:QrCodeVc animated:YES];

}
-(void)backValue:(NSString *)value
{
    self.scanningTF.text=value;
    
}

@end
