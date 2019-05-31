//
//  THMyCarAuthorityViewController.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的车位权限授权界面
 */
#import "THBaseViewController.h"
#import "ParkingOwner.h"

typedef void (^ CallBack)(void);
@interface THMyCarAuthorityViewController : THBaseViewController
/**
 *  我的车位权限信息
 */
@property (nonatomic, strong) ParkingOwner *owner;

@property (nonatomic, copy) CallBack callBack;

///如果是从车位跳转过来 为YES
@property(nonatomic,assign)BOOL isFromParking;

@end
