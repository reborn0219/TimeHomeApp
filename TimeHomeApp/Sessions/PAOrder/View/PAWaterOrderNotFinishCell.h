//
//  PAWaterOrderNotFinishCell.h
//  TimeHomeApp
//
//  Created by ning on 2018/8/4.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAWaterOrderModel.h"
@interface PAWaterOrderNotFinishCell : UITableViewCell
@property (nonatomic,strong) PAWaterOrderModel *orderModelData;
@property (nonatomic,copy) ViewsEventBlock gotoWaterBlock;
@end
