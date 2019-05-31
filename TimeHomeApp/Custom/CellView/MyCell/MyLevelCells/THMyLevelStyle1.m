//
//  THMyLevelStyle1.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyLevelStyle1.h"

@interface THMyLevelStyle1 ()
/**
 *  头像
 */
@property (nonatomic ,strong) UIImageView *headImageView;
/**
 *  名字
 */
@property (nonatomic ,strong) UILabel *nameLabel;
/**
 *  活跃天数
 */
@property (nonatomic ,strong) UILabel *activeDayLabel;
/**
 *  等级
 */
@property (nonatomic ,strong) UILabel *levelLabel;

@end

@implementation THMyLevelStyle1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _headImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(self.contentView,30).topSpaceToView(self.contentView,20).widthIs(60).heightEqualToWidth();
    _headImageView.sd_cornerRadiusFromWidthRatio = @(0.5);

    UIImageView *levelImageView = [[UIImageView alloc]init];
    levelImageView.image = [UIImage imageNamed:@"用户等级_lv_大"];
    [self.contentView addSubview:levelImageView];
    levelImageView.sd_layout.rightSpaceToView(self.contentView,WidthSpace(44)).centerYEqualToView(self.contentView).widthIs(WidthSpace(48)).heightIs(WidthSpace(24));
    
    _levelLabel = [[UILabel alloc]init];
    _levelLabel.font = DEFAULT_BOLDFONT(10);
    _levelLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_levelLabel];
    _levelLabel.sd_layout.leftSpaceToView(levelImageView,1).bottomEqualToView(levelImageView).widthIs(6).heightRatioToView(levelImageView,0.7);
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kNewRedColor;
    [self.contentView addSubview:line];
    line.sd_layout.rightSpaceToView(levelImageView,WidthSpace(20)).centerYEqualToView(levelImageView).widthIs(2).heightIs(WidthSpace(24)+6);
    line.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = DEFAULT_BOLDFONT(16);
    _nameLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_headImageView,15).topEqualToView(_headImageView).rightSpaceToView(line,5).autoHeightRatio(0);
    
    _activeDayLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_activeDayLabel];
    _activeDayLabel.sd_layout.leftEqualToView(_nameLabel).bottomEqualToView(_headImageView).widthIs(150).heightIs(20);
    
    [self setupAutoHeightWithBottomView:_headImageView bottomMargin:20];
    
}
- (void)setModel:(UserData *)model {
    _model = model;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:kHeaderPlaceHolder];
    if (![XYString isBlankString:model.nickname]) {
        _nameLabel.text = model.nickname;
    }
    if (![XYString isBlankString:model.activedays]) {
        NSString *string = [NSString stringWithFormat:@"活跃天数：%@",model.activedays];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
        [attributeString addAttribute:NSFontAttributeName value:DEFAULT_FONT(14) range:NSMakeRange(0, string.length)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR range:NSMakeRange(0, 5)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(5, string.length-5)];
        _activeDayLabel.attributedText = attributeString;
    }
    if (![XYString isBlankString:model.level]) {
        _levelLabel.text = model.level;
    }
    
    
}


@end
