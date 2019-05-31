//
//  L_HelpListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "L_HelpModel.h"

@interface L_HelpListTVC : UITableViewCell

@property (nonatomic, strong) L_HelpModel *model;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
