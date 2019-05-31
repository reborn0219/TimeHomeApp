//
//  SiginRulesVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/7/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SiginRulesVC.h"
#import "RaiN_NewSigninPresenter.h"
@interface SiginRulesVC ()

@property (nonatomic, copy) UITextView *textV;
@end

@implementation SiginRulesVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"签到抽奖规则";
    [self createView];
    [self netData];
}

//MARK: - 界面布局与网络请求
/**
 界面布局
 */
- (void)createView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, SCREEN_HEIGHT - (44+statuBar_Height) - 16)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    NSInteger imageHeight = 31.0;
    NSInteger imageWidth = 110.0/7*6;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, bgView.frame.size.width - 20, imageHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:topView];
    
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    topImage.image = [UIImage imageNamed:@"签到规则"];
    [topView addSubview:topImage];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, imageWidth - 10, imageHeight - 6)];
    topLabel.text = @"签到抽奖规则";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.font = DEFAULT_BOLDFONT(13);
    [topView addSubview:topLabel];
    
    
    _textV = [[UITextView alloc]initWithFrame:CGRectMake(10, 15 + 10 + imageHeight, bgView.frame.size.width-20, bgView.frame.size.height-(15 + 15 + imageHeight))];
    _textV.font = DEFAULT_FONT(12);
    _textV.textColor = TITLE_TEXT_COLOR;
    [bgView addSubview:_textV];
    
    
    _textV.editable = NO;
}


/**
 网络请求
 */
- (void)netData {
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self.tabBarController];
    [RaiN_NewSigninPresenter getSignruleWithupdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            
            if (resultCode == SucceedCode) {
                ///成功
                NSDictionary *dic = data[@"map"];
                NSString *textStr = dic[@"signrule"];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 10;// 字体的行间距
                NSDictionary *attributes = @{
                                             NSFontAttributeName:DEFAULT_FONT(14),
                                             NSForegroundColorAttributeName:TITLE_TEXT_COLOR,
                                             NSParagraphStyleAttributeName:paragraphStyle
                                             };
                selfWeak.textV.attributedText = [[NSAttributedString alloc] initWithString:textStr attributes:attributes];

            }else {
                ///失败
                [selfWeak showToastMsg:data[@"errmsg"] Duration:3.0f];
                
            }
        });
    }];
}

@end
