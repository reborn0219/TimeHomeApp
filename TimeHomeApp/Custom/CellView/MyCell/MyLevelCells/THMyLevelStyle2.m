//
//  THMyLevelStyle2.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyLevelStyle2.h"

@interface THMyLevelStyle2 ()
/**
 *  距离升级还差的天数label
 */
@property (nonatomic, strong) UILabel *levelDaysLabel;
/**
 *  进度条(背景)
 */
@property (nonatomic, strong) UIView *backgroundLevelView;
/**
 *  进度条
 */
@property (nonatomic, strong) UIView *foreLevelView;
/**
 *  前一个等级
 */
@property (nonatomic, strong) UILabel *leveL1abel;
/**
 *  后一个等级
 */
@property (nonatomic, strong) UILabel *leveL2abel;
/**
 *  红点
 */
@property (nonatomic, strong) UIView *dotView;
@end

@implementation THMyLevelStyle2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = kNewRedColor;
    [self.contentView addSubview:leftLine];
    leftLine.sd_layout.leftSpaceToView(self.contentView,WidthSpace(54)).topSpaceToView(self.contentView,WidthSpace(82)).widthIs(1).heightIs(WidthSpace(48));
    
    UIImageView *leftLevelImage = [[UIImageView alloc]init];
    leftLevelImage.image = [UIImage imageNamed:@"用户等级_lv_小"];
    [self.contentView addSubview:leftLevelImage];
    leftLevelImage.sd_layout.centerXEqualToView(leftLine).topSpaceToView(leftLine,WidthSpace(20)).widthIs(WidthSpace(36)).heightIs(WidthSpace(20));
    
    _leveL1abel = [[UILabel alloc]init];
    _leveL1abel.font = DEFAULT_FONT(10);
    _leveL1abel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_leveL1abel];
    _leveL1abel.sd_layout.leftSpaceToView(leftLevelImage,1).bottomEqualToView(leftLevelImage).heightRatioToView(leftLevelImage,0.7).widthIs(12);
    
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = kNewRedColor;
    [self.contentView addSubview:rightLine];
    rightLine.sd_layout.rightSpaceToView(self.contentView,WidthSpace(54)).topSpaceToView(self.contentView,WidthSpace(82)).widthIs(1).heightIs(WidthSpace(48));
    
    UIImageView *rightLevelImage = [[UIImageView alloc]init];
    rightLevelImage.image = [UIImage imageNamed:@"用户等级_lv_小"];
    [self.contentView addSubview:rightLevelImage];
    rightLevelImage.sd_layout.centerXEqualToView(rightLine).topSpaceToView(rightLine,WidthSpace(20)).widthIs(WidthSpace(36)).heightIs(WidthSpace(20));
    
    _leveL2abel = [[UILabel alloc]init];
    _leveL2abel.font = DEFAULT_FONT(10);
    _leveL2abel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_leveL2abel];
    _leveL2abel.sd_layout.leftSpaceToView(rightLevelImage,1).bottomEqualToView(rightLevelImage).heightRatioToView(rightLevelImage,0.7).widthIs(12);
    
    _backgroundLevelView = [[UIView alloc]init];
    _backgroundLevelView.layer.borderColor = LINE_COLOR.CGColor;
    _backgroundLevelView.layer.borderWidth = 1;
    _backgroundLevelView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backgroundLevelView];
    _backgroundLevelView.sd_layout.leftSpaceToView(leftLine,WidthSpace(10)).rightSpaceToView(rightLine,WidthSpace(10)).heightIs(WidthSpace(20)).centerYEqualToView(leftLine);
    
    _foreLevelView = [[UIView alloc]init];
    _foreLevelView.backgroundColor = kNewRedColor;
    [_backgroundLevelView addSubview:_foreLevelView];
    
    _dotView = [[UIView alloc]init];
    _dotView.backgroundColor = kNewRedColor;
    [_backgroundLevelView addSubview:_dotView];
    
    _levelDaysLabel = [[UILabel alloc]init];
    _levelDaysLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_levelDaysLabel];
    _levelDaysLabel.sd_layout.leftSpaceToView(_leveL1abel,2).rightSpaceToView(rightLevelImage,2).heightIs(20).centerYEqualToView(leftLevelImage);
    
    [self setupAutoHeightWithBottomView:_levelDaysLabel bottomMargin:WidthSpace(95)];
    
}
- (void)setModel:(UserData *)model {
    
    _model = model;
    
    if (![XYString isBlankString:model.level]) {
        _leveL1abel.text = model.level;
        _leveL2abel.text = [NSString stringWithFormat:@"%d",[model.level intValue]+1];
        
        if (![XYString isBlankString:model.activedays]) {
            NSInteger days = model.activedays.intValue - model.leveldays.intValue;
            float radio = [[NSString stringWithFormat:@"%ld",(long)days] floatValue]/(days + model.upgradedays.integerValue)*1.0;

            _foreLevelView.sd_resetLayout.leftSpaceToView(_backgroundLevelView,0).topSpaceToView(_backgroundLevelView,0).bottomSpaceToView(_backgroundLevelView,0).widthRatioToView(_backgroundLevelView,radio);
            _dotView.sd_resetLayout.widthIs(WidthSpace(10)).heightEqualToWidth().bottomSpaceToView(_backgroundLevelView,WidthSpace(24)).leftSpaceToView(_foreLevelView,-WidthSpace(10)/2);
            _dotView.sd_cornerRadiusFromWidthRatio = @(0.5);
        }
        
    }

    if (![XYString isBlankString:model.upgradedays]) {
        NSString *string = [NSString stringWithFormat:@"距离升级还差%@天",model.upgradedays];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
        [attributeString addAttribute:NSFontAttributeName value:DEFAULT_FONT(14) range:NSMakeRange(0, string.length)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR range:NSMakeRange(0, 6)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:kNewRedColor range:NSMakeRange(6, string.length-7)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR range:NSMakeRange(string.length-1, 1)];
        _levelDaysLabel.attributedText = attributeString;
    }

}

@end
