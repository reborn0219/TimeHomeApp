//
//  PostHeaderView.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PostHeaderView.h"

@implementation PostHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.titleLb bringSubviewToFront:self];

    self.contentLb.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapAction:)];
    [self.contentLb addGestureRecognizer:tap2];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTapAction:)];
    self.titleLb.userInteractionEnabled = YES;
    [self.titleLb addGestureRecognizer:tap1];
    
}
-(void)titleTapAction:(UIGestureRecognizer *)gestInfo
{
    self.contentBlock(@"1",nil,_indexPath);
}
-(void)contentTapAction:(UIGestureRecognizer *)gestInfo
{
    self.contentBlock(@"2",nil,_indexPath);

}
- (IBAction)delAction:(id)sender {
    self.block(nil,nil,_indexPath);
}
@end
