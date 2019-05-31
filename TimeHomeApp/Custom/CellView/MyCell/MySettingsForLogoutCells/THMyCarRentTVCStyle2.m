//
//  THMyCarRentTVCStyle2.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyCarRentTVCStyle2.h"

@interface THMyCarRentTVCStyle2 ()
/**
 *  内容
 */
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation THMyCarRentTVCStyle2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = DEFAULT_FONT(14);
        _contentLabel.textColor = TITLE_TEXT_COLOR;
        [self.contentView addSubview:_contentLabel];
        _contentLabel.sd_layout.leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:15];
        
    }
    return self;
}
- (void)setModel:(LXModel *)model {
    _model = model;
    
    _contentLabel.text = model.content;
}

@end
