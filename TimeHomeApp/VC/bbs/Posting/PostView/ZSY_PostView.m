//
//  ZSY_PostView.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_PostView.h"
#import "PostingAttestationVC.h"
#import "ZSY_CertificationVC.h"
#import "ZSY_PhoneNumberBinding.h"
@implementation ZSY_PostView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:@"发帖页面背景"];
        [self addSubview:imageView];
        [self createDataSource];
        [self createiCarousel];
    }
    return self;
}
- (void)createiCarousel {//self.view.frame.size.height / 4
    //6sp
    //4s    480
    //5s    568
    //6     667
    if (SCREEN_HEIGHT <= 480) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, self.frame.size.height / 48 * 13 - 25, SCREEN_WIDTH - 16, SCREEN_HEIGHT - self.frame.size.height / 48 * 13 - 50 + 25)];
    }else if (SCREEN_HEIGHT <= 568) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, self.frame.size.height / 48 * 13, SCREEN_WIDTH - 16, SCREEN_HEIGHT - self.frame.size.height / 48 * 13 - 50)];
    }else if (SCREEN_HEIGHT <= 667) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, self.frame.size.height / 48 * 13 + 15, SCREEN_WIDTH - 16, SCREEN_HEIGHT - self.frame.size.height / 48 * 13 - 50 - 15)];
    }else {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, self.frame.size.height / 48 * 13 + 30, SCREEN_WIDTH - 16, SCREEN_HEIGHT - self.frame.size.height / 48 * 13 - 50 - 30)];
    }
    
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
    _carousel.backgroundColor = [UIColor clearColor];
    _carousel.type = iCarouselTypeRotary; // 类型
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.bounceDistance = 0.2f;
    _carousel.vertical = YES;  //YES竖着排列
    _carousel.clipsToBounds = YES; //不允许出界
    _carousel.centerItemWhenSelected = YES; //用于设置被选中的单元格在否在中心
    _carousel.decelerationRate = 0.95;//控制滑动切换图片减速的快慢  默认0.95
    _carousel.viewpointOffset = CGSizeMake(0, 0); //设置用户视点(看的位置) 类似contentoffset
    [_carousel scrollToItemAtIndex:0 animated:NO];//第几张图片显示在当前位置
    //一开始中心图偏移量
    _carousel.contentOffset = CGSizeMake(0, 0);
    //
    [_bgView addSubview:_carousel];
    
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"关闭按钮"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    closeButton.sd_layout.topSpaceToView(_bgView,8).centerXEqualToView(self).heightIs(33).widthIs(33);
}
///数据源
- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray array] init];
        
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-房产图片"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-普通图片"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-商品图片"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-投票图片"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-问答图片"]];
        
        
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-房产图片"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-普通图片"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-商品图片"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-投票图片"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-问答图片"]];
        
    }
}
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [self.dataSource count];
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    UIView *bgView = view;
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width - 64, (_bgView.frame.size.height - 32)/4*3)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:bgView.frame];
    
    //    image.layer.masksToBounds = YES;
    //    [image.layer setCornerRadius:image.frame.size.height/10];
    
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowOpacity = 0.5;
    bgView.layer.shadowRadius = 10;
    
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:image];
    image.image = [UIImage imageNamed:self.dataSource[index]];
    
    return bgView;
}
- (void)carouselDidScroll:(iCarousel *)carousel{
    NSLog(@"滚动中");
    
    
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"Tapped view number: %ld", (long)index);
    //    05 房产    16 普通  27 商品  38 投票  49 问答
    
    if (index == 2 || index == 7 ) {
        //绑定手机号和实名认证  商品贴
        
        PostingAttestationVC *post = [PostingAttestationVC sharePostingAttestationVC];
        [post showInVC:self withTitle:@"您还没有实名认证,请先实名认证" andButtonTitle:@"去实名认证" andTopViewColor:kNewRedColor];
        
        @WeakObj(self)
        post.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
            ZSY_CertificationVC *certifcation = [[ZSY_CertificationVC alloc] init];
//            [selfWeak.navigationController pushViewController:certifcation animated:YES];
            
        };
        
    }else if(index == 0 || index == 5){
        //业主认证和绑定手机号  房产帖
        
        NSLog(@"手机认证");
        PostingAttestationVC *post = [PostingAttestationVC sharePostingAttestationVC];
        [post showInVC:self withTitle:@"您未进行手机认证" andButtonTitle:@"去进行认证" andTopViewColor:RGBA(169, 170, 171, 1)];
        
        @WeakObj(self)
        post.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
        {
//            ZSY_PhoneNumberBinding *phoneNumber = [[ZSY_PhoneNumberBinding alloc] init];
//            [selfWeak.navigationController pushViewController:phoneNumber animated:YES];
            
        };
    }else {
        //绑定手机号
        
        NSLog(@"手机认证");
        PostingAttestationVC *post = [PostingAttestationVC sharePostingAttestationVC];
        [post showInVC:self withTitle:@"您未进行手机认证" andButtonTitle:@"去进行认证" andTopViewColor:RGBA(169, 170, 171, 1)];
        
        @WeakObj(self)
        post.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
        {
            ZSY_PhoneNumberBinding *phoneNumber = [[ZSY_PhoneNumberBinding alloc] init];
//            [selfWeak.navigationController pushViewController:phoneNumber animated:YES];
//            [selfWeak dismissViewControllerAnimated:YES completion:nil];
        };
    }
    
    
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {
    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
}

///当前屏幕显示几张图片
- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel {
    return 5;//numberOfVisibleItems
}
//item图片之间的间隔宽
- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return (_bgView.frame.size.height - 32)/7;
}
///可以获得icarousel上停止滑动时当前的元素
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
}
///此协议方法可以设置每个视图之间的间隙的各种位置属性，还可以通过此协议方法设置是否采用旋转木马效果
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    
    switch (option) {
            /**
             iCarouselOptionWrap
             iCarouselOptionShowBackfaces,
             iCarouselOptionOffsetMultiplier,
             iCarouselOptionVisibleItems,
             iCarouselOptionCount,
             iCarouselOptionArc,
             iCarouselOptionAngle,
             iCarouselOptionRadius,
             iCarouselOptionTilt,
             iCarouselOptionSpacing,
             iCarouselOptionFadeMin,
             iCarouselOptionFadeMax,
             iCarouselOptionFadeRange,
             iCarouselOptionFadeMinAlpha
             */
            
        case iCarouselOptionVisibleItems:
            return 5;
            break;
        case iCarouselOptionWrap:
        {//返回可循环
            return YES;
            break;
        }
        case iCarouselTypeRotary:
        {
            
        }
        default:
            break;
    }
    return value;
    
}
- (void)closeButtonClcik:(UIButton *)button {
    //    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
