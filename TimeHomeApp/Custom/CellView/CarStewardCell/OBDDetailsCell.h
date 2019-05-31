//
//  OBDDetailsCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDDetailsCell : UITableViewCell
//数据项
@property (weak, nonatomic) IBOutlet UILabel *dataItemLabel;

//单位
@property (weak, nonatomic) IBOutlet UILabel *measureLabel;

//当前值
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@end
