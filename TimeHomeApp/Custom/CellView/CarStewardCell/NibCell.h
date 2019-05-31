//
//  NibCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/13.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import <UIKit/UIKit.h>

@interface NibCell : UICollectionViewCell<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
-(void)startAnimation;
@end
