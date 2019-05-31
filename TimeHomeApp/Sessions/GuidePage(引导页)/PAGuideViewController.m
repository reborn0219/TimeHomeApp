//
//  SHGuideViewController.m
//  PAPark
//
//  Created by WangKeke on 2018/5/25.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "PAGuideViewController.h"

NSString * const kGuidePageVersion = @"kGuidePageVersion";

@interface PAGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIPageControl *mPageControl;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, copy) void (^buttonExitBlock)(void);

@end

@implementation PAGuideViewController

#pragma mark

+(void)showGuidePageWithImageArray:(NSArray*)imageArray Completion:(void(^)(BOOL isNewVersion))completionBlock{
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isNewVersion = ![[[UIApplication sharedApplication]appVersion] isEqualToString:[userDefault objectForKey:kGuidePageVersion]];
    
    if (isNewVersion) {
        
        PAGuideViewController *guideVC = [[PAGuideViewController alloc]init];
        guideVC.imageArray = imageArray;
        
        [guideVC setButtonExitBlock:^{
            
            //保存当前版本号
            
            [userDefault setObject:[[UIApplication sharedApplication]appVersion] forKey:kGuidePageVersion];
            
            [userDefault synchronize];
            
            if (completionBlock) {
                completionBlock(isNewVersion);
            }
        }];
        AppDelegate * delegate =GetAppDelegates;
        delegate.window.rootViewController = guideVC;
        
    }else if (completionBlock){
        
        completionBlock(isNewVersion);
        
    }
}

#pragma mark - view

- (UIScrollView *) mScrollView{
    
    if(!_mScrollView){
        _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _mScrollView.delegate = self;
        _mScrollView.contentSize = CGSizeMake(kScreenWidth*self.imageArray.count, kScreenHeight);
        _mScrollView.bounces = NO;
        _mScrollView.pagingEnabled = YES;
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mScrollView;
}

- (UIPageControl *) mPageControl{
    if(!_mPageControl){
        _mPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth-256.0)/2, ((kScreenHeight-60.0)-40.0/2), 256.0, 40.0)];
        _mPageControl.numberOfPages = self.imageArray.count;
        _mPageControl.currentPage=0;
        _mPageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"0x0d93fd"];
        _mPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _mPageControl.hidden = YES;
    }
    return _mPageControl;
}

#pragma mark - life cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.mScrollView];
    [self.view addSubview:self.mPageControl];
    
    for(int i=0; i < self.imageArray.count; i++){
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, self.mScrollView.width, self.mScrollView.height)];
        imageview.image = [UIImage imageNamed:self.imageArray[i]];
        imageview.userInteractionEnabled = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        [self.mScrollView addSubview:imageview];
        
        //最后一张广告页增加跳转按钮
        if(i == self.imageArray.count - 1){
            /*
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake((kScreenWidth-256.0)/2, ((kScreenHeight-80.0)-40.0/2), 256.0, 40.0)];
            [button setBackgroundImage:[UIImage imageNamed:@"引导页按钮"] forState:UIControlStateNormal];
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            [button setTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
            [imageview addSubview:button];
             */
            imageview.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exit)];
            [imageview addGestureRecognizer:tap];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event

-(void)exit{
    if (self.buttonExitBlock) {
        self.buttonExitBlock();
    }
}

#pragma mark - scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger pageIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if (pageIndex == self.imageArray.count-1) {
        self.mPageControl.hidden = YES;
    }else{
        self.mPageControl.hidden = YES;
    }
    
    [self.mPageControl setCurrentPage:pageIndex];
    
}
@end
