//
//  PACarMangementTableViewCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PACarManagementModel.h"

@interface PACarMangementTableViewCell : UITableViewCell
@property (nonatomic, copy) ViewsEventBlock block;
-(void)assignmentWithModel:(PACarManagementModel *)vehicleModel;
-(void)limitedToEdit:(BOOL)isLimited;
@end
