//
//  THPicHomeGridView.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  自定义可拖拽重排的view
 */
#import <UIKit/UIKit.h>

#import "THHomeGridViewListItemView.h"
@class THPicHomeGridView;

@protocol THPicHomeGridViewDelegate <NSObject>

@optional
/**
 *  按钮点击方法
 *
 *  @param gridView
 *  @param index    索引
 */
- (void)homeGrideView:(THPicHomeGridView *)gridView selectItemAtIndex:(NSInteger)index;
/**
 *  最后加号按钮点击的方法
 *
 *  @param gridView
 */
- (void)homeGrideViewmoreItemButtonClicked:(THPicHomeGridView *)gridView;
/**
 *  重排完之后调用的方法
 *
 *  @param gridView
 */
- (void)homeGrideViewDidChangeItems:(THPicHomeGridView *)gridView;

@end

@interface THPicHomeGridView : UIScrollView <UIScrollViewDelegate>
/**
 *  代理
 */
@property (nonatomic, weak) id<THPicHomeGridViewDelegate> gridViewDelegate;

/**
 *  所有视图的集合数组
 */
@property (nonatomic, strong) NSMutableArray *itemsArray;
/**
 *  传入排列的model类
 */
- (void)setUpGridModelsArray:(NSArray *)gridModelsArray complete:(void(^)(id data))completion;

@end
