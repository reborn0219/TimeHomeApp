//
//  L_HouseDetailBaseTVC5.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailBaseTVC5.h"

@implementation L_HouseDetailBaseTVC5

- (void)setModel:(L_HouseInfoModel *)model {
    
    _model = model;
    
    _communityName_Label.text = [XYString IsNotNull:model.communityname];
    _address_Label.text = [XYString IsNotNull:model.address];
    _house_Label.text = [XYString IsNotNull:model.resiname];
    // 被授权：1.出租 2.共享
    if (model.infoType == 1) {
        _authoryStyle_Label.text = @"出租";
        _chuzuTitle_Label.hidden = NO;
        _chuzuDate_Label.hidden = NO;
        
        NSString *beginDateStr = @"";
        NSString *endDateStr = @"";

        if (![XYString isBlankString:model.rentbegindate]) {
            if (model.rentbegindate.length > 10) {
                beginDateStr = [model.rentbegindate substringToIndex:10];
            }else {
                beginDateStr = model.rentbegindate;
            }
            NSDate *beginDate = [XYString NSStringToDate:beginDateStr withFormat:@"yyyy-MM-dd"];
            beginDateStr = [XYString NSDateToString:beginDate withFormat:@"yyyy.MM.dd"];
        }
        
        if (![XYString isBlankString:model.rentenddate]) {
            if (model.rentenddate.length > 10) {
                endDateStr = [model.rentenddate substringToIndex:10];
            }else {
                endDateStr = model.rentenddate;
            }
            NSDate *endDate = [XYString NSStringToDate:endDateStr withFormat:@"yyyy-MM-dd"];
            endDateStr = [XYString NSDateToString:endDate withFormat:@"yyyy.MM.dd"];
        }

        _chuzuDate_Label.text = [NSString stringWithFormat:@"%@-%@",beginDateStr,endDateStr];
        
        _bottomLayout.constant = 48;
        
    }else if (model.infoType == 2) {
        _authoryStyle_Label.text = @"共享";
        _chuzuTitle_Label.hidden = YES;
        _chuzuDate_Label.hidden = YES;
        _bottomLayout.constant = 18;

    }else {
        _authoryStyle_Label.text = @"";
        _chuzuTitle_Label.hidden = YES;
        _chuzuDate_Label.hidden = YES;
        _bottomLayout.constant = 18;

    }
    
    NSString *timeStr = @"";
    if (model.powertime.length > 16) {
        timeStr = [model.powertime substringToIndex:16];
    }else {
        timeStr = model.powertime;
    }
    NSDate *date = [XYString NSStringToDate:timeStr withFormat:@"YYYY-MM-dd HH:mm"];
    timeStr = [XYString NSDateToString:date withFormat:@"YYYY.MM.dd HH:mm"];
    
    _time_Label.text = [XYString IsNotNull:timeStr];
    _people_Label.text = [XYString IsNotNull:model.householder];
    _phone_Label.text = [XYString IsNotNull:model.phone];
    
    [self layoutIfNeeded];
    
    // 被授权：1.出租 2.共享
    if (model.infoType == 1) {
        
        CGFloat rectY = CGRectGetMaxY(_chuzuDate_Label.frame);
        
        model.height = rectY + 15;
        
    }else if (model.infoType == 2) {
        CGFloat rectY = CGRectGetMaxY(_phone_Label.frame);
        
        model.height = rectY + 15;
        
    }else {
        CGFloat rectY = CGRectGetMaxY(_phone_Label.frame);
        
        model.height = rectY + 15;
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.authorizationStateLabel.clipsToBounds = YES;
    self.authorizationStateLabel.layer.cornerRadius = 2;
    self.authorizationStateLabel.layer.borderColor = PREPARE_MAIN_BLUE_COLOR.CGColor;
    self.authorizationStateLabel.textColor = PREPARE_MAIN_BLUE_COLOR;
    self.authorizationStateLabel.layer.borderWidth = 1;
    _communityName_Label.text = @"";
    _address_Label.text = @"";
    _house_Label.text = @"";
    _authoryStyle_Label.text = @"";
    _time_Label.text = @"";
    _people_Label.text = @"";
    _phone_Label.text = @"";

    _address_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 38 - 62 - 30;
    _house_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 38 - 62 - 30;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
