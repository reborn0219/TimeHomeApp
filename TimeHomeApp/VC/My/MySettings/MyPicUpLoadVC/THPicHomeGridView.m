//
//  THPicHomeGridView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THPicHomeGridView.h"


/**
 *  一行放的图片个数
 */
#define kHomeGridViewTopSectionRowCount 3

@implementation THPicHomeGridView
{
    /**
     *  视图个数
     */
    NSInteger itemCount;
    /**
     *  上一次长按的位置
     */
    CGPoint _lastPoint;
    /**
     *  空的按钮，用来占位
     */
    UIButton *_placeholderButton;
    /**
     *  每个小view
     */
    THHomeGridViewListItemView *_currentPressedView;
    /**
     *  加号按钮
     */
    UIButton *_moreItemButton;
    /**
     *  每个小view的frame
     */
    CGRect _currentPresssViewFrame;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        _itemsArray = [NSMutableArray array];
        _placeholderButton = [[UIButton alloc] init];
    }
    return self;
}
- (void)setUpGridModelsArray:(NSArray *)gridModelsArray complete:(void(^)(id data))completion {
    
//    _gridModelsArray = gridModelsArray;
    
    [_itemsArray removeAllObjects];
    
    [gridModelsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        THHomeGridViewListItemView *item = [[THHomeGridViewListItemView alloc] init];
        if (idx == 0) {
            item.headLabel.hidden = NO;
        }
        item.photoWall = obj;
        
        @WeakObj(self);
        item.itemLongPressedOperationBlock = ^(UILongPressGestureRecognizer *longPressed){
            [selfWeak buttonLongPressed:longPressed];
        };
        item.cancelButtonClickedOperationBlock = ^(THHomeGridViewListItemView *view){
            
            [selfWeak deleteView:view withIndex:idx];
        };
        item.buttonClickedOperationBlock = ^(THHomeGridViewListItemView *view){
            
            if ([self.gridViewDelegate respondsToSelector:@selector(homeGrideView:selectItemAtIndex:)]) {
                [self.gridViewDelegate homeGrideView:self selectItemAtIndex:[_itemsArray indexOfObject:view]];
            }
        };
        
        [self addSubview:item];
        [_itemsArray addObject:item];
    }];
    
    //这里是创建最后一个＋的按钮
    _moreItemButton = [[UIButton alloc] init];
    [_moreItemButton setImage:[UIImage imageNamed:@"个人设置_头像_上传照片_添加照片"] forState:UIControlStateNormal];
    [_moreItemButton addTarget:self action:@selector(moreItemButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreItemButton];
    _moreItemButton.backgroundColor = [UIColor whiteColor];
    [_itemsArray addObject:_moreItemButton];
    
    if (completion) {
        completion(self);
    }

}

#pragma mark - properties
/*
 *  暂时用scrollview实现
 */
//- (void)setGridModelsArray:(NSArray *)gridModelsArray
//{
//    _gridModelsArray = gridModelsArray;
//    
//    [_itemsArray removeAllObjects];
//    
//    [gridModelsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        THHomeGridViewListItemView *item = [[THHomeGridViewListItemView alloc] init];
//        if (idx == 0) {
//            item.headLabel.hidden = NO;
//        }
//        item.photoWall = obj;
//
//        @WeakObj(self);
//        item.itemLongPressedOperationBlock = ^(UILongPressGestureRecognizer *longPressed){
//            [selfWeak buttonLongPressed:longPressed];
//        };
//        item.cancelButtonClickedOperationBlock = ^(THHomeGridViewListItemView *view){
//            
//            [selfWeak deleteView:view withIndex:idx];
//        };
//        item.buttonClickedOperationBlock = ^(THHomeGridViewListItemView *view){
//
//            if ([self.gridViewDelegate respondsToSelector:@selector(homeGrideView:selectItemAtIndex:)]) {
//                [self.gridViewDelegate homeGrideView:self selectItemAtIndex:[_itemsArray indexOfObject:view]];
//            }
//        };
//        
//        [self addSubview:item];
//        [_itemsArray addObject:item];
//    }];
//    
//    //这里是创建最后一个＋的按钮
//    _moreItemButton = [[UIButton alloc] init];
//    [_moreItemButton setImage:[UIImage imageNamed:@"个人设置_头像_上传照片_添加照片"] forState:UIControlStateNormal];
//    [_moreItemButton addTarget:self action:@selector(moreItemButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_moreItemButton];
//    _moreItemButton.backgroundColor = [UIColor whiteColor];
//    [_itemsArray addObject:_moreItemButton];
//
//    
//}

