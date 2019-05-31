//
//  ZSY_HelpHeaderView.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSY_HelpHeaderView : UITableViewHeaderFooterView

///联系客服
@property (nonatomic, strong)UILabel *numberLabelChinese;
@property (nonatomic, strong)UILabel *numberLabelNumeral;

///工作时间
@property (nonatomic, strong)UILabel *timeLabelChinese;
@property (nonatomic, strong)UILabel *timeLabelnamberLabelNumeral;
@property (nonatomic, strong)UILabel *timeLabelMark;

///拨号按钮
@property (nonatomic, strong)UIButton *dialingButton;
+(instancetype)ZSY_HelpHeaderView;
@end
