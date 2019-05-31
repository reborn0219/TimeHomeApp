//
//  THAuthorityTitleTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THAuthorityTitleTVC.h"

@implementation THAuthorityTitleTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _houseNameLabel = [[UILabel alloc]init];
    _houseNameLabel.font = DEFAULT_FONT(18);
    _houseNameLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_houseNameLabel];
    _houseNameLabel.textAlignment = NSTextAlignmentCenter;
    _houseNameLabel.sd_layout.leftEqualToView(self.contentView).topEqualToView(self.contentView).rightEqualToView(self.contentView).bottomEqualToView(self.contentView);
    
}

@end
