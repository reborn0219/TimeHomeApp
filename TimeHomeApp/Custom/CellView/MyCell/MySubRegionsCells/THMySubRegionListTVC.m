//
//  THMySubRegionListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMySubRegionListTVC.h"

@implementation THMySubRegionListTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _topTitleLabel = [[UILabel alloc]init];
//    _topTitleLabel.backgroundColor = [UIColor redColor];
    _topTitleLabel.font = DEFAULT_FONT(16);
    _topTitleLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_topTitleLabel];
    _topTitleLabel.sd_layout.leftSpaceToView(self.contentView,30).widthIs(SCREEN_WIDTH-105-14-30-5).topSpaceToView(self.contentView,15);
//    [_topTitleLabel setSingleLineAutoResizeWithMaxWidth:150];
    

    _rightImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_rightImageView];
    _rightImageView.sd_layout.rightSpaceToView(self.contentView,30).bottomEqualToView(_topTitleLabel).widthIs(12).heightEqualToWidth();
    
    _rightLabel = [[UILabel alloc]init];
    _rightLabel.hidden = YES;
//    _rightLabel.text = @"业主认证";
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.font = DEFAULT_FONT(14);
    _rightLabel.textColor = kNewRedColor;
//    _rightLabel.layer.borderColor = PURPLE_COLOR.CGColor;
//    _rightLabel.layer.borderWidth = 1;
    [self.contentView addSubview:_rightLabel];
    _rightLabel.sd_layout.rightSpaceToView(self.contentView,15).bottomEqualToView(_topTitleLabel).widthIs(90).heightIs(22);
    _rightLabel.sd_cornerRadiusFromHeightRatio = @(0.5);

    
    _bottomLabel = [[UILabel alloc]init];
    _bottomLabel.font = DEFAULT_FONT(14);
    _bottomLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:_bottomLabel];
    _bottomLabel.sd_layout.leftEqualToView(_topTitleLabel).topSpaceToView(_topTitleLabel,10).widthIs(250).heightIs(24);
    
    [self setupAutoHeightWithBottomView:_bottomLabel bottomMargin:24];
    
}
- (void)setUser:(UserCommunity *)user {
    _user = user;
    
    _topTitleLabel.text = user.name;
    _bottomLabel.text = user.address;
    
    _bottomLabel.sd_layout.leftEqualToView(_topTitleLabel).topSpaceToView(_topTitleLabel,25).widthIs(250).heightIs(24);
    if (user.iscert.boolValue == YES) {
        _rightLabel.hidden = YES;
        _rightImageView.hidden = NO;
        _rightImageView.image = [UIImage imageNamed:@"我的小区_业主认证"];
    }else {
        if (user) {
            _rightLabel.text = @"业主认证";
            _rightLabel.layer.borderColor = kNewRedColor.CGColor;
            _rightLabel.layer.borderWidth = 1;
        }

        _rightLabel.hidden = NO;
        _rightImageView.hidden = YES;
    }
    

    
}
- (void)setCertlistModel:(UserCertlistModel *)certlistModel {
    
    _certlistModel = certlistModel;
    
    _topTitleLabel.text = certlistModel.name;
    _bottomLabel.text = certlistModel.address;
    _bottomLabel.sd_layout.leftEqualToView(_topTitleLabel).topSpaceToView(_topTitleLabel,10).widthIs(250).heightIs(24);
    _rightLabel.hidden = YES;
    _rightImageView.hidden = NO;
    _rightImageView.image = [UIImage imageNamed:@"我的小区_已认证小区"];
}

@end
