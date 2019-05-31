//
//  Ls_ActiveCell.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/1/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "Ls_ActiveCell.h"
#import "UserActivity.h"

@implementation Ls_ActiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setActivity:(UserActivity *)activity{
    if (_activity != activity) {
        _activity = activity;
    }
    self.activeLb.text = activity.title;
    
    NSString *beginString = [activity.begindate substringToIndex:10];
    NSString *endString = [activity.enddate substringToIndex:10];
    
    beginString = [XYString NSDateToString:[XYString NSStringToDate:beginString withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy/MM/dd"];
    endString = [XYString NSDateToString:[XYString NSStringToDate:endString withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy/MM/dd"];
    NSInteger endtype=[activity.endtype integerValue];
    if(endtype==0)
    {
        self.endBtn.hidden=YES;
    }else
    {
        self.endBtn.hidden=NO;
    }
    
    self.timeLb.text = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:activity.picurl] placeholderImage:PLACEHOLDER_IMAGE];
}

@end
