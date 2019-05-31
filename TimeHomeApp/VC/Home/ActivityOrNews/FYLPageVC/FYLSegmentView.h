
//
//  FYLSegmentView.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/1/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FYLColorFromHexadecimalRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kMaskWidth 64 //指示视图的宽度

@class FYLSegmentView;

@protocol FYLSegmentViewDelegate <NSObject>

///点击标签回调
- (void)FYLSegmentView:(FYLSegmentView *)segmentView didClickTagAtIndex:(NSInteger)index;
- (void)FYLSegmentViewAddBtnClick;
@end

@interface FYLSegmentView : UIView

@property(nonatomic,weak)id<FYLSegmentViewDelegate> delegate;
@property(nonatomic,strong)NSArray *titles;

///初始化方法
- (FYLSegmentView *)initWithTitles:(NSArray *)titles;

///设置指示下标位置方法
- (void)setOffsetOfIndexView:(CGFloat)offsetX withCurrentIndex:(NSInteger)index;
-(void)setupUI;
@end
