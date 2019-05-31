//
//  L_NewBikeInfoImageTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/23.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeListModel.h"

typedef void(^ImageButtonDidTouchBlock)(NSInteger buttonIndex);

@interface L_NewBikeInfoImageTVC : UITableViewCell

@property (nonatomic, strong) L_BikeListModel *bikeModel;

@property (nonatomic, copy) ImageButtonDidTouchBlock imageButtonDidTouchBlock;

@end
