//
//  BtmFilterTools.m
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BtmFilterTools.h"
#import "Masonry.h"
#import "UIButtonImageWithLable.h"

@implementation MenuModel : NSObject
@end


@interface BtmFilterTools()
{
    double btnWith;//宽
    double btnHeight;//高
}
@end

@implementation BtmFilterTools

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 *  初始化方法
 *
 *  @param frame     frame 控件位置大小
 *  @param filterArr filterArr 条件数组
 *
 *  @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame filterArray:(NSMutableArray *) filterArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=RGBAFrom0X(0x000000,0.7);
        self.FilterArray=filterArr;
        [self setFilterViews];
    }
    return self;
}

/**
 *  初始化方法带回调事件处理
 *
 *  @param frame     frame 控件位置大小
 *  @param filterArr filterArr 条件数组
 *  @param eventBlock eventBlock 事件回调
 *
 *  @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame filterArray:(NSMutableArray *) filterArr eventCall:(ViewsEventBlock )eventBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=RGBAFrom0X(0x000000,0.7);
        self.FilterArray=filterArr;
        self.eventCallBack=eventBlock;
        [self setFilterViews];
    }
    return self;
}
//NIb 加载时，处理初始化
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor=RGBAFrom0X(0x000000,0.7);
    }
    return self;
}
/**
 *  重写FilterArray 的set方法
 *
 *  @param FilterArray FilterArray description
 */
-(void)setFilterArray:(NSMutableArray *)FilterArray
{
    _FilterArray=FilterArray;
    [self setFilterViews];
}

/**
 *  添加视图
 */
-(void) setFilterViews
{
    MenuModel * filter;
    NSInteger count=self.FilterArray.count;
    btnWith=SCREEN_WIDTH/count;
    btnHeight=self.frame.size.height;
    for(int i=0;i<count;i++)
    {
        filter=[self.FilterArray objectAtIndex:i];
        [self setBtnView:filter tag:i];
    }
}
/**
 *  单个条件视图组合
 *
 *  @param filter filter description
 *  @param tag    <#tag description#>
 */
-(void) setBtnView:(MenuModel *)filter tag:(int) tag
{
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(btnWith*tag,0, btnWith, btnHeight)];
    
    [self addSubview:btn];
    if (tag<self.FilterArray.count-1) {
        UIView * vLine=[[UIView alloc]initWithFrame:CGRectMake(btnWith*(tag+1),10, 1, btnHeight-20)];
        vLine.backgroundColor=UIColorFromRGB(0xffffff);
        [self addSubview:vLine];
    }
    btn.tag=(tag+1)*100;
    btn.titleLabel.font=DEFAULT_SYSTEM_FONT(12);
    [btn setTopImage:[UIImage imageNamed:filter.imgName] withTitle:filter.title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClik:) forControlEvents:UIControlEventTouchUpInside];
}

///改变时，设置标题
-(void)setTitleTextChangeForIndex:(NSInteger )index
{
    MenuModel * filter=[self.FilterArray objectAtIndex:index];
    UIButton * btn=[self viewWithTag:(index+1)*100];
    if(btn!=nil)
    {
        UIImage * img=[UIImage imageNamed:filter.imgName];
        NSString * title=filter.title;
        [btn setTopImage:img withTitle:title forState:UIControlStateNormal];
    }
    
}

///设置颜色
-(void)setItemChangeForIndex:(NSInteger )index color:(UIColor *)color
{
    UIButton * btn=[self viewWithTag:(index+1)*100];
    if(btn!=nil)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}


/**
 *  点击事件
 *
 *  @param sender sender description
 */
-(void)buttonClik:(UIButton *) sender
{
    if(self.eventCallBack)
    {
        self.eventCallBack(nil,sender,sender.tag/100-1);
    }
}
/**
 *  设置事件回调
 *
 *  @param eventBlock eventBlock 回调
 */
-(void)setFilterEventCall:(ViewsEventBlock) eventBlock
{
    _eventCallBack=eventBlock;
}

@end
