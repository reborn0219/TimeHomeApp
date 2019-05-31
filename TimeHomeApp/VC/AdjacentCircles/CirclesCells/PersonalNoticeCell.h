//
//  PersonalNoticeCell.h
//  TimeHomeApp
//
//  Created by UIOS on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
/**
 *  时间label
 */
@property (weak, nonatomic) IBOutlet UILabel *time_Label;
/**
 *  右边的图片
 */
@property (nonatomic, strong) UIImageView *rigntImage;

@end
