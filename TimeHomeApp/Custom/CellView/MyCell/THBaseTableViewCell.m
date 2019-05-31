//
//  THBaseTableViewCell.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THBaseTableViewCell.h"

@interface THBaseTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation THBaseTableViewCell


- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 7;
    frame.size.width -= 14;
    [super setFrame:frame];
    
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
    }
    return _headImageView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _baseTableViewCellStyle = BaseTableViewCellStyleDefault;
        [self setUp];
        
    }
    return self;
}

- (void)configureIndexpath:(NSIndexPath *)indexpath headImageUrl:(NSString *)imageString headImage:(UIImage *)headImage {
    if (indexpath.section == 0 && indexpath.row == 0) {
        [self.contentView addSubview:self.headImageView];
        _headImageView.clipsToBounds = YES;

        if (headImage) {
            _headImageView.image = headImage;
        }else {
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:kHeaderPlaceHolder];
        }
        _headImageView.sd_layout.widthIs(WidthSpace(56)).heightIs(WidthSpace(56)).centerYEqualToView(self.contentView).rightEqualToView(self.rightLabel);
        _headImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    }
}

- (void)setUp {
    
    _leftLabel = [[UILabel alloc]init];
    _leftLabel.textColor = TITLE_TEXT_COLOR;
    _leftLabel.font = DEFAULT_FONT(16);
    [self.contentView addSubview:_leftLabel];

    
    _arrowImage= [[UIImageView alloc]init];
    _arrowImage.hidden = YES;
    _arrowImage.image = [UIImage imageNamed:@"我的_右箭头"];
    [self.contentView addSubview:_arrowImage];
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    _rightLabel = [[UILabel alloc]init];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.textColor = TEXT_COLOR;
    _rightLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_arrowImage).offset(-20);
        make.width.equalTo(@200);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];

    _leftImageView = [[UIImageView alloc]init];
    _leftImageView.hidden = YES;
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    _infoImage = [[UIImageView alloc]init];
    _infoImage.image = [UIImage imageNamed:@"消息提示"];
    [self.contentView addSubview:_infoImage];
    _infoImage.hidden = YES;
    
}
- (void)setBaseTableViewCellStyle:(BaseTableViewCellStyle)baseTableViewCellStyle {
    
    _baseTableViewCellStyle = baseTableViewCellStyle;
    
    switch (baseTableViewCellStyle) {
        case BaseTableViewCellStyleDefault:
        {
            _arrowImage.hidden = NO;

            [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                make.width.equalTo(@80);
            }];
            [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_arrowImage).offset(-20);
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                make.left.equalTo(_leftLabel.mas_right).offset(15);
            }];
        }
            break;
        case BaseTableViewCellStyleValue1:
        {
            [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                make.width.equalTo(@80);
            }];
            [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-20);
                make.left.equalTo(_leftLabel.mas_right).offset(30);
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
            }];
            _rightLabel.textAlignment = NSTextAlignmentLeft;
            _arrowImage.hidden = YES;
        }
            break;
        case BaseTableViewCellStyleValue2:
        {
            [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                make.width.equalTo(@80);
            }];
            _rightLabel.hidden = YES;
            _arrowImage.hidden = YES;
        }
            break;
        case BaseTableViewCellStyleImageValue1:
        {
            _rightLabel.hidden = YES;
            _arrowImage.hidden = NO;
            _leftImageView.hidden = NO;
            _leftImageView.sd_layout.leftSpaceToView(self.contentView,WidthSpace(58)).centerYEqualToView(self.contentView).widthIs(WidthSpace(34)).heightEqualToWidth();
            _leftLabel.sd_layout.leftSpaceToView(_leftImageView,WidthSpace(30.f)).rightSpaceToView(_arrowImage,1).centerYEqualToView(self.contentView).heightIs(50);
        }
            break;
        case BaseTableViewCellStyleValue3:
        {
            _rightLabel.hidden = YES;
            _arrowImage.hidden = NO;
            _leftImageView.hidden = YES;
            _leftLabel.hidden = NO;
            _leftLabel.sd_layout.leftSpaceToView(self.contentView,15).rightSpaceToView(_arrowImage,5).centerYEqualToView(self.contentView).heightIs(20);
            _infoImage.sd_layout.rightSpaceToView(_arrowImage,5).centerYEqualToView(_arrowImage).widthIs(5).heightEqualToWidth();

        }
            break;
        case BaseTableViewCellStyleValue4:
        {
            _leftImageView.hidden = NO;
//            _leftImageView.sd_layout.leftSpaceToView(self.contentView,8).centerYEqualToView(self.contentView).widthIs(10).heightEqualToWidth();
            _arrowImage.hidden = NO;
            
            [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.contentView).offset(8);
                make.width.equalTo(@10);
                make.height.equalTo(@10);
                
            }];
            
            [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(26);
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                make.width.equalTo(@80);
            }];
            [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_arrowImage).offset(-20);
                //                make.width.equalTo(@200);
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                make.left.equalTo(_leftLabel.mas_right).offset(15);
            }];
        }
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
