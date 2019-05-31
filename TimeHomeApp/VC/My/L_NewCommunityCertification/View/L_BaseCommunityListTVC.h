//
//  L_BaseCommunityListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_BaseCommunityListTVC : UITableViewCell

/**
 左边标题
 */
@property (weak, nonatomic) IBOutlet UILabel *leftTitle_Label;

/**
 房产数量
 */
@property (weak, nonatomic) IBOutlet UILabel *houseCount_Label;


/**
 小红点
 */
@property (weak, nonatomic) IBOutlet UIView *dot_View;

/**
 分割线
 */
@property (weak, nonatomic) IBOutlet UIView *bottomLine_View;

/**
 右边标题
 */
@property (weak, nonatomic) IBOutlet UILabel *rightDetail_Label;

@end
