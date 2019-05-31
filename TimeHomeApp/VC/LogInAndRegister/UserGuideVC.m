//
//  UserGuideVC.m
//  YouLifeApp
//
//  Created by us on 15/9/6.
//  Copyright © 2015年 us. All rights reserved.
//

#import "UserGuideVC.h"
#import "AppDelegate.h"
#import "UserDefaultsStorage.h"
#import "AnimtionUtils.h"

@interface UserGuideVC ()<UIScrollViewDelegate>
{
    NSInteger _currentPage;
    AppDelegate * _appDelegate;
}


@end

@implementation UserGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenStatusBar];
    self.pc_PageControls.hidden = YES;
    _appDelegate=GetAppDelegates;
    self.sv_Guides.delegate=self;
    
    [self.sv_Guides setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    [self.sv_Guides setContentSize:CGSizeMake(SCREEN_WIDTH, 0)];

    NSArray * imgArr=@[@"引导页-1",@"引导页-2",@"引导页-3",@"引导页-4"];
    UIImageView * imgView;
    for (int i=0; i<imgArr.count; i++) {
        imgView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imgView setImage:[UIImage imageNamed:imgArr[i]]];
        if (i==3) {
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLogIn:)];
            [imgView addGestureRecognizer:singleTap];
        }
        [self.sv_Guides addSubview:imgView];
    }
    [self.pc_PageControls setCurrentPage:_currentPage];
   
    
}
-(void)hiddenStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)viewDidLayoutSubviews
{
    self.sv_Guides.contentSize=CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT);
}

-(void) goToLogIn:(id)sender
{
    [self toLogInVc];
}
-(void) toLogInVc
{
    _appDelegate.userData.isGuide=[[NSNumber alloc]initWithBool:YES];
    [_appDelegate saveContext];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
    [self.view.window.layer addAnimation:animation forKey:nil];
}

-(void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int x = scrollView.contentOffset.x;
    NSLog(@"scrollViewDidScroll x is %d",x);
    if (x>SCREEN_WIDTH*4+30) {
        
        NSLog(@"换下一页");
       [self toLogInVc];
    }
}
-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
//    int x = scrollView.contentOffset.x;
//    NSLog(@"scrollViewDidScroll x is %d",x);
//    if (x>SCREEN_WIDTH*2+30) {
//        
//        NSLog(@"换下一页");
//        
//    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    int x = scrollView.contentOffset.x;
    NSLog(@"x is %d",x);
    _currentPage= x/SCREEN_WIDTH;
    //往下翻一张
   [self.pc_PageControls setCurrentPage:_currentPage];
    
}


@end
