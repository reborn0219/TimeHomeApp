//
//  HomePageHeaderCell.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/11.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "HomePageHeaderCell.h"

@implementation HomePageHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    
    
      self.chatBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-8,0,0);
      self.followBtn.imageEdgeInsets =UIEdgeInsetsMake(0,-8,0,0);
    self.lineUpView.layer.cornerRadius = 14;
    self.lineUpView.layer.borderWidth = 1;
    self.lineUpView.layer.borderColor = UIColorFromRGB(0xBC5D61).CGColor;
    
    self.ageV.layer.cornerRadius = 8;
    self.imgV.layer.masksToBounds = YES;
    self.imgV.layer.cornerRadius = 25;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapAction:)];
    self.contentLb.userInteractionEnabled = YES;
    self.contentLb.font = [UIFont systemFontOfSize:15];
    [self.contentLb addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap_title = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTapAction:)];
    self.titleLb.userInteractionEnabled = YES;
    self.titleLb.font = [UIFont systemFontOfSize:15];
    self.titleLb.textColor = BLUE_TEXT_COLOR;
    [self.titleLb addGestureRecognizer:tap_title];
    
}
-(void)titleTapAction:(UIGestureRecognizer *)gesInfo
{
    self.contentBlock(@"1",nil,_indexPath);
    
}
-(void)contentTapAction:(UIGestureRecognizer *)gesInfo
{
    self.contentBlock(@"2",nil,_indexPath);
    
}

- (IBAction)chatAction:(id)sender {
    self.block(sender,1);
}
- (IBAction)followAction:(id)sender {
    self.block(sender,2);

}
@end
