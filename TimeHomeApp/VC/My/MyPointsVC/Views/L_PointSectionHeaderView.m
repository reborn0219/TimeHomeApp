//
//  L_PointSectionHeaderView.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PointSectionHeaderView.h"

@interface L_PointSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIView *firstLine;

@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIView *secondLine;

@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIView *thirdLine;

@end

@implementation L_PointSectionHeaderView

+ (L_PointSectionHeaderView *)getInstance {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"L_PointSectionHeaderView" owner:nil options:nil];
    L_PointSectionHeaderView *cv =[nibView objectAtIndex:0];
    
    [cv.firstButton setTitleColor:kNewRedColor forState:UIControlStateNormal];
    cv.firstLine.hidden = NO;
    
    [cv.secondButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    cv.secondLine.hidden = YES;
    
    [cv.thirdButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    cv.thirdLine.hidden = YES;
    
    return cv;
}

- (IBAction)allButtonDidTouch:(UIButton *)sender {
    //1 2 3
    
    switch (sender.tag) {
        case 1:
        {
            [self.firstButton setTitleColor:kNewRedColor forState:UIControlStateNormal];
            self.firstLine.hidden = NO;
            
            [self.secondButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
            self.secondLine.hidden = YES;
            
            [self.thirdButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
            self.thirdLine.hidden = YES;
        }
            break;
        case 2:
        {
            [self.firstButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
            self.firstLine.hidden = YES;
            
            [self.secondButton setTitleColor:kNewRedColor forState:UIControlStateNormal];
            self.secondLine.hidden = NO;
            
            [self.thirdButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
            self.thirdLine.hidden = YES;
        }
            break;
        case 3:
        {
            [self.firstButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
            self.firstLine.hidden = YES;
            
            [self.secondButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
            self.secondLine.hidden = YES;
            
            [self.thirdButton setTitleColor:kNewRedColor forState:UIControlStateNormal];
            self.thirdLine.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    
    if (self.sectionButtonDidTouchBlock) {
        self.sectionButtonDidTouchBlock(sender.tag);
    }
    
}


@end
