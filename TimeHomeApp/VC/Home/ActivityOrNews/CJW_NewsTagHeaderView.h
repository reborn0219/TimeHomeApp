//
//  CJW_NewsTagHeaderView.h
//  TimeHomeApp
//
//  Created by cjw on 2018/1/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJW_NewsTagHeaderView : UICollectionReusableView
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *btnTitle;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UILabel *editLabel;
@end
