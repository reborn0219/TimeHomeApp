//
//  CarStewardCell2.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarStewardCell2 : UITableViewCell
//左边label
@property (weak, nonatomic) IBOutlet UILabel *leftlabel1;
//左边英文
@property (weak, nonatomic) IBOutlet UILabel *leftLabel2;
//左边图片
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;

//右边label
@property (weak, nonatomic) IBOutlet UILabel *rightLabel1;
//右边英文
@property (weak, nonatomic) IBOutlet UILabel *rightLabel2;
//右边图片
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

//左边展示label
@property (weak, nonatomic) IBOutlet UILabel *leftShowLabel;
//右边展示label
@property (weak, nonatomic) IBOutlet UILabel *rightShowLabel;

@property (weak, nonatomic) IBOutlet UIView *grayBgView;

- (void)setLabelHidden;


- (void)setBigLabelFontAndFrame;

- (void)setSmallLabelFontAndFrame;


@end
