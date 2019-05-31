//
//  CJW_NewsTagCell.h
//  TimeHomeApp
//
//  Created by cjw on 2018/1/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJW_NewsTagCell : UICollectionViewCell
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *label;
@end
