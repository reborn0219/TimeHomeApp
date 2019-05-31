//
//  L_MySellSectionHeader.h
//  TimeHomeApp
//
//  Created by 李世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_MySellSectionHeader : UIView

/**
 左边图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (L_MySellSectionHeader *)instanceSectionHeader;

@end
