//
//  CircleHeaderView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/2/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CircleHeaderView.h"

@implementation CircleHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];


    self.sexAgeView.layer.cornerRadius = 9;
    
    UITapGestureRecognizer * tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVtouchAction:)];
    self.headerImgV.layer.cornerRadius = 25;
    self.headerImgV.clipsToBounds = YES;
    self.headerImgV.userInteractionEnabled = YES;
    [self.headerImgV addGestureRecognizer:tapGest];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapAction:)];
    self.contentLb.userInteractionEnabled = YES;
    self.contentLb.font = [UIFont systemFontOfSize:15];
    [self.contentLb addGestureRecognizer:tap];
   
    UITapGestureRecognizer * tap_title = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTapAction:)];
    self.titleLb.userInteractionEnabled = YES;
    self.titleLb.font = [UIFont systemFontOfSize:15];
    self.titleLb.textColor = BLUE_TEXT_COLOR;
    [self.titleLb addGestureRecognizer:tap_title];

    
    UITapGestureRecognizer * tap_touchView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapAction:)];
    self.touchView.userInteractionEnabled = YES;
    [self.touchView addGestureRecognizer:tap_touchView];
    
    
}
-(void)titleTapAction:(UIGestureRecognizer *)gesInfo
{
    self.contentBlock(@"1",nil,_indexPath);
    
}
-(void)contentTapAction:(UIGestureRecognizer *)gesInfo
{
    self.contentBlock(@"2",nil,_indexPath);
    
}
-(void)imgVtouchAction:(UIGestureRecognizer *)gesInfo
{
    NSLog(@"点击头像");
    self.headerBlock(nil,nil,_indexPath);
}
@end
