//
//  ZSY_tableViewSectionView.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSY_tableViewSectionView : UITableViewHeaderFooterView

@property (nonatomic, strong)UILabel *title;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, copy) NSString *text;//文字属性
@end
