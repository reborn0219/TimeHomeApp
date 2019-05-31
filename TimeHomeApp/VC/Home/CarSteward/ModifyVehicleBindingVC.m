//
//  ModifyVehicleBindingVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ModifyVehicleBindingVC.h"
#import "VehicleAlertVC.h"
#import "AddCarController.h"
#import "BindingCarVC.h"
#import "CarManagerPresenter.h"
#import "ModifyVehicleVC.h"
@interface ModifyVehicleBindingVC ()

@end

@implementation ModifyVehicleBindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车辆管理";
    
    [self creatTapGesture];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.cardLb.text = _LS_CIFML.card;
    self.aliseLb.text = _LS_CIFML.modelsname;
    self.xulieLb.text = _LS_CIFML.deviceno;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creatTapGesture
{
    UITapGestureRecognizer * tap_one = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewOneTouchAction:)];
    [self.view_one addGestureRecognizer:tap_one];
    UITapGestureRecognizer * tap_two = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTwoTouchAction:)];
    [self.view_two addGestureRecognizer:tap_two];
    
    UITapGestureRecognizer * tap_three = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewThreeTouchAction:)];
    [self.view_three addGestureRecognizer:tap_three];
    
    
}
#pragma mark - 触摸事件
-(void)viewOneTouchAction:(UIGestureRecognizer *)tapGesture
{
    @WeakObj(self);
    
    VehicleAlertVC * vc = [[VehicleAlertVC alloc] init];
    [vc showithTitle:@"您确定解除设备绑定吗？" :self ShowCancelBtn:YES ISSuccess: NO];
    vc.block = ^(NSInteger type)
    {
        
        if (type == 1) {
            
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
            [indicator startAnimating:self.tabBarController];
            [CarManagerPresenter clearbindingCarInfoWithID:_LS_CIFML.carID AndBlock:^(id  _Nullable data, ResultCode resultCode) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [indicator stopAnimating];
                    
                    if (resultCode == SucceedCode) {
                        
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                        ModifyVehicleVC *modify = [[ModifyVehicleVC alloc] init];
                        modify.LS_CIFML = _LS_CIFML;
                        [arr insertObject:modify atIndex:arr.count - 1];
                        [selfWeak.navigationController setViewControllers:arr animated:NO];
                        [selfWeak.navigationController popToViewController:modify animated:NO];
                        
                    }else
                    {
                        
                    }
                });
                
            }];
        }
    };

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
@end
