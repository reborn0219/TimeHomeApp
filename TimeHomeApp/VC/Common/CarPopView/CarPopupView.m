//
//  CarPopupView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/8/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarPopupView.h"
#import "MMPopupItem.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import "MMPopupWindow.h"

@interface CarPopupView ()

{
    UIView *topBgView;                  //上方view
    UILabel *faultDescribe_Label;       //故障描述内容
    UITextView *details_TextView;       //详情内容
    UILabel *leftFaultNum_Label;        //故障码标题
    UILabel *faultNum_Label;            //故障码内容
    UILabel *leftFaultDescribe_Label;   //故障描述标题
    UILabel *leftDetail_Label;          //详情标题
    UIView *lineView;                   //线
}

@end

@implementation CarPopupView

#pragma mark - 单例初始化
+ (instancetype)sharedCarPopupView {
    
    static CarPopupView * sharePopupView = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharePopupView = [[self alloc] init];
    });
    return sharePopupView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //----------提示框的默认按钮设置---------------------
        [[MMPopupWindow sharedWindow] cacheWindow];
        [MMPopupWindow sharedWindow].touchWildToHide = NO;
        
        self.type = MMPopupTypeFullScreen;
                
        self.backgroundColor = [UIColor whiteColor];

        /**
         *  关闭按钮
         */
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];

        [closeButton setTitle:@"关  闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        closeButton.titleLabel.font = DEFAULT_BOLDFONT(WidthSpace(30));
        [closeButton setImage:[UIImage imageNamed:@"汽车管家-弹窗-关闭图标"] forState:UIControlStateNormal];
        
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@WidthSpace(108));
            make.bottom.equalTo(self);
        }];
        //--------------------------------
        
        /** 线  */
        lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        lineView.backgroundColor = LINE_COLOR;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self).offset(WidthSpace(50));
            make.right.equalTo(self).offset(-WidthSpace(50));
            make.height.equalTo(@1);
            make.bottom.equalTo(closeButton.mas_top);
        }];
        //--------------------------------

        /** 上方view */
        topBgView = [[UIView alloc] init];
        [self addSubview:topBgView];
        topBgView.backgroundColor = PURPLE_COLOR;
        [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@WidthSpace(238));
            
        }];
        //--------------------------------

        /** 故障码标题 */
        leftFaultNum_Label = [[UILabel alloc] init];
        [topBgView addSubview:leftFaultNum_Label];
        leftFaultNum_Label.text = @"故障码 : ";
        leftFaultNum_Label.textColor = [UIColor whiteColor];
        if (SCREEN_WIDTH == 320) {
            leftFaultNum_Label.font = DEFAULT_BOLDFONT(14);
        }else {
            leftFaultNum_Label.font = DEFAULT_BOLDFONT(16);
        }
        [leftFaultNum_Label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(topBgView).offset(WidthSpace(58));
            make.top.equalTo(topBgView).offset(WidthSpace(60));
            
        }];
        //--------------------------------
        
        /** 故障描述标题 */
        leftFaultDescribe_Label = [[UILabel alloc] init];
        [topBgView addSubview:leftFaultDescribe_Label];
        leftFaultDescribe_Label.text = @"描   述 : ";
        leftFaultDescribe_Label.textColor = [UIColor whiteColor];
        if (SCREEN_WIDTH == 320) {
            leftFaultDescribe_Label.font = DEFAULT_BOLDFONT(14);
        }else {
            leftFaultDescribe_Label.font = DEFAULT_BOLDFONT(16);

        }
        [leftFaultDescribe_Label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(topBgView).offset(WidthSpace(58));
            make.top.equalTo(leftFaultNum_Label.mas_bottom).offset(WidthSpace(38));
            
        }];
        //--------------------------------

        /** 故障码内容 */
        faultNum_Label = [[UILabel alloc] init];
        [topBgView addSubview:faultNum_Label];
        faultNum_Label.textColor = [UIColor whiteColor];
        if (SCREEN_WIDTH == 320) {
            faultNum_Label.font = DEFAULT_FONT(13);
        }else {
            faultNum_Label.font = DEFAULT_FONT(15);
        }
        faultNum_Label.sd_layout.leftSpaceToView(leftFaultNum_Label,12).centerYEqualToView(leftFaultNum_Label).heightIs(WidthSpace(34));
        
        //--------------------------------

        /** 故障描述内容 */
        faultDescribe_Label = [[UILabel alloc] init];
        [topBgView addSubview:faultDescribe_Label];

        faultDescribe_Label.textColor = [UIColor whiteColor];
        
        if (SCREEN_WIDTH == 320) {
            faultDescribe_Label.font = DEFAULT_FONT(13);
        }else {
            faultDescribe_Label.font = DEFAULT_FONT(15);
        }
        faultDescribe_Label.numberOfLines = 0;
        faultDescribe_Label.sd_layout.leftEqualToView(faultNum_Label).topEqualToView(leftFaultDescribe_Label).rightSpaceToView(topBgView,20).autoHeightRatio(0);
        
        [topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(faultDescribe_Label.mas_bottom).offset(20);
            
        }];
        //--------------------------------
        
        /** 详情标题 */
        leftDetail_Label = [[UILabel alloc] init];
        [self addSubview:leftDetail_Label];
        leftDetail_Label.text = @"详   情 : ";
        leftDetail_Label.textColor = PURPLE_COLOR;
        
        if (SCREEN_WIDTH == 320) {
            leftDetail_Label.font = DEFAULT_BOLDFONT(14);
        }else {
            leftDetail_Label.font = DEFAULT_BOLDFONT(16);
        }
        
        [leftDetail_Label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(topBgView).offset(WidthSpace(58));
            make.top.equalTo(topBgView.mas_bottom).offset(WidthSpace(36));
            
        }];
        //--------------------------------

        /** 详情内容 */
        details_TextView = [[UITextView alloc] init];
        [self addSubview:details_TextView];

        details_TextView.textColor = TITLE_TEXT_COLOR;
        
        if (SCREEN_WIDTH == 320) {
            details_TextView.font = DEFAULT_FONT(14);
        }else {
            details_TextView.font = DEFAULT_FONT(16);

        }
        
        details_TextView.editable = NO;
        details_TextView.scrollsToTop = YES;
        details_TextView.clipsToBounds = YES;
        details_TextView.showsVerticalScrollIndicator = NO;
        [details_TextView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self).offset(-5);
            make.left.equalTo(leftDetail_Label.mas_right).offset(10);
            make.top.equalTo(leftDetail_Label.mas_top).offset(-5);
            make.bottom.equalTo(lineView.mas_top).offset(-10);
            
        }];
        //--------------------------------

        
    }
    return self;
}

