//
//  L_BikeWarningTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BikeWarningTVC.h"

@implementation L_BikeWarningTVC

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //遍历子视图，找出左滑按钮
    
    for (UIView *subView in self.subviews)
        
    {
        
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            
        {
            
            for (UIButton *btn in subView.subviews) {
                
                if ([btn isKindOfClass:[UIButton class]]) {
                    
                    btn.titleLabel.font = [UIFont systemFontOfSize:15];
                        
                }
            }
        }
    }
    
}

- (void)setModel:(L_BikeAlermModel *)model {
    
    _model = model;
    
    NSString *timeStr = @"";
    if (model.systime.length > 16) {
        timeStr = [model.systime substringToIndex:16];
    }else {
        timeStr = model.systime;
    }
    NSDate *date = [XYString NSStringToDate:timeStr withFormat:@"yyyy-MM-dd HH:mm"];
    timeStr = [XYString NSDateToString:date withFormat:@"yyyy.MM.dd HH:mm"];
    
    _time_Label.text = [XYString IsNotNull:timeStr];
    
    _communityName_Label.text = [XYString IsNotNull:model.communityname];
    
    _detail_Label.text = [XYString IsNotNull:model.content];
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_detail_Label.frame);
    
    model.height = rectY + 10;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.contentView.layer.borderWidth = 1.;
    self.contentView.layer.borderColor = UIColorFromRGB(0xc1c1c1).CGColor;
    
    _detail_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 20. - 20.;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