#pragma mark - actions
- (void)moreItemButtonClicked
{
    if ([self.gridViewDelegate respondsToSelector:@selector(homeGrideViewmoreItemButtonClicked:)]) {
        [self.gridViewDelegate homeGrideViewmoreItemButtonClicked:self];
    }
}
/**
 *  计算行数
 *
 *  @param count 数组个数
 *
 *  @return 行数
 */
- (NSInteger)rowCountWithItemsCount:(NSInteger)count
{
    long rowCount = (count + kHomeGridViewTopSectionRowCount - 1) / kHomeGridViewTopSectionRowCount;
    rowCount = (rowCount < 4) ? 4 : ++rowCount;
    return rowCount;
}
//这是长按图片的手势响应
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)longPressed
{
    THHomeGridViewListItemView *pressedView = (THHomeGridViewListItemView *)longPressed.view;
    CGPoint point = [longPressed locationInView:self];
    
    if (longPressed.state == UIGestureRecognizerStateBegan) {

        _currentPressedView = pressedView;
        _currentPresssViewFrame = pressedView.frame;
        longPressed.view.transform = CGAffineTransformMakeScale(1.1, 1.1);//x,y方向缩放倍数
        long index = [_itemsArray indexOfObject:longPressed.view];
        [_itemsArray  removeObject:longPressed.view];
        [_itemsArray  insertObject:_placeholderButton atIndex:index];//_placeholderButton是一个空的按钮，用来占位，_itemsArray是装有图片的数组
        _lastPoint = point;
        [self bringSubviewToFront:longPressed.view];
    }
    
    CGRect temp = longPressed.view.frame;
    temp.origin.x += point.x - _lastPoint.x;
    temp.origin.y += point.y - _lastPoint.y;
    longPressed.view.frame = temp;
    
    _lastPoint = point;
    
    [_itemsArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button == _moreItemButton) return;
        if (CGRectContainsPoint(button.frame, point) && button != longPressed.view) {
            [_itemsArray removeObject:_placeholderButton];
            [_itemsArray insertObject:_placeholderButton atIndex:idx];
            *stop = YES;
            
            [UIView animateWithDuration:0.5 animations:^{
                [self setupSubViewsFrame]; //：重新计算位置
            }];
        }
        
    }];
    
    
    if (longPressed.state == UIGestureRecognizerStateEnded) {
        long index = [_itemsArray indexOfObject:_placeholderButton];
        [_itemsArray removeObject:_placeholderButton];
        [_itemsArray insertObject:longPressed.view atIndex:index];
        [self sendSubviewToBack:longPressed.view];
        
        /**
         *  头像label显示与消失
         */
        for (int i = 0; i < _itemsArray.count-1; i++) {
            THHomeGridViewListItemView *item = _itemsArray[i];
            if (i == 0) {
                item.headLabel.hidden = NO;
            }else {
                item.headLabel.hidden = YES;
            }
        }

        // 保存数据
        if ([self.gridViewDelegate respondsToSelector:@selector(homeGrideViewDidChangeItems:)]) {

            [self.gridViewDelegate homeGrideViewDidChangeItems:self];
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            longPressed.view.transform = CGAffineTransformIdentity;
            [self setupSubViewsFrame];
        } completion:^(BOOL finished) {

            
        }];
    }
    
}

- (void)deleteView:(THHomeGridViewListItemView *)view withIndex:(NSInteger)index
{
    [_itemsArray removeObject:view];
    
    [view removeFromSuperview];
    
    if ([self.gridViewDelegate respondsToSelector:@selector(homeGrideViewDidChangeItems:)]) {
        [self.gridViewDelegate homeGrideViewDidChangeItems:self];
    }
    [UIView animateWithDuration:0.4 animations:^{
        [self setupSubViewsFrame];
    }];
}
//：下面这个方法和后面的layoutSubviews都是计算图片位置的，每次重新计算的时候只调用下面的方法就行
- (void)setupSubViewsFrame
{
    CGFloat itemW = (self.sd_width-40) / kHomeGridViewTopSectionRowCount;
    CGFloat itemH = itemW ;
    [_itemsArray enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        long rowIndex = idx / kHomeGridViewTopSectionRowCount;
        long columnIndex = idx % kHomeGridViewTopSectionRowCount;
        
        CGFloat x = (itemW+10) * columnIndex+10;
        CGFloat y = (itemH+10) * rowIndex+10;
        item.frame = CGRectMake(x, y, itemW, itemH);
        if (idx == (_itemsArray.count - 1)) {
            self.contentSize = CGSizeMake(0, item.sd_height + item.sd_y);
        }
    }];
}
#pragma mark - life circles
- (void)layoutSubviews
{
    [super layoutSubviews];
    //CGFloat itemW = (self.sd_width-40)/ kHomeGridViewTopSectionRowCount;
    //CGFloat itemH = itemW ;
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-WidthSpace(84));
    
    [self setupSubViewsFrame];

}


@end
