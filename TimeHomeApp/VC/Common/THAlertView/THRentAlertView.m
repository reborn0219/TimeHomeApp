//
//  THRentAlertView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THRentAlertView.h"
#import "THInputView.h"

#import "MMDateView.h"
#import "MMPopupWindow.h"

@implementation THRentAlertView
#pragma mark - 单例初始化
+(instancetype)shareRentAlert
{
    static THRentAlertView * shareRentAlert = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareRentAlert = [[self alloc] init];
        
    });
    return shareRentAlert;
}
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeCustomStyle1;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:confirmButton];
        [confirmButton setTitle:@"确  定" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = DEFAULT_BOLDFONT(15);
        confirmButton.backgroundColor = kNewRedColor;
        confirmButton.tag = 1;
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(self).offset(-HeightSpace(32));
            make.width.equalTo(@(WidthSpace(408)));
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@(HeightSpace(54)));
            
        }];
        [confirmButton addTarget:self action:@selector(actionHide:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"续  租";
        titleLabel.textColor = TITLE_TEXT_COLOR;
        titleLabel.font = DEFAULT_BOLDFONT(18);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@(HeightSpace(46)));
            
        }];
        
        UIImageView *LeftImageView = [[UIImageView alloc]init];
        LeftImageView.image = [UIImage imageNamed:@"我的_设置_车位权限_续租弹窗"];
        [self addSubview:LeftImageView];
        [LeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.right.equalTo(titleLabel.mas_left).offset(-WidthSpace(28));
            make.width.equalTo(@(WidthSpace(46)));
            make.height.equalTo(@(WidthSpace(46)));
        }];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:cancelButton];
        cancelButton.tag = 2;
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"我的_设置_车位权限_关闭弹窗"] forState:UIControlStateNormal];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).offset(WidthSpace(14));
            make.right.equalTo(self).offset(-WidthSpace(14));
            make.width.equalTo(@(WidthSpace(44)));
            make.height.equalTo(@(WidthSpace(44)));
            
        }];
        [cancelButton addTarget:self action:@selector(actionHide:) forControlEvents:UIControlEventTouchUpInside];
        
        for (int i = 0; i < 2; i ++) {
            
            THInputView *thInputView = [[THInputView alloc] init];
            thInputView.tag = i+2016324;
            thInputView.dateSelectButton.tag = i + 2016907;
            [thInputView.dateSelectButton addTarget:self action:@selector(dateSelectClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:thInputView];
            if (i == 0) {
                thInputView.leftTitleLabel.text = @"开始日期";

                [thInputView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(WidthSpace(42));
                    make.top.equalTo(titleLabel.mas_bottom).offset(HeightSpace(40));
                    make.right.equalTo(self).offset(-WidthSpace(42));
                    make.height.equalTo(@35);
                }];
            }else {
                thInputView.leftTitleLabel.text = @"结束日期";

                THInputView *thInputView1 = [self viewWithTag:2016324];
                [thInputView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(WidthSpace(42));
                    make.top.equalTo(thInputView1.mas_bottom).offset(HeightSpace(30));
                    make.right.equalTo(self).offset(-WidthSpace(42));
                    make.height.equalTo(@35);
                }];
                
            }
        
        }
        
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = LINE_COLOR;
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(@1);
            make.bottom.equalTo(confirmButton.mas_top).offset(-HeightSpace(40));
            
        }];
        
    }
    
    return self;
}
/**
 *  时间选择按钮
 *
 *  @param button
 */
- (void)dateSelectClick:(UIButton *)button {
    
    if (self.dateButtonClickCallBack) {
        self.dateButtonClickCallBack(_beginDateString,button.tag - 2016907);
    }
    
}

- (void)setBeginDateString:(NSString *)beginDateString {
    _beginDateString = beginDateString;
    
    THInputView *thInputView = [self viewWithTag:2016324];
    thInputView.buttonTitleLabel.text = beginDateString;

}

- (void)setEndDateString:(NSString *)endDateString {
    _endDateString = endDateString;
    
    THInputView *thInputView = [self viewWithTag:2016325];
    thInputView.buttonTitleLabel.text = endDateString;
    
}


- (void)actionHide:(UIButton *)button
{
    
    
//    if (button.tag == 1) {
//        //确定
        if (self.confirmButtonClickCallBack) {
            self.confirmButtonClickCallBack(button.tag,_beginDateString,_endDateString);
        }
        
//    }
//    if (button.tag == 2) {
        //取消
//        [self hide];
//    }
    
}


@end
