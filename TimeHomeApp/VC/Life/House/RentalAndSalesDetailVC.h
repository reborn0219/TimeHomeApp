//
//  RentalAndSalesDetailVC.h
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  求租，求售
 */
#import "BaseViewController.h"
#import "UserPublishRoom.h"

typedef void(^RefreshDataBlock)();

@interface RentalAndSalesDetailVC : THBaseViewController

/**
 *  0 求租 1 求购
 */
@property(nonatomic,assign)int jmpCode;
///求租求购房子数据
@property(nonatomic,strong) UserPublishRoom *publishRoom;

@property (nonatomic, copy) RefreshDataBlock refreshDataBlock;

@end
