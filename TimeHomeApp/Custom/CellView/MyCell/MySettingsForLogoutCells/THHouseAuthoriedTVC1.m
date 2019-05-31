//
//  THHouseAuthoriedTVC1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THHouseAuthoriedTVC1.h"

@implementation THHouseAuthoriedTVC1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {

    _rightLabel = [[UILabel alloc]init];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_rightLabel];
    _rightLabel.sd_layout.rightSpaceToView(self.contentView,15+10+5).topSpaceToView(self.contentView,15).widthIs(80).heightIs(20);
    
    _arrowImage= [[UIImageView alloc]init];
    _arrowImage.image = [UIImage imageNamed:@"我的_右箭头"];
    [self.contentView addSubview:_arrowImage];
    _arrowImage.sd_layout.rightSpaceToView(self.contentView,15).centerYEqualToView(_rightLabel).widthIs(10).heightEqualToWidth();
    
    _leftLabel = [[UILabel alloc]init];
    _leftLabel.textColor = TITLE_TEXT_COLOR;
    _leftLabel.font = DEFAULT_FONT(16);
    [self.contentView addSubview:_leftLabel];
    _leftLabel.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.contentView,15).rightSpaceToView(_rightLabel,5).autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomViewsArray:@[_arrowImage,_rightLabel,_leftLabel] bottomMargin:15];
    
}
- (void)setOwnerResidence:(OwnerResidence *)ownerResidence {
    _ownerResidence = ownerResidence;
    
    _leftLabel.text = [NSString stringWithFormat:@"%@ %@",ownerResidence.communityname,ownerResidence.name];
    if (_type == 0) {
        _rightLabel.text = @"未授权";
        _rightLabel.textColor = kNewRedColor;
    }else {
        _rightLabel.text = @"已共享";
        _rightLabel.textColor = BLUE_TEXT_COLOR;
    }

    
}


@end
