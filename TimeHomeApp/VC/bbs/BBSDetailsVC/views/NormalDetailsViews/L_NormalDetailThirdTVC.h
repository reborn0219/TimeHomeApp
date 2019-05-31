//
//  L_NormalDetailThirdTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "L_NormalInfoModel.h"

@interface L_NormalDetailThirdTVC : UITableViewCell

/**
 浏览
 */
@property (weak, nonatomic) IBOutlet UILabel *liulanLabel;

@property (nonatomic, strong) L_NormalInfoModel *model;

@end
