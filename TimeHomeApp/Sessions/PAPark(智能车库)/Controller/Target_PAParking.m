//
//  Target_PAParking.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "Target_PAParking.h"
#import "PAParkingViewController.h"

@implementation Target_PAParking

- (UIViewController *)Action_NativeToPAParkingViewController:(NSDictionary *)params{
    PAParkingViewController *parkingVC = [[PAParkingViewController alloc]initWithNibName:@"PAParkingViewController" bundle:nil];
    
    //  TODO:获取params参数并赋值到parkingVC中
    
    return parkingVC;
}

@end
