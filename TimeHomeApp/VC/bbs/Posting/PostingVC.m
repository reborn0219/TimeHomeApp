//
//  PostingVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PostingVC.h"
#import "iCarousel.h"
//#import "PostingAttestationVC.h"
#import "ZSY_CertificationVC.h"
#import "ZSY_PhoneNumberBinding.h"
#import "MySettingAndOtherLogin.h"
#import "Getverified.h"
#import "THMyInfoPresenter.h"
#import "THOwnerAuthViewController.h"
#import "WebViewVC.h"
#import "MessageAlert.h"
#import "RaiN_QuestionPostVC.h"
#import "RaiN_HouseVC.h"
#import "L_CommunityAuthoryPresenters.h"
#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
@interface PostingVC ()<iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong)iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong) Getverified *model;
@end

@implementation PostingVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /** rootViewController不允许侧滑 */
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建数据源
    [self createDataSource];
    //创建iCarousel
    [self createiCarousel];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createiCarousel {

    if (SCREEN_HEIGHT <= 480) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, self.view.frame.size.height / 48 * 13 - 25, SCREEN_WIDTH - 16, SCREEN_HEIGHT - self.view.frame.size.height / 48 * 13 - 50 + 25)];
    }else if (SCREEN_HEIGHT <= 568) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, self.view.frame.size.height / 48 * 13, SCREEN_WIDTH - 16, SCREEN_HEIGHT - self.view.frame.size.height / 48 * 13 - 50)];
    }else if (SCREEN_HEIGHT <= 667) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, self.view.frame.size.height / 48 * 13 + 15, SCREEN_WIDTH - 16, SCREEN_HEIGHT - self.view.frame.size.height / 48 * 13 - 50 - 15)];
    }else {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, self.view.frame.size.height / 48 * 13 + 30, SCREEN_WIDTH - 16, SCREEN_HEIGHT - self.view.frame.size.height / 48 * 13 - 50 - 30)];
    }
    
    
    _bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgView];
    
    _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
    _carousel.backgroundColor = [UIColor clearColor];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.bounceDistance = 0.2f;
    _carousel.scrollSpeed = 0.2;
    // 类型
    _carousel.type = iCarouselTypeRotary;
    //YES竖着排列
    _carousel.vertical = YES;
    //不允许出界
    _carousel.clipsToBounds = YES;
    //用于设置被选中的单元格在否在中心
    _carousel.centerItemWhenSelected = YES;
    //控制滑动切换图片减速的快慢  默认0.95
    _carousel.decelerationRate = 0.95;
    //设置用户视点(看的位置) 类似contentoffset
    _carousel.viewpointOffset = CGSizeMake(0, 0);
    //第几张图片显示在当前位置
    [_carousel scrollToItemAtIndex:1 animated:NO];
    //一开始中心图偏移量
    _carousel.contentOffset = CGSizeMake(0, 0);
    [_bgView addSubview:_carousel];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"关闭按钮"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    
//    closeButton.frame = CGRectMake((SCREEN_WIDTH-33)/2., CGRectGetMaxY(_bgView.frame) + 8, 33, 33);
    
//    _bgView.backgroundColor = [UIColor greenColor];
    

    if (SCREEN_HEIGHT >= 812){
    
        [_bgView addSubview:closeButton];
    closeButton.sd_layout.bottomEqualToView(_bgView).centerXEqualToView(_bgView).heightIs(33).widthIs(33);
    }else {
        
        [self.view addSubview:closeButton];
        closeButton.sd_layout.topSpaceToView(_bgView,8).centerXEqualToView(self.view).heightIs(33).widthIs(33);
    }
}

#pragma mark - 数据源
- (void)createDataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray array] init];
        
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-房产图片新"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-普通图片新"]];

        [_dataSource addObject:[NSString stringWithFormat:@"发帖-问答图片新"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-车位图片新"]];
        
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-房产图片新"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-普通图片新"]];

        [_dataSource addObject:[NSString stringWithFormat:@"发帖-问答图片新"]];
        [_dataSource addObject:[NSString stringWithFormat:@"发帖-车位图片新"]];
    }

}

#pragma mark -- iCarouselDelegate And iCarouselDataSource
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.dataSource count];
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    UIView *bgView = view;
    //  (_bgView.frame.size.height - 32)/4*3
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (_bgView.frame.size.width - (44+statuBar_Height)), (_bgView.frame.size.width - (44+statuBar_Height))/357*327 )];
    bgView.backgroundColor = [UIColor clearColor];
    UIImageView *image = [[UIImageView alloc] initWithFrame:bgView.frame];
    
    image.layer.shadowColor = [UIColor blackColor].CGColor;
    image.layer.shadowOffset = CGSizeMake(0, 5);
    image.layer.shadowOpacity = 0.3;
    image.layer.shadowRadius = 10;
    image.backgroundColor = [UIColor clearColor];
    [bgView addSubview:image];
    image.image = [UIImage imageNamed:self.dataSource[index]];
    
    return bgView;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    NSLog(@"滚动中");
    //当前图片alpha为1 其他的图片为0.8
    for (UIView *otherView in carousel.visibleItemViews) {
        otherView.alpha = 0.6;
        CGFloat offset = [carousel offsetForItemAtIndex:[carousel indexOfItemView:otherView]];
        UIView *cover = [otherView viewWithTag:1];
        //fabs函数,返回double类型值得绝对值
        if (fabs(offset)>1.0f) {
            offset = 1.0f;
        }
        cover.layer.opacity = fabs(offset*0.3f);
        
    }
    UIView *currentView = [carousel currentItemView];
    currentView.alpha = 1;

}

