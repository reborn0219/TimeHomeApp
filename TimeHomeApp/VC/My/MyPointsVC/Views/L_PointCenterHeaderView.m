//
//  L_PointCenterHeaderView.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PointCenterHeaderView.h"
#import "UIImage+ImageEffects.h"

@interface L_PointCenterHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@end

@implementation L_PointCenterHeaderView


- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    
    //1.我的兑换 2.赚积分 3.花积分
    if (self.allButtonDidTouchBlock) {
        self.allButtonDidTouchBlock(sender.tag);
    }
    
}

+ (L_PointCenterHeaderView *)getInstance {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"L_PointCenterHeaderView" owner:nil options:nil];
    L_PointCenterHeaderView *cv =[nibView objectAtIndex:0];
    
    cv.lineView.layer.cornerRadius = 2.f;
    cv.lineView.clipsToBounds = YES;
    cv.changeButton.hidden = YES;
    
    cv.leftTitleLabel.layer.cornerRadius = 12.f;
    cv.pointLabel.layer.cornerRadius = 60;
    cv.leftTitleLabel.clipsToBounds = YES;
    cv.pointLabel.clipsToBounds = YES;
    
    cv.topLineView.hidden = YES;
    
    [cv.changeButton setImage:[[UIImage imageNamed:@"右箭头"] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    return cv;
}

@end
