//
//  THInPutTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THInPutTVC.h"

@interface THInPutTVC () <UITextFieldDelegate>

//@property (nonatomic, strong) UIButton *dateSelectButton;
@property (nonatomic, strong) UIView *borderView;

@end

@implementation THInPutTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _leftTitleLabel = [[UILabel alloc]init];
    _leftTitleLabel.textColor = TITLE_TEXT_COLOR;
    _leftTitleLabel.font = DEFAULT_FONT(16);
    [self.contentView addSubview:_leftTitleLabel];

    
    _rightButton = [THAuthoritySelectButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rightButton];
    _rightButton.leftLabel.font = DEFAULT_FONT(12);
    _rightButton.leftLabel.textColor = TEXT_COLOR;
    _rightButton.leftLabel.text = @"通讯录";
    _rightButton.leftImageView.image = [UIImage imageNamed:@"设置_房产权限_房产授权_通讯录"];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(90));
        make.height.equalTo(@35);
        
    }];
    [_rightButton addTarget:self action:@selector(rigthButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kNewRedColor;
    [_rightButton addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@2);
        make.height.equalTo(@20);
        make.centerY.equalTo(_rightButton.mas_centerY);
        make.right.equalTo(_rightButton);
    }];
    
    _borderView = [[UIView alloc]init];
    [self addSubview:_borderView];
    _borderView.layer.borderColor = LINE_COLOR.CGColor;
    _borderView.layer.borderWidth = 1.f;
    [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTitleLabel.mas_right).offset(5);
        make.right.equalTo(_rightButton.mas_left).offset(0);
        make.height.equalTo(@35);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    _phoneTF = [[CustomTextFIeld alloc]init];
    _phoneTF.delegate = self;
    _phoneTF.hidden = YES;
    _phoneTF.font = DEFAULT_FONT(16);
    _phoneTF.enablesReturnKeyAutomatically = YES;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_borderView addSubview:_phoneTF];
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_borderView).offset(10.f);
        make.right.equalTo(_borderView).offset(-10);
        make.top.equalTo(_borderView);
        make.bottom.equalTo(_borderView);
    }];

    _dateSelectButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _dateSelectButton.hidden = YES;
    _dateSelectButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_dateSelectButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    _dateSelectButton.titleLabel.font = DEFAULT_FONT(14);
    [_borderView addSubview:_dateSelectButton];
    [_dateSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_borderView);
        make.right.equalTo(_borderView);
        make.top.equalTo(_borderView);
        make.bottom.equalTo(_borderView);
    }];
    
    _buttonTitleLabel = [[UILabel alloc]init];
    _buttonTitleLabel.font = DEFAULT_FONT(14);
    _buttonTitleLabel.textColor = TEXT_COLOR;
    [_dateSelectButton addSubview:_buttonTitleLabel];
    [_buttonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dateSelectButton).offset(15);
        make.right.equalTo(_dateSelectButton);
        make.top.equalTo(_dateSelectButton);
        make.bottom.equalTo(_dateSelectButton);
    }];
    
    [_dateSelectButton addTarget:self action:@selector(dateSelectedClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setRightViewLength:(RightViewLength)rightViewLength {
    
    _rightViewLength = rightViewLength;
    
    switch (rightViewLength) {
        case RightViewLengthDefault:
        {
            [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(10);
                make.width.equalTo(@(80));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
            break;
        case RightViewLengthLongToCellBorder:
        {
            [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(20);
                make.width.equalTo(@(60));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
            [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_leftTitleLabel.mas_right).offset(5);
                make.right.equalTo(self.contentView).offset(-15);
                make.height.equalTo(@35);
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
            _phoneTF.hidden = NO;
//            [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_borderView).offset(10.f);
//                make.right.equalTo(_borderView).offset(-10);
//                make.top.equalTo(_borderView);
//                make.bottom.equalTo(_borderView);
//            }];
            _rightButton.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)rigthButtonClick {
    if (self.peopleInfosCallBack) {
        self.peopleInfosCallBack();
    }
}

- (void)dateSelectedClick:(UIButton *)button {
    
    if (self.dateButtonClickCallBack) {
        self.dateButtonClickCallBack(button.selected);
    }
    
}
- (void)setViewType:(ViewType)viewType {
    
    _viewType = viewType;
    
    switch (viewType) {
        case ViewTypeTextField:
        {
            _phoneTF.hidden = NO;
            _dateSelectButton.hidden = YES;
        }
            break;
        case ViewTypeButton:
        {
            _phoneTF.hidden = YES;
            _dateSelectButton.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    
//    if (textField.text.length > _lengthLimited) {
//        textField.text = [textField.text substringToIndex:_lengthLimited];
//    }
//    if (self.textFieldCallBack) {
//        self.textFieldCallBack(textField.text);
//    }
//    
//}
@end