- (void)setHiddenFaultCode:(BOOL)hiddenFaultCode {
    
    _hiddenFaultCode = hiddenFaultCode;
    
    if (hiddenFaultCode) {
        leftFaultNum_Label.hidden = YES;
        faultNum_Label.hidden = YES;
    
        [leftFaultDescribe_Label mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(topBgView).offset(WidthSpace(58));
            make.top.equalTo(topBgView).offset(WidthSpace(60));
            
        }];
        
        faultDescribe_Label.sd_resetLayout.leftSpaceToView(leftFaultDescribe_Label,12).topEqualToView(leftFaultDescribe_Label).rightSpaceToView(topBgView,20).autoHeightRatio(0);
        
        [topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(faultDescribe_Label.mas_bottom).offset(20);
            
        }];
        
        [leftDetail_Label mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(topBgView).offset(WidthSpace(58));
            make.top.equalTo(topBgView.mas_bottom).offset(WidthSpace(36));
            
        }];
        [details_TextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self).offset(-5);
            make.left.equalTo(leftDetail_Label.mas_right).offset(10);
            make.top.equalTo(leftDetail_Label.mas_top).offset(-5);
            make.bottom.equalTo(lineView.mas_top).offset(-10);
            
        }];
        
        
    }else {
        leftFaultNum_Label.hidden = NO;
        faultNum_Label.hidden = NO;
    }
    
}

- (void)setFaultNum:(NSString *)faultNum {
    _faultNum = faultNum;
    
    faultNum_Label.text = faultNum;
}

- (void)setFaultDescribe:(NSString *)faultDescribe {
    _faultDescribe = faultDescribe;
    
    faultDescribe_Label.text = faultDescribe;
}

- (void)setDetails:(NSString *)details {
    _details = details;
    
    details_TextView.text = details;
}

- (void)hide {
    
    [super hide];
    
}

@end
