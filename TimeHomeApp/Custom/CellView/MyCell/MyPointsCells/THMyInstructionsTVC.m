//
//  THMyInstructionsTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyInstructionsTVC.h"

@interface THMyInstructionsTVC ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation THMyInstructionsTVC


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = DEFAULT_FONT(14);
    _contentLabel.textColor = TITLE_TEXT_COLOR;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLabel];
    _contentLabel.sd_layout.leftSpaceToView(self.contentView,WidthSpace(40)).topSpaceToView(self.contentView,WidthSpace(40)).rightSpaceToView(self.contentView,WidthSpace(40)).autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:WidthSpace(40)];
    
}
- (void)setModel:(LXModel *)model {
    
    _model = model;

    _contentLabel.text = model.content   ;
    
}

@end
