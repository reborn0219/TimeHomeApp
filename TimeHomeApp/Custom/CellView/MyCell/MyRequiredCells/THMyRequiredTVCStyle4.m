//
//  THMyRequiredTVCStyle4.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyRequiredTVCStyle4.h"
#import "THLineView.h"

@interface THMyRequiredTVCStyle4 ()
{
    /**
     *  评价级别
     */
    NSString *evaluatelevel;
    /**
     *  评价内容
     */
    NSString *evaluate;
}
/**
 *  竖线
 */
@property (nonatomic, strong) UIView *line;
/**
 *  等级label
 */
@property (nonatomic, strong) UILabel *levelLabel;
/**
 *  详细评价
 */
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation THMyRequiredTVCStyle4

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = BLACKGROUND_COLOR;
        self.backgroundColor = BLACKGROUND_COLOR;
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    //时间轴
    THLineView *lineView = [[THLineView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.sd_layout.leftEqualToView(self.contentView).topEqualToView(self.contentView).bottomSpaceToView(self.contentView,-1).widthIs(28);
    
    _timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = DEFAULT_FONT(14);
    _timeLabel.textColor = TEXT_COLOR;
    _timeLabel.sd_layout.leftSpaceToView(lineView,5).topSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).heightIs(20);
    
    _titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.textColor = TITLE_TEXT_COLOR;
    _titleLabel.font = DEFAULT_FONT(16);
    _titleLabel.sd_layout.leftEqualToView(_timeLabel).topSpaceToView(_timeLabel,15).rightEqualToView(_timeLabel).autoHeightRatio(0);
    
    _line = [[UIView alloc]init];
    [self.contentView addSubview:_line];
    _line.sd_layout.leftSpaceToView(self.contentView,60+5+28).centerYEqualToView(_titleLabel).widthIs(4).heightIs(22);
    _line.sd_cornerRadiusFromWidthRatio = @0.5;
    
    _levelLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_levelLabel];
    _levelLabel.font = DEFAULT_FONT(16);
    _levelLabel.textColor = TITLE_TEXT_COLOR;
    _levelLabel.sd_layout.leftSpaceToView(_line,10).centerYEqualToView(_titleLabel).widthIs(100).heightIs(20);
    
    _contentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = DEFAULT_FONT(14);
    _contentLabel.textColor = TEXT_COLOR;
    _contentLabel.sd_layout.leftSpaceToView(_line,10).topSpaceToView(_line,6).rightEqualToView(_timeLabel).autoHeightRatio(0);

    [self setupAutoHeightWithBottomViewsArray:@[_titleLabel,_contentLabel] bottomMargin:15];
//    [self setupAutoHeightWithBottomView:_titleLabel bottomMargin:15];
//    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:15];

}
- (void)setIsCompleted:(BOOL)isCompleted {
    _isCompleted = isCompleted;
    
}
- (void)setModel:(UserReserveInfo *)model {
    _model = model;
    evaluatelevel = model.evaluatelevel;
    evaluate = model.evaluate;
}
- (void)setUserInfo:(UserReserveLog *)userInfo {
    _userInfo = userInfo;
    
    NSString *dateString = [userInfo.systime substringToIndex:16];
    
    _timeLabel.text = dateString;
    _titleLabel.text = userInfo.content;
    
    if (_isCompleted) {
        _titleLabel.text = @"已评价";
        _line.backgroundColor = kNewRedColor;
        
        if ([evaluatelevel intValue] == 3) {
            _levelLabel.text = @"不满意";
        }
        if ([evaluatelevel intValue] == 2) {
            _levelLabel.text = @"满意";
        }
        if ([evaluatelevel intValue] == 1) {
            _levelLabel.text = @"非常满意";
        }
        
        if (![XYString isBlankString:evaluate]) {
            _contentLabel.text = [NSString stringWithFormat:@"%@",evaluate];
        }
    }else {
        _contentLabel.text = @"";
        _levelLabel.text = @"";
        _line.backgroundColor = [UIColor clearColor];

    }
    
//    if ([userInfo.state intValue] == 4) {
//        _titleLabel.text = @"已评价";
//        _line.backgroundColor = PURPLE_COLOR;
//
//        if ([evaluatelevel intValue] == 3) {
//            _levelLabel.text = @"不满意";
//        }
//        if ([evaluatelevel intValue] == 2) {
//            _levelLabel.text = @"满意";
//        }
//        if ([evaluatelevel intValue] == 1) {
//            _levelLabel.text = @"非常满意";
//        }
//
//        if (![XYString isBlankString:evaluate]) {
//            _contentLabel.text = [NSString stringWithFormat:@"%@",evaluate];
//        }
//        
//    }
//    else {
//        _contentLabel.text = @"";
//    }

}


@end
