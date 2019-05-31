//
//  MySmallButton.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySmallButton : UIButton
/**
 *  上面的UILabel
 */
@property (nonatomic, strong) UILabel *top_Label;
/**
 *  下面的UILabel
 */
@property (nonatomic, strong) UILabel *bottom_Label;
/**
 *  下面的UIImageView
 */
@property (nonatomic, strong) UIImageView *bottom_Image;

@end
