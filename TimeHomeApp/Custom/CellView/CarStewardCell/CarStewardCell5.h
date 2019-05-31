//
//  CarStewardCell5.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarStewardCell5 : UITableViewCell

//左边图片
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIView *littleView;
//车况label
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (void)viewHidden;
- (void)viewShow;

@end
