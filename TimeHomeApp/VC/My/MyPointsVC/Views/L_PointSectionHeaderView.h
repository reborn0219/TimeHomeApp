//
//  L_PointSectionHeaderView.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SectionButtonDidTouchBlock)(NSInteger buttonIndex);
@interface L_PointSectionHeaderView : UIView

@property (nonatomic, copy) SectionButtonDidTouchBlock sectionButtonDidTouchBlock;

+ (L_PointSectionHeaderView *)getInstance;

@end
