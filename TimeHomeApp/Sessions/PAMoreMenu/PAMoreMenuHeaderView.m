//
//  PAMoreMenuHeaderView.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAMoreMenuHeaderView.h"
@interface PAMoreMenuHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;

@end

@implementation PAMoreMenuHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)assignmentWithTitle:(NSString *)classname color:(NSString *)color
{
    self.classNameLabel.text = classname;
    [self setUIColor:[UIColor colorWithHexString:color]];
}
-(void)setUIColor:(UIColor *)color
{
    [self.view1 setBackgroundColor:color];
    [self.view2 setBackgroundColor:color];
    [self.view3 setBackgroundColor:color];
    [self.view4 setBackgroundColor:color];
    [self.view5 setBackgroundColor:color];
    [self.view6 setBackgroundColor:color];
    [self.classNameLabel setTextColor:color];
}

@end
