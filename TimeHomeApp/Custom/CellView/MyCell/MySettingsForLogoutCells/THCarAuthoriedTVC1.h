//
//  THCarAuthoriedTVC1.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THABaseTableViewCell.h"
#import "ParkingOwner.h"

/**
 *  车位权限 出租按钮TVC
 */
@interface THCarAuthoriedTVC1 : UITableViewCell
/**
 *  右边label
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  左边label
 */
@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) ParkingOwner *parkingOwner;

@end
