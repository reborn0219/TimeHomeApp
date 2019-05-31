//
//  PAHomeMenuCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/8/1.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAHomeMenuCell : UITableViewCell

@property (nonatomic, copy)ViewsEventBlock callback;
@property (nonatomic,strong)NSArray * menuArray;
@end
