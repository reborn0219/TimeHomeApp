//
//  THMyPublishCarTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我发布的车位自定义cell
 */
#import "THABaseTableViewCell.h"

/**
 *  我发布的车位model
 */
#import "UserPublishCar.h"

@interface THMyPublishCarTVC : UITableViewCell

/**
 *  左边名称标题
 */
@property (nonatomic, strong) UILabel *title_Label;
/**
 *  左边名称副标题
 */
@property (nonatomic, strong) UILabel *detail_Label;
/**
 *  左边价格
 */
@property (nonatomic, strong) UILabel *price_Label;
/**
 *  我发布的车位model
 */
@property (nonatomic, strong) UserPublishCar *userCar;

@end
