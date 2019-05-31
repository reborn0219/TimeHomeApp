//
//  THCarAuthoriedDetailsTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THCarAuthoriedDetailsTVC.h"

@implementation THCarAuthoriedDetailsTVC

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
    _rightLabel.textColor = TEXT_COLOR;
    _rightLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_rightLabel];
    _rightLabel.sd_layout.rightSpaceToView(self.contentView,15+13+5).topSpaceToView(self.contentView,15).widthIs(80).heightIs(20);
    
    _rightImage= [[UIImageView alloc]init];
    _rightImage.image = [UIImage imageNamed:@"设置_房产权限_移除"];
    [self.contentView addSubview:_rightImage];
    _rightImage.sd_layout.rightSpaceToView(self.contentView,15).centerYEqualToView(_rightLabel).widthIs(13).heightEqualToWidth();
    
    _mobileLabel = [[UILabel alloc]init];
//    _mobileLabel.backgroundColor = [UIColor redColor];
    _mobileLabel.textColor = TITLE_TEXT_COLOR;
    _mobileLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_mobileLabel];
    _mobileLabel.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,13).widthIs(90).heightIs(20);
//    [_mobileLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = TITLE_TEXT_COLOR;
    _nameLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_mobileLabel,10).topSpaceToView(self.contentView,15).rightSpaceToView(_rightLabel,10).autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomViewsArray:@[_rightImage,_rightLabel,_mobileLabel,_nameLabel] bottomMargin:15];
    
//    _rightLabel.userInteractionEnabled = YES;
//    _mobileLabel.userInteractionEnabled = YES;
//    _nameLabel.userInteractionEnabled = YES;

}
- (void)setOwnerResidenceUser:(OwnerResidenceUser *)ownerResidenceUser {
    _ownerResidenceUser = ownerResidenceUser;
    
    _rightLabel.text = @"移  除";

    _mobileLabel.text = ownerResidenceUser.phone;
    _nameLabel.text   = ownerResidenceUser.name;

}

    

@end
