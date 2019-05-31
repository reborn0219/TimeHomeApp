//
//  L_HouseImageTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "L_HouseDetailModel.h"

typedef void(^ImageDidBlock)(NSInteger index);
@interface L_HouseImageTVC : UITableViewCell

@property (nonatomic, copy) ImageDidBlock imageDidBlock;

@property (nonatomic, strong) L_HouseDetailModel *model;

@end
