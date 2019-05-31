//
//  THCarAuthoriedTVC1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THCarAuthoriedTVC1.h"

@implementation THCarAuthoriedTVC1

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
    _rightLabel.backgroundColor = kNewRedColor;
    _rightLabel.textColor = [UIColor whiteColor];
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_rightLabel];
    
    _leftLabel = [[UILabel alloc]init];
    _leftLabel.textColor = TITLE_TEXT_COLOR;
    _leftLabel.font = DEFAULT_FONT(16);
    [self.contentView addSubview:_leftLabel];

    _rightLabel.sd_layout.heightIs(20).widthIs(70).topSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15);
    _rightLabel.sd_cornerRadiusFromHeightRatio = @(0.5);
    _leftLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).rightSpaceToView(_rightLabel,5).autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomViewsArray:@[_leftLabel,_rightLabel] bottomMargin:15];
    
}
- (void)setParkingOwner:(ParkingOwner *)parkingOwner {
    _parkingOwner = parkingOwner;
    
    _rightLabel.text = @"出租";
    
    NSString *string = @"";
    if (![XYString isBlankString:parkingOwner.communityname]) {
        string = [string stringByAppendingFormat:@"%@",parkingOwner.communityname];
    }
    if (![XYString isBlankString:parkingOwner.name]) {
        string = [string stringByAppendingFormat:@" %@",parkingOwner.name];
    }
    _leftLabel.text = string;

}

@end
