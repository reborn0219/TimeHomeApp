//
//  L_HouseDetailSecondTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_HouseDetailModel.h"

@interface L_HouseDetailSecondTVC : UITableViewCell

@property (nonatomic, strong) L_HouseDetailModel *model;

/**
 房源描述标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 户型
 */
@property (weak, nonatomic) IBOutlet UILabel *roomsLabel;

/**
 面积
 */
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

/**
 楼层
 */
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

/**
 单价
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
