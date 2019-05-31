//
//  MineTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MineTVC.h"

@implementation MineTVC

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.x += 7;
//    frame.size.width -= 14;
//    [super setFrame:frame];
//    
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUp];
        
    }
    return self;
}
- (void)setUp {
    
    _leftImageView = [[UIImageView alloc]init];
    
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.textColor = TITLE_TEXT_COLOR;
    _titleLabel.font = DEFAULT_FONT(16);
    
    _accessoryImage = [[UIImageView alloc]init];
    _accessoryImage.image = [UIImage imageNamed:@"我的_右箭头"];
    
    [@[_leftImageView, _titleLabel, _accessoryImage] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.contentView addSubview:obj];
        
    }];
    
    _leftImageView.sd_layout.leftSpaceToView(self.contentView,WidthSpace(58)).centerYEqualToView(self.contentView).widthIs(WidthSpace(34)).heightEqualToWidth();
    _titleLabel.sd_layout.leftSpaceToView(_leftImageView,WidthSpace(30.f)).centerYEqualToView(self.contentView).heightIs(20).widthIs(150);
    _accessoryImage.sd_layout.rightSpaceToView(self.contentView,WidthSpace(53)).centerYEqualToView(self.contentView).heightIs(14).widthIs(14);
    
    _infoImage = [[UIImageView alloc]init];
    _infoImage.image = [UIImage imageNamed:@"消息提示"];
    [self.contentView addSubview:_infoImage];
    _infoImage.hidden = YES;
    _infoImage.sd_layout.rightSpaceToView(_accessoryImage,5).centerYEqualToView(_accessoryImage).widthIs(5).heightEqualToWidth();
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