#pragma mark -- 点击cell
- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

    NSLog(@"Tapped view number: %ld", (long)index);
    /**
     05 房产 16 普通 27 投票 38 问答 49 车位
     04 房产 15 普通 89 投票 26 问答 37 车位
     */
    
//    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    
    if (index == 0 || index == 4) {
        NSLog(@"房产");
        

        /**
         type  11 房产   31车位
         errcode，如果errcode为0则为有房产或者车位
         */
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
        [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if (resultCode == SucceedCode) {
                    
                    NSDictionary *dic = data[@"map"];
                    
                    NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                    [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
                    if ([resipower integerValue] == 0 ||[resipower integerValue] == 9) {
                        ///未认证
                        MessageAlert * msgAlert=[MessageAlert getInstance];
                        msgAlert.isHiddLeftBtn=NO;
                        msgAlert.closeBtnIsShow = YES;
                        
                        [msgAlert showInVC:self withTitle:@"您还未进行业主认证，业主认证后才可发布房产信息" andCancelBtnTitle:@"暂不进行认证" andOtherBtnTitle:@"业主认证"];
                        msgAlert.okBtn.backgroundColor = kNewRedColor;
                        @WeakObj(self)
                        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                        {
                            if (index==Ok_Type) {
                                NSLog(@"---跳转认证");
                                
                                [selfWeak goToCertification];
                                
                                
                            }
                            
                        };
                    }else {
                        ///认证
                        RaiN_HouseVC *house = [[RaiN_HouseVC alloc] init];
                        house.isHouse = @"0";
                        [self.navigationController pushViewController:house animated:YES];
                    }
                    
                }else {
                    [self showToastMsg:data Duration:3.0f];
                }
                
            });
        }];
        
        
    }else if (index == 1 || index == 5) {
        NSLog(@"普通");
        
        RaiN_QuestionPostVC *question = [[RaiN_QuestionPostVC alloc] init];
        question.isQuestion = @"0";
        [self.navigationController pushViewController:question animated:YES];
        
        
    }else if (index == 8 || index == 9) {
        NSLog(@"投票");
        
       
        
    }else if (index == 2 || index == 6) {
        NSLog(@"问答");
        
        RaiN_QuestionPostVC *question = [[RaiN_QuestionPostVC alloc] init];
        question.isQuestion = @"1";
        [self.navigationController pushViewController:question animated:YES];

        
    }else if (index == 3 || index == 7) {

        /**
         type  11 房产   31车位
         errcode，如果errcode为0则为有房产或者车位
         */
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [MySettingAndOtherLogin judgeHouseAreaWithType:@"30" andUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    
                    /**
                     有车位
                     */
                    RaiN_HouseVC *house = [[RaiN_HouseVC alloc] init];
                    house.isHouse = @"1";
                    [self.navigationController pushViewController:house animated:YES
                     ];

                    
                }else {
                    
                    /**
                     没有车位
                     */
                    MessageAlert * msgAlert=[MessageAlert getInstance];
                    msgAlert.isHiddLeftBtn=YES;
                    msgAlert.closeBtnIsShow = YES;
                    
                    [msgAlert showInVC:self withTitle:@"您还没有车位信息" andCancelBtnTitle:@"" andOtherBtnTitle:@"确定"];
                    msgAlert.okBtn.backgroundColor = kNewRedColor;
                    msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                    {
                        //点击回调
                        
                    };
                    
                }
                
            });
            
        }];
        
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


#pragma mark -- button Click
/**
 关闭按钮
 */
- (void)closeButtonClcik:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:NO];

}



/**
 跳转认证页
 */
- (void)goToCertification {
    
    
    THIndicatorVCStart
    [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if (resultCode == SucceedCode) {
                
                //                NSString *isownercert = [NSString stringWithFormat:@"%@",data[@"map"][@"isownercert"]];
                //
                //                if (isownercert.intValue == 1) {
                //
                //                    [self showToastMsg:@"当前社区已认证" Duration:3.0];
                //                    return ;
                //
                //                }else {
                
                NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                AppDelegate *appDlgt = GetAppDelegates;
                if (houseArr.count > 0) {
                    
                    //---有房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                    houseListVC.fromType = 5;
                    houseListVC.houseArr = houseArr;
                    houseListVC.carArr = carArr;
                    houseListVC.communityID = appDlgt.userData.communityid;
                    houseListVC.communityName = appDlgt.userData.communityname;
                    [houseListVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:houseListVC animated:YES];
                    
                }else {
                    
                    //---无房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                    addVC.fromType = 5;
                    addVC.communityID = appDlgt.userData.communityid;
                    addVC.communityName = appDlgt.userData.communityname;
                    [addVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:addVC animated:YES];
                    
                }
                
                //                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

@end
