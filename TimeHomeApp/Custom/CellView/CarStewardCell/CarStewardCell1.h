//
//  CarStewardCell1.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/27.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarStewardCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

//地区

@property (weak, nonatomic) IBOutlet UIButton *regionButton;


//车牌首字母

@property (weak, nonatomic) IBOutlet UIButton *carNumberButton;

@property(copy,nonatomic) ViewsEventBlock eventCallBack;

- (void)labelShow;
- (void)labelHidden;
@end
