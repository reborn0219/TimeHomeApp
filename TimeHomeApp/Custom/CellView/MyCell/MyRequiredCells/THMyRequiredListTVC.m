//
//  THMyRequiredListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyRequiredListTVC.h"

@interface THMyRequiredListTVC ()
/**
 *  右边竖线
 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation THMyRequiredListTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _leftImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImageView];
    _leftImageView.sd_layout.leftSpaceToView(self.contentView,WidthSpace(24)).topSpaceToView(self.contentView,WidthSpace(34)).widthIs(WidthSpace(90)).heightEqualToWidth();
    
    _infoImage = [[UIImageView alloc]init];
    _infoImage.image = [UIImage imageNamed:@"消息提示"];
    [_leftImageView addSubview:_infoImage];
    _infoImage.hidden = YES;
    [_infoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftImageView.mas_centerX).offset(-WidthSpace(90)/2/1.414);
        make.centerY.equalTo(_leftImageView.mas_centerY).offset(-WidthSpace(90)/2/1.414);
        make.width.equalTo(@5);
        make.height.equalTo(@5);
    }];
    
    _lineView = [[UIView alloc]init];
    [self.contentView addSubview:_lineView];
    _lineView.sd_layout.rightSpaceToView(self.contentView,WidthSpace(16)).widthIs(4).heightIs(17).centerYEqualToView(self.contentView);
    _lineView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _rightDetailLabel = [[UILabel alloc]init];
//    _rightDetailLabel.backgroundColor = [UIColor redColor];
    _rightDetailLabel.font = DEFAULT_FONT(14);
    _rightDetailLabel.textColor = TITLE_TEXT_COLOR;
    _rightDetailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rightDetailLabel];
    _rightDetailLabel.sd_layout.rightSpaceToView(_lineView,WidthSpace(20)).centerYEqualToView(self.contentView).heightIs(20).widthIs(90);

    
    _topDetailLabel = [[UILabel alloc]init];
    _topDetailLabel.font = DEFAULT_FONT(15);
    _topDetailLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:_topDetailLabel];
    _topDetailLabel.sd_layout.leftSpaceToView(_leftImageView,WidthSpace(50)-5).topEqualToView(_leftImageView).heightIs(20).rightSpaceToView(_rightDetailLabel,5);
    
    _bottomTitleLabel = [[UILabel alloc]init];
    _bottomTitleLabel.font = DEFAULT_FONT(15);
    _bottomTitleLabel.textColor = TITLE_TEXT_COLOR;
    [self.contentView addSubview:_bottomTitleLabel];
    _bottomTitleLabel.sd_layout.leftEqualToView(_topDetailLabel).topSpaceToView(_topDetailLabel,5).rightEqualToView(_topDetailLabel).heightIs(20);
    
    /** 设置单行文本label宽度自适应 */
//    [_rightDetailLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    [self setupAutoHeightWithBottomViewsArray:@[_leftImageView,_bottomTitleLabel] bottomMargin:WidthSpace(40)];
    
}
- (void)setModel:(UserReserveInfo *)model {
    _model = model;
    
    NSString *dateString = [model.systime substringToIndex:16];
    
    _topDetailLabel.text = dateString;
    _bottomTitleLabel.text = model.typeName;
    
    if ([model.type intValue] == 0) {
        _leftImageView.image = [UIImage imageNamed:@"NEW家用"];
    }else {
        _leftImageView.image = [UIImage imageNamed:@"NEW公共"];
    }
//    model.state = @"3";
    if ([model.isok intValue] == 1) {
        
        switch ([model.state intValue]) {
            case -1:
            {
                _rightDetailLabel.text = @"已驳回";
                _lineView.backgroundColor = TEXT_COLOR;
            }
                break;
            case 0:
            {
                _rightDetailLabel.text = @"待分派物业";
                _lineView.backgroundColor = kNewRedColor;
            }
                break;
            case 1:
            {
                _rightDetailLabel.text = @"物业已接收";
                _lineView.backgroundColor = UIColorFromRGB(0x276DDC);
            }
                break;
            case 2:
            {
                _rightDetailLabel.text = @"处理中";
                _lineView.backgroundColor = UIColorFromRGB(0x276DDC);//蓝色
            }
                break;
            case 3:
            {
                _rightDetailLabel.text = @"已完成 待评价";
                _lineView.backgroundColor = UIColorFromRGB(0x7AC40F);//绿色
            }
                break;
            case 4:
            {
                _rightDetailLabel.text = @"已评价";
                _lineView.backgroundColor = UIColorFromRGB(0x7AC40F);
            }
                break;
            case -2:
            {
                _rightDetailLabel.text = @"暂不维修";
                _lineView.backgroundColor = TEXT_COLOR;
            }
                break;
            default:
                break;
        }
        
    }else {
        _rightDetailLabel.text = @"暂不维修";
        _lineView.backgroundColor = TEXT_COLOR;
    }

}


@end
