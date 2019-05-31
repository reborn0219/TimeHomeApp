//
//  THMyrequiredTVCStyle1-1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyrequiredTVCStyle1-1.h"

@implementation THMyrequiredTVCStyle1_1


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}
- (void)setUp {
    
    _lineView = [[UIView alloc]init];
    [self.contentView addSubview:_lineView];
    _lineView.sd_layout.rightSpaceToView(self.contentView,8).centerYEqualToView(self.contentView).heightIs(17).widthIs(4);
    _lineView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.font = DEFAULT_FONT(14);
    _detailLabel.textColor = TITLE_TEXT_COLOR;
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_detailLabel];
    _detailLabel.sd_layout.rightSpaceToView(_lineView,8).heightIs(20).widthIs(60).centerYEqualToView(self.contentView);
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = DEFAULT_FONT(16);
    _titleLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.sd_layout.centerYEqualToView(_detailLabel).leftSpaceToView(self.contentView,15).rightSpaceToView(_detailLabel,5).heightIs(20);
    
    [self setupAutoHeightWithBottomViewsArray:@[_lineView,_detailLabel,_titleLabel] bottomMargin:15];
    
}
- (void)setUserInfo:(UserReserveInfo *)userInfo {
    _userInfo = userInfo;
    _titleLabel.text = [NSString stringWithFormat:@"维修单号  %@",userInfo.reserveno];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    if ([userInfo.isok intValue] == 1) {
        
        switch ([userInfo.state intValue]) {
            case -1:
            {
                _detailLabel.text = @"已驳回";
                _lineView.backgroundColor = TEXT_COLOR;
            }
                break;
            case 0:
            {
                _detailLabel.text = @"待处理";
                _lineView.backgroundColor = kNewRedColor;
            }
                break;
            case 1:
            {
                _detailLabel.text = @"物业已接收";
                _lineView.backgroundColor = MAN_COLOR;//蓝色
            }
                break;
            case 2:
            {
                _detailLabel.text = @"处理中";
                _lineView.backgroundColor = MAN_COLOR;//蓝色
            }
                break;
            case 3:
            {
                _detailLabel.text = @"已完成 待评价";
                _lineView.backgroundColor = GREEN_COLOR;//绿色
            }
                break;
            case 4:
            {
                _detailLabel.text = @"已评价";
                _lineView.backgroundColor = GREEN_COLOR;//绿色
            }
                break;
            default:
            {
                _detailLabel.text = @"暂不维修";
                _lineView.backgroundColor = TEXT_COLOR;
            }
                break;
        }
        
    }else {
        _detailLabel.text = @"暂不维修";
        _lineView.backgroundColor = TEXT_COLOR;
    }
    
}
- (void)setUserComplaint:(UserComplaint *)userComplaint {
    _userComplaint = userComplaint;
    
    if ([userComplaint.state intValue] == 0) {
        _lineView.backgroundColor = kNewRedColor;
        _detailLabel.text = @"待处理";
    }else {
        _lineView.backgroundColor = GREEN_COLOR;
        _detailLabel.text = @"已处理";
    }
    NSString *dateString = [userComplaint.systime substringToIndex:16];
    _titleLabel.text = dateString;
    
}
- (void)setUserComplaint2:(UserComplaint *)userComplaint2 {
    _userComplaint2 = userComplaint2;
    if ([userComplaint2.state intValue] == 0) {
        _lineView.backgroundColor = kNewRedColor;
        _detailLabel.text = @"待处理";
    }else {
        _lineView.backgroundColor = GREEN_COLOR;
        _detailLabel.text = @"已处理";
    }
    _titleLabel.text = [NSString stringWithFormat:@"投诉单号: %@",userComplaint2.complaintno];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
}

@end
