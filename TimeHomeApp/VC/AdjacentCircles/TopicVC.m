//
//  TopicVC.m
//  TimeHomeApp
//  Created by UIOS on 16/2/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

///vcs
#import "TopicVC.h"
#import "PersonalDataVC.h"
#import "ActionSheetVC.h"
#import "PublishTopicVC.h"
#import "ChatMessageMainVC.h"
#import "AlertsListVC.h"
#import "THMySettingsVC.h"
#import "PublishPostVC.h"
#import "PublishPost_LVC.h"
#import "AllCircleListVC.h"
#import "FollowCircleListVC.h"
#import "MessageInputAlert.h"

#import "UIImage+ImageEffects.h"

///cells
#import "DynamicImgCell.h"
#import "Topic_Cell_1.h"
#import "Topic_Cell_2.h"
#import "Topic_Cell_3.h"

///views
#import "CircleHeaderView.h"
#import "CircleFooterView.h"
#import "CollectionTitleV.h"
#import "TopicFooterView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "WebViewVC.h"
#import "SDPhotoBrowser.h"
#import "MessageAlert.h"
#import "LineBtnFooterView.h"
#import "GGFooterView.h"

///models
#import "PostPresenter.h"
#import "RecommendTopicModel.h"
#import "TopicPostModel.h"
#import "DateTimeUtils.h"
#import "DataOperation.h"
#import "PushMsgModel.h"
#import "MainTabBars.h"
#import "ImageUitls.h"
#import "UserInfoMotifyPresenters.h"
#import "SharePresenter.h"

@interface TopicVC ()<UICollectionViewDataSource,SDPhotoBrowserDelegate,UIAlertViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    TopicPostModel * GG_TPML_TOP;
    TopicPostModel * GG_TPML_MIDDLE;
    TopicPostModel * delModel;
    ///推荐
    NSArray * recommendArr;
    
    ///关注
    NSArray * followRecommendArr;
    ///临时数组
    NSArray * activeArr;
    ///最近浏览
    NSArray * recentlyArr;
    ///全部圈子帖子
    NSMutableArray * topicPostArr;
    ///关注圈子的帖子
    NSMutableArray * topicFollowArr;
    ///全部帖子分页表示
    NSInteger page;
    ///关注帖子分页标示
    NSInteger follow_page;
    
    BOOL isShowRecommend;
    BOOL isShowFollow;
    UILabel * lb_num;
    
    AppDelegate * appDlgt;
    ///没有更多数据 YES
    BOOL isNODdata;
    UIButton * activeBtn;
    dispatch_group_t  guanzhuGroup;
    ///是全部或者是关注
    __block BOOL isAll;
    ///换一组页码
    NSString * currentPage;
    
}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *right_title_btn;
@property (weak, nonatomic) IBOutlet UIButton *left_title_btn;
@property (strong, nonatomic)UICollectionView *collectionV;
@property (nonatomic,copy)NSArray * imageList;

@end


@implementation TopicVC

#pragma mark - lifeCircle

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self setBadges];
    [self receiveNewMsg];
    [self.collectionV reloadData];
    
    //单用户切换社区以后 需要刷新邻圈列表
    NSNumber * isChangeSheQu =  [[NSUserDefaults standardUserDefaults]objectForKey:@"isChangeSheQu"];
    if (isChangeSheQu.boolValue) {
        [self loadOne];
        [[NSUserDefaults standardUserDefaults]setObject:@NO forKey:@"isChangeSheQu"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    currentPage = @"1";
    follow_page = 0;
    appDlgt=GetAppDelegates;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remarkAction:) name:@"remarkName" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remarkPicAction:) name:@"headPicUrl" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkfollowAction:) name:@"checkfollow" object:nil];
    
    self.titleView.layer.borderWidth = 1;
    self.titleView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    [self.left_title_btn setTitleColor:TABBAR_COLOR forState:UIControlStateNormal];
    [self.left_title_btn setSelected:YES];
    [self.left_title_btn setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    topicPostArr = [[NSMutableArray alloc]initWithCapacity:0];
    topicFollowArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(10,64, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-50) collectionViewLayout:flowlayout];
    
    
    [self.collectionV setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    self.collectionV.delegate = self;
    self.collectionV.dataSource =self;
    self.collectionV.alwaysBounceVertical = YES;
    
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"Topic_Cell_3" bundle:nil] forCellWithReuseIdentifier:@"topicCell_3"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"Topic_Cell_1" bundle:nil] forCellWithReuseIdentifier:@"topicCell_1"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"Topic_Cell_2" bundle:nil] forCellWithReuseIdentifier:@"topicCell_2"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"DynamicImgCell" bundle:nil] forCellWithReuseIdentifier:@"imgCell"];
    
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"CircleHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"];
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"CollectionTitleV" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"titleHeaderView"];
    
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"CircleFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell"];
    
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"TopicFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerNextView"];
    
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"LineBtnFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineBtnFooterView"];
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"GGFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GGFooterView"];
    
    
    self.navigationItem.title = @"邻圈";
    isShowFollow = NO;
    isShowRecommend = NO;
    [topicPostArr removeAllObjects];
    [self.view addSubview:self.collectionV];
    [self initMessageMenuView];
    page = 1;
    
    @WeakObj(self);
    
    /**
     *  刷新
     */
    isAll = YES;
    
    _collectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadOne];
    }];
    /**
     加载
     */
    _collectionV.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadMore];

    }];
   
    [self.collectionV.mj_header beginRefreshing];
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *testBt = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50 - 20, self.view.frame.size.height - 50 - 20 - self.tabBarController.tabBar.frame.size.height, 50, 50)];
    [testBt setBackgroundColor:[UIColor greenColor]];
    [testBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testBt setTitle:@"发贴" forState:UIControlStateNormal];
    testBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [testBt addTarget:self action:@selector(testBt:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:testBt];
    
}

-(void)testBt:(id)sender{
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + self.tabBarController.tabBar.frame.size.height)];
    [backView setImage:[self imageWithView:backView]];
    backView.userInteractionEnabled = YES;
    [self.view.window addSubview:backView];
}

-(UIImage*)imageWithView:(UIView*)view{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height),NO, [[UIScreen mainScreen]scale]);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIColor *tintColor = [UIColor colorWithWhite:0.95 alpha:0.78];
    
    //添加毛玻璃效果
    
    image = [image applyBlurWithRadius:15 tintColor:tintColor saturationDeltaFactor:1 maskImage:nil];
    
    //这句话必须要加，不加程序会不断开启上下文并且不会释放
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"headPicUrl" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"remarkName" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"checkfollow" object:nil];

}

#pragma mark - 初始化消息通知菜单
-(void)initMessageMenuView
{
    self.messageMenu = [[UIView alloc]init];
    [self.messageMenu setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.messageMenu];
    [[self.messageMenu layer] setShadowOffset:CGSizeMake(1, 1)];
    [[self.messageMenu layer] setShadowRadius:3];
    [[self.messageMenu layer] setShadowOpacity:1];
    [[self.messageMenu layer] setShadowColor:[UIColor blackColor].CGColor];
    [[self.messageMenu layer] setCornerRadius:20.0f];
    
    [self.messageMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@40.0f);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@120.0f);
    }];
    UIImageView * imgV = [[UIImageView alloc]init];
    [imgV setImage:[UIImage imageNamed:@"邻圈_新消息提示框"]];
    [self.messageMenu addSubview:imgV];
    [self.messageMenu setHidden:YES];

    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@30.0f);
        make.top.equalTo(self.messageMenu.mas_top).offset(5);
        make.left.equalTo(self.messageMenu.mas_left).offset(10);
        make.width.equalTo(@30.0f);
    }];
    
    
    lb_num = [[UILabel alloc]init];
    [lb_num setFont:[UIFont systemFontOfSize:12.0f]];
    [lb_num setTextColor:PURPLE_COLOR];
    [self.messageMenu addSubview:lb_num];
    lb_num.text = @"0";
    [lb_num mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@30.0f);
        make.top.equalTo(self.messageMenu.mas_top).offset(5);
        make.left.equalTo(imgV.mas_right).offset(3);
        make.width.equalTo(@20.0f);
    }];
    
    UILabel * lb = [[UILabel alloc]init];
    [lb setText:@"条新消息"];
    [lb setFont:[UIFont systemFontOfSize:12.0f]];
    [self.messageMenu addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@30.0f);
        make.top.equalTo(self.messageMenu.mas_top).offset(5);
        make.left.equalTo(lb_num.mas_right).offset(0);
        make.width.equalTo(@100.0f);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MessageMenuClick:)];
    [self.messageMenu addGestureRecognizer:tap];

}
#pragma mark - 主页消息悬浮框点击事件
-(void)MessageMenuClick:(UIGestureRecognizer *)gestInfo
{
    
    PushMsgModel * pushMsg = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.BBSMsg];
    pushMsg.countMsg = @0;
    [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.BBSMsg];
    
    AlertsListVC * alVC = [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertsListVC"];
    
    [self.navigationController pushViewController:alVC animated:YES];
    
}

#pragma  mark - 修改帖子备注通知
-(void)remarkAction:(NSNotification *)notification
{
    NSDictionary * remarkDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"remarkName"];
    if (remarkDic!=nil) {
        
        for (int i =0; i<(isAll ? topicPostArr:topicFollowArr).count; i++) {
            TopicPostModel * tempModel = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:i];
            if ([tempModel.userid isEqualToString:[remarkDic.allKeys firstObject]]) {
                
                tempModel.nickname = [remarkDic objectForKey:tempModel.userid];

            }
        }
        remarkDic=nil;
        [[NSUserDefaults standardUserDefaults]setObject:remarkDic forKey:@"remarkName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

}
#pragma  mark - 修改关注通知
-(void)checkfollowAction:(NSNotification *)notification
{
    NSDictionary * dic = notification.object;
    
    for (int i =0; i<activeArr.count; i++) {
        RecommendTopicModel * RTML = [activeArr objectAtIndex:i];
        
        if ([RTML.recommendTopicID isEqualToString:[dic.allKeys firstObject]]) {
            
            RTML.isfollow = [dic objectForKey:RTML.recommendTopicID];
            
        }
    }
    [self.collectionV reloadData];

    [self updateTopicPost];
}
#pragma  mark - 修改头像通知
-(void)remarkPicAction:(NSNotification *)notification
{
    NSDictionary * remarkDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"headPicUrl"];
    if (remarkDic!=nil) {
        
        for (int i =0; i<(isAll ? topicPostArr:topicFollowArr).count; i++) {
            TopicPostModel * tempModel = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:i];
            if ([tempModel.userid isEqualToString:[remarkDic.allKeys firstObject]]) {
                
                tempModel.userpic = [remarkDic objectForKey:tempModel.userid];
            }
        }
        remarkDic=nil;
        [[NSUserDefaults standardUserDefaults]setObject:remarkDic forKey:@"headPicUrl"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}
#pragma mark - 数据加载网络请求
-(void)loadOne
{
    follow_page = 1;
    page = 1;
    
    if(isAll){
        [self loadData];
    }else{
        [self loadFollowData];
    }
}
-(void)loadMore
{
    page ++;
    follow_page ++;
    NSLog(@"page===%ld",page);
    
    if(isAll){
        [self loadData];
    }else{
        [self loadFollowData];
    }
}
#pragma mark - 请求全部圈子界面数据
-(void)loadData
{
    
    self.nothingnessView.hidden =YES;
    @WeakObj(self)
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];

//    [self showMaskingViewArrays:@[@"邻圈_新手引导"] frameArray:nil];
    dispatch_group_t group = dispatch_group_create();
    ///分页请求话题帖子
    dispatch_group_enter(group);
    [PostPresenter getAppTopicPosts:^(id  _Nullable data, ResultCode resultCode) {
        
        NSLog(@"%@",data);
        if (resultCode==SucceedCode) {
            isNODdata=NO;
            if (page == 1) {
                [topicPostArr  removeAllObjects];
                [topicPostArr addObjectsFromArray:data];
            }else
            {
                [topicPostArr addObjectsFromArray:data];
            }
        }else
        {
            isNODdata=YES;
            dispatch_async(dispatch_get_main_queue(), ^{

                if (page !=1) {
                    // [selfWeak showToastMsg:@"没有更多数据" Duration:2.5f];
                }else
                {
                    [topicPostArr  removeAllObjects];
                }
            });
        }

        dispatch_group_leave(group);

    }withPage:[NSString stringWithFormat:@"%ld",(long)page]];
    ///请求最近浏览的圈子
    dispatch_group_enter(group);

    [PostPresenter getFllowTopic:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode==SucceedCode) {
                
                /**
                 *  数组判断
                 */
                isShowFollow = YES;
                if ([data isKindOfClass:[NSArray class]]) {
                    recentlyArr = data;

                }
                NSLog(@"%@",data);
            }else
            {
                isShowFollow = NO;
                recentlyArr = nil;
                
            }
            dispatch_group_leave(group);

        });
        
    }];
    ///邻圈广告位
    dispatch_group_enter(group);
    [PostPresenter getGamadvertise:^(id  _Nullable data, ResultCode resultCode) {
    
        dispatch_async(dispatch_get_main_queue(), ^{

            if (resultCode == SucceedCode) {
                
                NSArray * list = data;
                
                NSDictionary * temp_top = [selfWeak getGGWithShowType:@"0" :list];
                NSDictionary * temp_middle = [selfWeak getGGWithShowType:@"1" :list];

                if (temp_top) {
                    
                    GG_TPML_TOP = [TopicPostModel mj_objectWithKeyValues:temp_top];
                    GG_TPML_TOP.isGG = @"1";

                }
                if (temp_middle) {
                    
                    GG_TPML_MIDDLE = [TopicPostModel mj_objectWithKeyValues:temp_middle];
                    GG_TPML_MIDDLE.isGG = @"1";
                    
                }
                
                
            }
            dispatch_group_leave(group);
        });
        
    }];
    
    ///推荐圈子
    dispatch_group_enter(group);

    [PostPresenter getRecommendTopic:currentPage:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (resultCode==SucceedCode) {
                
                recommendArr = data;
                isShowRecommend = YES;
                selfWeak.collectionV.hidden = NO;
                selfWeak.nothingnessView.hidden = YES;
                activeArr = recommendArr;
//                [selfWeak.collectionV reloadData];
            }else
            {
                isShowRecommend = NO;
                recommendArr = nil;
                activeArr = recommendArr;
                
            }
            dispatch_group_leave(group);

        });
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 汇总代码
        
        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

        if(page == 1 ){
            
            if([GG_TPML_TOP.isGG isEqualToString:@"1"])
            {
                [topicPostArr insertObject:GG_TPML_TOP atIndex:0];
                
            }
            if([GG_TPML_MIDDLE.isGG isEqualToString:@"1"])
            {
                if (topicPostArr.count>19) {
                    [topicPostArr insertObject:GG_TPML_MIDDLE atIndex:19];
                }
            }

            
            [selfWeak.collectionV.mj_header endRefreshing];
        }else
        {
            if(isNODdata)
            {
                if(page>1)
                {
                    page --;
                    isNODdata=NO;
                }
            }
            [selfWeak.collectionV.mj_footer endRefreshing];
            
        }
        
        
        if(recommendArr==nil&&recentlyArr == nil&&(topicPostArr.count==0)){
            selfWeak.nothingnessView.hidden = NO;
            selfWeak.collectionV.hidden = YES;
            [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据" eventCallBack:nil];
            [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
        }else
        {
            selfWeak.collectionV.hidden = NO;
            selfWeak.nothingnessView.hidden = YES;
        }
        [selfWeak.collectionV reloadData];


    });
    
}
#pragma mark - 获取广告信息
-(id)getGGWithShowType:(NSString * )type :(NSArray *)list
{
    
    for (int i =  0; i<list.count; i++) {
        
        NSDictionary * tempDic = [list objectAtIndex:i];
        NSString * showtype = [tempDic objectForKey:@"showtype"];
        if (showtype.integerValue == type.integerValue) {
            return tempDic;
        }
    }
    return nil;
}
#pragma mark - 请求关注页面数据
-(void)loadFollowData
{
    self.nothingnessView.hidden =YES;
    
    @WeakObj(self)
    dispatch_group_t group = dispatch_group_create();
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];

    ///分页请求关注圈子帖子
    dispatch_group_enter(group);
    
    [PostPresenter getFollowTopicPosts:[NSString stringWithFormat:@"%ld",follow_page]:^(id  _Nullable data, ResultCode resultCode) {
        
        NSLog(@"%@",data);
        if (resultCode==SucceedCode) {
            isNODdata=NO;
            if (follow_page == 1) {
                [topicFollowArr  removeAllObjects];
                [topicFollowArr addObjectsFromArray:data];
            }else
            {
                [topicFollowArr addObjectsFromArray:data];
            }
        }else
        {
            isNODdata=YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (follow_page !=1) {
                    // [selfWeak showToastMsg:@"没有更多数据" Duration:2.5f];
                }else
                {
                    [topicFollowArr  removeAllObjects];
                }
            });
        }
        
        dispatch_group_leave(group);
        
    }];
    
    ///请求关注话题
    dispatch_group_enter(group);
    [PostPresenter getFollowTopic:@"" withPage:@"1" withBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode==SucceedCode) {
                
                /**
                 *  数组判断
                 */
                isShowFollow = YES;
                if ([data isKindOfClass:[NSArray class]]) {
                    followRecommendArr= data;
                    
                }
                NSLog(@"%@",data);
            }else
            {
                followRecommendArr = nil;
            }
            dispatch_group_leave(group);
            
        });
        
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 汇总代码
        
        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            isShowFollow = NO;
            recentlyArr = nil;
            activeArr = followRecommendArr;
            
            if(follow_page == 1 ){
                [selfWeak.collectionV.mj_header endRefreshing];
            }else
            {
                if(isNODdata)
                {
                    if(follow_page>1)
                    {
                        follow_page --;
                        isNODdata=NO;
                    }
                    
                }
                [selfWeak.collectionV.mj_footer endRefreshing];
                
            }
            if(followRecommendArr==nil&&(topicFollowArr.count==0)){
                
                selfWeak.collectionV.hidden = YES;
                selfWeak.nothingnessView.hidden = NO;
                [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"暂无数据" eventCallBack:nil];
                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                
            }else
            {
                selfWeak.collectionV.hidden = NO;
                selfWeak.nothingnessView.hidden = YES;
            }
            
            [selfWeak.collectionV reloadData];
    });
    
}
-(void)updateTopicPost
{
    [self loadOne];
}

#pragma mark - 发布动态 发布话题
- (void)fabiaoAction:(id)sender {

    PublishTopicVC * ptVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishTopicVC"];
    [self.navigationController pushViewController:ptVC animated:YES];
    
}

#pragma mark - UICollectionViewDelgate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        Topic_Cell_2 * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topicCell_2" forIndexPath:indexPath];
        
        RecommendTopicModel * RTML = [activeArr objectAtIndex:indexPath.row];
        
        cell.numberLb.text = RTML.ctrcount;
        
        cell.titleLb.text = RTML.title;
        
        NSLog(@"%ld---%@",indexPath.row,RTML.userpic);
        
        [cell.headerImgV sd_setImageWithURL:[NSURL URLWithString:RTML.userpic] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageLowPriority];

        
        cell.indexPath =indexPath;
        [cell.guanzhuBtn setEnabled:YES];
//        [activeBtn setEnabled:YES];
        @WeakObj(self)
        cell.block =  ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            UIButton * guanzhuBtn = (UIButton *)view;
            activeBtn = guanzhuBtn;
            
            [guanzhuBtn setEnabled:NO];
            
            NSLog(@"indexPath.item=====%ld",indexPath.item);
            RecommendTopicModel * RTML_B = [activeArr objectAtIndex:indexPath.item];

//            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
//            [indicator startAnimating:self];
            if (!RTML_B.isfollow.boolValue) {
            
                NSLog(@"点击关注或取消关注");
                [PostPresenter addFollowTopic:RTML_B.recommendTopicID WithCallBack:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{

                       // [indicator stopAnimating];
                        if (resultCode == SucceedCode) {
                            RTML_B.isfollow = @"1";
                            [selfWeak updateTopicPost];
            
                            
                        }
                    });
                    
                }];
            }else
            {
                [PostPresenter removeFollowTopic:RTML_B.recommendTopicID WithCallBack:^(id  _Nullable data, ResultCode resultCode) {
                    
                      
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            //[indicator stopAnimating];

                            if (resultCode == SucceedCode) {

                                RTML_B.isfollow = @"0";
                                [selfWeak updateTopicPost];


                            }
                        });
                }];
                
            }
        };
        if (!RTML.isfollow.boolValue) {
            
            [cell.guanzhuBtn setTitle:@"加关注" forState:UIControlStateNormal];
            [cell.guanzhuBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
            
        }else
        {
            [cell.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [cell.guanzhuBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_已注"] forState:UIControlStateNormal];


        }
        cell.contentLb.text = RTML.remarks;
        return cell;

    
    }else  if (indexPath.section==1) {
    
        Topic_Cell_1 * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topicCell_1" forIndexPath:indexPath];
        RecommendTopicModel * RTML = [recentlyArr objectAtIndex:indexPath.row];
        cell.contentLb.text = RTML.title;
        
        return cell;

    }else{
        
        DynamicImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
        if (indexPath.section-2<(isAll ? topicPostArr:topicFollowArr).count) {
            TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:indexPath.section-2];
            
            if (indexPath.row<TPML.piclist.count) {
                NSDictionary * piclistDic = [TPML.piclist objectAtIndex:indexPath.row];
                [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[piclistDic objectForKey:@"fileurl"]] placeholderImage:PLACEHOLDER_IMAGE];
                NSLog(@"-url地址：-----%@",[piclistDic objectForKey:@"fileurl"]);
            }
    

        }
        return cell;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        if (isShowRecommend) {

            if(isAll){
                return CGSizeMake(SCREEN_WIDTH,40);
            }else
            {
                return CGSizeMake(SCREEN_WIDTH,0);
 
            }
        }else
        {
            return CGSizeMake(0, 0);
        }
    }else if (section==1) {
        if(activeArr!=nil)
        {
            return CGSizeMake(SCREEN_WIDTH, 100);
        }else
        {
            return CGSizeMake(SCREEN_WIDTH, 0);

        }
    }
    
    TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:section-2];

    if([TPML.isGG isEqualToString:@"1"]){
        return CGSizeMake(SCREEN_WIDTH,(SCREEN_WIDTH-20)/SCREEN_SCALE_GG);
        
    }
    return CGSizeMake(SCREEN_WIDTH, 56);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        if (isShowRecommend) {
            return CGSizeMake(SCREEN_WIDTH,40);

        }else
        {
            return CGSizeMake(0, 0);

        }
    }else if (section==1) {
        
        if (isShowFollow) {
            return CGSizeMake(SCREEN_WIDTH,40);
 
        }else
        {
            return CGSizeMake(0, 0);

        }
    }

    TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:section-2];
    
    if([TPML.isGG isEqualToString:@"1"]){
        return CGSizeMake(0,0);

    }
    if (TPML.cellHight>200) {
        return CGSizeMake(SCREEN_WIDTH, 200+95);

    }
    return CGSizeMake(SCREEN_WIDTH, TPML.cellHight+95);

    
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    if (section==0) {
        return 0.1;
    }
    if (section==1) {
        return 0.1;
    }
    return 0.1;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    if (section==0) {
        return 0.1;
    }
    if (section==1) {
        return 1;
    }
   

    return 0.1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        return CGSizeMake(SCREEN_WIDTH-20,80);
    }
    if (indexPath.section==1) {
        return CGSizeMake((SCREEN_WIDTH-20-1*2.0)/2.0,30);
    }
    
        TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:indexPath.section-2];
    
        switch (TPML.piclist.count) {
            case 0:
            {
                
                return CGSizeMake(0,0);
            }
                break;
            case 1:
            {
                return CGSizeMake(SCREEN_WIDTH-20,(SCREEN_WIDTH-20-15)/2.0f);
            }
                break;
            case 2:
            {
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*3)/2.0f,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
            }
                break;
            case 3:
            {
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);

            }
                break;
            case 4:
            {
                if (indexPath.row==3) {
                    
                    return CGSizeMake(SCREEN_WIDTH-20,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);

                }else
                {
                    return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
                }

            }
                break;
            case 5:
            {
                if (indexPath.row==3||indexPath.row==4) {
                    
                    return CGSizeMake((SCREEN_WIDTH-20-cell_interval*3)/2.0f,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
                    
                }else
                {
                    return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
                }

            }
                break;

            case 6:
            {
                
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
                
            }
                break;
            case 7:
            {
                
                if (indexPath.row==6) {
                    
                    return CGSizeMake(SCREEN_WIDTH-20,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
                    
                }else
                {
                    return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
                }
                

            }
                break;
            case 8:
            {
                if (indexPath.row==6||indexPath.row==7) {
                    
                    return CGSizeMake((SCREEN_WIDTH-20-cell_interval*3)/2.0f,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
                    
                }else
                {
                    return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
                }

            }
                break;
            case 9:
            {
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);

            }
                break;
            default:
            {
                return CGSizeMake(0,0);

            }
                break;
        }
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0) {
        
        return activeArr.count>5?5:activeArr.count;
    }
    if (section==1) {
        return recentlyArr.count>6?6:recentlyArr.count;
    }

    TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:section-2];
    return TPML.piclist.count;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0,0,0,0);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (isAll ? topicPostArr:topicFollowArr).count+2;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
         CollectionTitleV * circleTitleView  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"titleHeaderView"forIndexPath:indexPath];
        
        [circleTitleView setHidden:NO];
        
        switch (indexPath.section) {
            case 0:
            {
                if (isAll) {
                    circleTitleView.titleLb.text =  @"推荐";
                    [circleTitleView.titleImgBtn setImage:[UIImage imageNamed:@"邻圈_推荐_E"] forState:UIControlStateNormal];

                }else
                {
                    circleTitleView.titleLb.text =  @"关注";
                    [circleTitleView.titleImgBtn setImage:[UIImage imageNamed:@"邻圈_关注_已关注"] forState:UIControlStateNormal];

                }
                
                //lb.text = @"推荐";
                return circleTitleView;
            }
                break;
            case 1:
            {
                circleTitleView.titleLb.text = @"最近浏览";
                [circleTitleView.titleImgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

               // lb.text = @"关注";
                return circleTitleView;
            
            }
                break;
            default:
            {
                CircleHeaderView * circleHeaderView  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"forIndexPath:indexPath];
                [circleTitleView setHidden:YES];
                if (indexPath.section - 2<(isAll ? topicPostArr:topicFollowArr).count) {
                    
                    
                    TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:indexPath.section - 2];
                    [circleHeaderView.headerImgV sd_setImageWithURL:[NSURL URLWithString:TPML.userpic] placeholderImage:PLACEHOLDER_IMAGE];
                    
                   // [circleHeaderView.headerImgV setim]
                    if (TPML.sex.integerValue == 1) {
                        [circleHeaderView.sexImg setImage:[UIImage imageNamed:@"邻圈_男"]];
                        [circleHeaderView.sexAgeView setBackgroundColor:BLUE_TEXT_COLOR];
                        
                    }else{
                    
                        [circleHeaderView.sexImg setImage:[UIImage imageNamed:@"邻圈_女"]];
                        [circleHeaderView.sexAgeView setBackgroundColor:WOMEN_COLOR ];

                    }
                    circleHeaderView.ageLb.text = TPML.age;
                    circleHeaderView.nameLb.text = TPML.nickname;
                    circleHeaderView.xiaoquLb.text = TPML.communityname;
                    
                   NSString * newSystime = [TPML.systime substringWithRange:NSMakeRange(0,19)];
                   circleHeaderView.timeLb.text = [DateTimeUtils StringFromDateTime:[XYString  NSStringToDate:newSystime]];

                    
//                    circleHeaderView.timeLb.text = [DateTimeUtils StringToDateTime:TPML.systime];
                    circleHeaderView.contentLb.text = TPML.content;
                    
                   // circleHeaderView.contentLb.attributedText = TPML.contentAttriStr;
                    circleHeaderView.titleLb.text = TPML.title;
                    circleHeaderView.indexPath = indexPath;
                    [circleTitleView setHidden:YES];
                    circleHeaderView.contentBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
                        NSString * typeStr = data;
                        
                       
                        TopicPostModel * TPML_1 = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:index.section - 2];

                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        NSString * urlStr;
                        
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        
                        if (typeStr.integerValue == 1) {
                            
                            urlStr = TPML_1.topicgotourl;
                            webVc.isShowRightBtn=YES;
                            webVc.shareTypes=4;
                            webVc.shareUr=urlStr;
                            
                            webVc.type= 1;
                            webVc.topicid = TPML_1.topicid;
                            
                        }else if (typeStr.integerValue == 2) {
                            
                            urlStr = TPML_1.postsgotourl;
                            webVc.isShowRightBtn=YES;
                            webVc.shareTypes=4;
                            webVc.shareUr=urlStr;
                            webVc.type = 2;
                            webVc.TPML = TPML_1;

                        }
                        //AppDelegate *appDlgt=GetAppDelegates;
                        if([urlStr hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@",urlStr,appDlgt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@",urlStr,appDlgt.userData.token];
                        }
                        
//                        webVc.url = TPML_1.gotourl;
                        webVc.title = TPML_1.webtitle;
                        [self.navigationController pushViewController:webVc animated:YES];

                    };
                    circleHeaderView.headerBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
                        
                        if([appDlgt.userData.userID isEqualToString:TPML.userid])
                        {
                            THMySettingsVC *mySettingVC  = [[THMySettingsVC alloc]init];
                            [mySettingVC setHidesBottomBarWhenPushed:YES];
                            [self.navigationController pushViewController:mySettingVC animated:YES];

                        }else{
                        
                            PersonalDataVC * pdVC = [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalDataVC"];
                            pdVC.userID = TPML.userid;
                            [self.navigationController pushViewController:pdVC animated:YES];
                        }
                    };
                }
                
                return circleHeaderView;
            }
                break;
        }
        
    }else if([kind isEqual:UICollectionElementKindSectionFooter]){
        
        if (indexPath.section == 0) {
            TopicFooterView * topicFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerNextView"forIndexPath:indexPath];
            topicFooterView.nextBtn.hidden = !isAll;
            topicFooterView.nextLineImg.hidden = !isAll;
            
            @WeakObj(self);
            topicFooterView.block = ^(id  _Nullable data,ResultCode resultCode)
            {
                ///换一组
                NSLog(@"-----------当前第%@页",currentPage);
                
                currentPage = [NSString stringWithFormat:@"%d",currentPage.intValue+1];
                [PostPresenter getRecommendTopic:currentPage:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                        if (resultCode == SucceedCode) {
                            recommendArr = data;
                            isShowRecommend = YES;
                            activeArr = recommendArr;
                            if(activeArr.count<5||currentPage.intValue>=10)
                            {
                                
                                currentPage = @"0";
                            
                            }
                            [selfWeak.collectionV reloadData];

                        }else
                        {
                            recommendArr = nil;
                            activeArr = recommendArr;
                            currentPage = @"1";
                            isShowRecommend = NO;
                            [selfWeak.collectionV reloadData];
                        }
                        
                    });
                    
                }];

            };
            
            return topicFooterView;
            
        }else if (indexPath.section== 1) {
            
            LineBtnFooterView* followFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineBtnFooterView"forIndexPath:indexPath];
            if (isAll) {
                [followFooterView.checkBtn setTitle:@"查看全部圈子" forState:UIControlStateNormal];
 
            }else
            {
                [followFooterView.checkBtn setTitle:@"查看全部" forState:UIControlStateNormal];
            }
            @WeakObj(self);
            followFooterView.block = ^(id  _Nullable data,ResultCode resultCode)
            {
                if (isAll) {
                    
                    AllCircleListVC * alVC =[self.storyboard instantiateViewControllerWithIdentifier:@"AllCircleListVC"];
                    [selfWeak.navigationController pushViewController:alVC animated:YES];

                }else
                {
                    FollowCircleListVC * flVC =[self.storyboard instantiateViewControllerWithIdentifier:@"FollowCircleListVC"];

                    [selfWeak.navigationController pushViewController:flVC animated:YES];

                }
            };
            
            return followFooterView;

            
        }else  if (indexPath.section>=2&&indexPath.section - 2<(isAll ? topicPostArr:topicFollowArr).count) {
            
            
            TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:indexPath.section - 2];
            
            
            ///帖子
            CircleFooterView *circleFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell"forIndexPath:indexPath];

            ///广告
            GGFooterView * ggfooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GGFooterView"forIndexPath:indexPath];
            
            if(![TPML.isGG isEqualToString:@"1"])
            {
                [ggfooterView setHidden:YES];
                [circleFooterView setHidden:NO];
                
                circleFooterView.praiseCountLB.text = TPML.praisecount;
                circleFooterView.replayCountLB.text = TPML.commentcount;
                if(TPML.ispraised.boolValue){
                    
                    [circleFooterView.praiseBtn setImage:[UIImage imageNamed:@"邻圈_已点赞"] forState:UIControlStateNormal];
                    
                }else
                {
                    [circleFooterView.praiseBtn setImage:[UIImage imageNamed:@"邻圈_点赞"] forState:UIControlStateNormal];
                    
                }
                
                
                circleFooterView.indexPath = indexPath;
                
                ///评论
                circleFooterView.replayBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
                {
                    TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:index.section - 2];
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    webVc.isShowRightBtn=YES;
                    webVc.shareTypes=4;
                    
                    //            AppDelegate *appDlgt=GetAppDelegates;
                    if([TPML.postsgotourl hasSuffix:@".html"])
                    {
                        webVc.url=[NSString stringWithFormat:@"%@?token=%@",TPML.postsgotourl,appDlgt.userData.token];
                    }
                    else
                    {
                        webVc.url=[NSString stringWithFormat:@"%@&token=%@",TPML.postsgotourl,appDlgt.userData.token];
                    }
                    //            webVc.url = TPML.postsgotourl;
                    webVc.title = TPML.webtitle;
                    [self.navigationController pushViewController:webVc animated:YES];
                    
                };
                ///点赞
                @WeakObj(self)
                @WeakObj(circleFooterView)
                
                circleFooterView.praiseBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
                {
                    [circleFooterViewWeak.praiseBtn setEnabled:NO];
                    TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:index.section - 2];
                    if(TPML.ispraised.boolValue){
                        [PostPresenter removeTopicPraise:^(id  _Nullable data, ResultCode resultCode) {
                            
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [circleFooterViewWeak.praiseBtn setEnabled:YES];
                                
                                TPML.ispraised = @"0";
                                TPML.praisecount = [NSString stringWithFormat:@"%ld",(long)(TPML.praisecount.integerValue -1)];
                                //                        [selfWeak.collectionV reloadItemsAtIndexPaths:@[index]];
                                [selfWeak.collectionV reloadSections:[NSIndexSet indexSetWithIndex:index.section]];
                                
                            });
                            
                        } withTopicID:TPML.postsid];
                        
                    }else
                    {
                        [PostPresenter addTopicPraise:^(id  _Nullable data, ResultCode resultCode) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [circleFooterViewWeak.praiseBtn setEnabled:YES];
                                
                                TPML.ispraised = @"1";
                                TPML.praisecount = [NSString stringWithFormat:@"%ld",(long)(TPML.praisecount.integerValue +1)];
                                
                                [selfWeak.collectionV reloadSections:[NSIndexSet indexSetWithIndex:index.section]];
                                
                            });
                            
                        } withTopicID:TPML.postsid];
                    }
                };
                ///举报
                circleFooterView.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
                {
                    
                    TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:index.section - 2];
                    NSArray * oneArr;
                    if ([appDlgt.userData.userID isEqualToString:TPML.userid]||TPML.isowner.boolValue) {
                        oneArr = @[@"转发",@"删除",@"取消"];
                    }else
                    {
                        oneArr = @[@"转发",@"举报",@"取消"];
                    }
                    
                    [ActionSheetVC shareActionSheet].data = oneArr;
                    [[ActionSheetVC shareActionSheet] showInVC:self];
                    [ActionSheetVC shareActionSheet].block = ^(id  data,UIView * view,NSIndexPath * index)
                    {
                        NSLog(@"----%ld----",index.row);
                        if (index.row == 1) {
                            
                            [[ActionSheetVC shareActionSheet] dismiss];
                            ///判断是否是自己的帖子
                            if([appDlgt.userData.userID isEqualToString:TPML.userid])
                            {
                                
                                [[MessageAlert shareMessageAlert] showInVC:selfWeak withTitle:@"确定删除此条贴子吗？" andCancelBtnTitle:@"取消" andOtherBtnTitle:@"确定"];
                                [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                                {
                                    if (index==Ok_Type) {
                                        NSLog(@"---点击删除");
                                        [PostPresenter removeTopicPosts:^(id  _Nullable data, ResultCode resultCode) {
                                            dispatch_sync(dispatch_get_main_queue(), ^{
                                                
                                                if (resultCode == SucceedCode) {
                                                    
                                                    [(isAll ? topicPostArr:topicFollowArr) removeObject:TPML];
                                                    
                                                    [selfWeak showToastMsg:@"删除成功！" Duration:2.5f];
                                                    [selfWeak.collectionV reloadData];
                                                    
                                                }
                                            });
                                            
                                            
                                            
                                        } withTopicID:TPML.postsid withReason:@""];
                                        
                                        
                                    }
                                };
                                return ;

                            }
                            ///判断是否是圈主
                            if(TPML.isowner.boolValue){
                                
                                delModel = TPML;
                                [[MessageInputAlert shareMessageInputAlert]show:self];
                                [MessageInputAlert shareMessageInputAlert].block = ^(id  _Nullable data,ResultCode resultCode)
                                {
                                  
                                    if (resultCode == 1) {
                                        NSString *reason = data;
                                        
                                        NSLog(@"---点击删除");
                                        [PostPresenter removeTopicPosts:^(id  _Nullable data, ResultCode resultCode) {
                                            dispatch_sync(dispatch_get_main_queue(), ^{
                                                
                                                if (resultCode == SucceedCode) {
                                                    
                                                    [(isAll ? topicPostArr:topicFollowArr) removeObject:delModel];
                                                    [selfWeak showToastMsg:@"删除成功！" Duration:2.5f];
                                                    [selfWeak.collectionV reloadData];
                                                    
                                                }
                                                
                                            });
                                        } withTopicID:delModel.postsid withReason:reason];
                                    }
                                    
                                };
                                
//                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入删除原因" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//                                 [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//                                [alertView show];
//                                UITextField * tf = [alertView textFieldAtIndex:0];
//                                alertView.delegate = self;
//                                 tf.placeholder = @"请输入删除原因";
//                                
                                
                                return ;

                            }
                            [ActionSheetVC shareActionSheet].data = @[@"骚扰信息",@"虚假身份",@"广告欺诈",@"不当发言",@"取消"];
                            [[ActionSheetVC shareActionSheet] updateTable];
                            [ActionSheetVC shareActionSheet].block = ^(id  data,UIView * view,NSIndexPath * index)
                            {
                                [[ActionSheetVC shareActionSheet] dismiss];
                                
                                if (![XYString isBlankString:TPML.userid]) {
                                    if (index.row < 4) {
                                        
                                        [PostPresenter addPostsReport:TPML.postsid withType:[NSString stringWithFormat:@"%ld",index.row] andSource:@"1" andCallBack:^(id  _Nullable data, ResultCode resultCode) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                if(resultCode == SucceedCode)
                                                {
                                                    [selfWeak showToastMsg:@"举报成功" Duration:2.0];
                                                }
                                                else
                                                {
                                                    [selfWeak showToastMsg:@"举报失败" Duration:2.0];
                                                }
                                            });
                                        }];
                                    }
                                }
                            };
                            
                        }else if(index.row == 0)
                        {
                            
                            //分享应用
                            ShareContentModel * SCML = [[ShareContentModel alloc]init];
                            SCML.shareTitle = TPML.content_ls;
                            SCML.shareImg=SHARE_LOGO_IMAGE;
                            if(TPML.piclist.count>0)
                            {
                                NSString * url = [[TPML.piclist firstObject] objectForKey:@"fileurl"];;
                                SCML.shareImg = url;
                                
                            }
                            
                            SCML.shareContext = @" ";
                            SCML.shareUrl= TPML.postsgotourl;
                            SCML.type = 4;
                            SCML.shareSuperView = self.view;
                            SCML.shareType = SSDKContentTypeWebPage;
                            //                    SCML.shareType = SSDKContentTypeAuto;
                            [SharePresenter creatShareSDKcontent:SCML];
                            
                            [[ActionSheetVC shareActionSheet] dismiss];
                        }else
                        {
                            [[ActionSheetVC shareActionSheet] dismiss];
                            
                        }
                    };
                    
                };
                return circleFooterView;

            }else
            {
                
                [ggfooterView setHidden:NO];
                [circleFooterView setHidden:YES];
                @WeakObj(self);
                
                [ggfooterView.imgV sd_setImageWithURL:[NSURL URLWithString:TPML.picurl] placeholderImage:PLACEHOLDER_IMAGE];
                ggfooterView.type = indexPath.section-2;
                ggfooterView.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                {
                    
                    if (index == 0) {
                       
                        [topicPostArr removeObject:GG_TPML_TOP];
                    }else
                    {
                        [topicPostArr removeObject:GG_TPML_MIDDLE];
 
                    }
                    
                    [selfWeak.collectionV reloadData];
                };
                ggfooterView.img_block =  ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                {
                    NSString * gotoUrl = @"";
                    
                    
                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                    
                    
                    if (index == 0) {
                        
                        gotoUrl =  GG_TPML_TOP.gotourl;
                        webVc.title = GG_TPML_TOP.title;

                    }else
                    {
                        gotoUrl =  GG_TPML_MIDDLE.gotourl;
                        webVc.title = GG_TPML_MIDDLE.title;

                    }

                    if([gotoUrl hasSuffix:@".html"])
                    {
                        webVc.url=[NSString stringWithFormat:@"%@?token=%@",gotoUrl,appDlgt.userData.token];
                    }
                    else
                    {
                        webVc.url=[NSString stringWithFormat:@"%@&token=%@",gotoUrl,appDlgt.userData.token];
                    }
                    
                    [selfWeak.navigationController pushViewController:webVc animated:YES];


                };
                
                return ggfooterView;
                
            }
        
            
        }else{
            
            return [UICollectionReusableView new];
        }
        
    }else{
    
        return [UICollectionReusableView new];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        
        RecommendTopicModel * RTML = [activeArr objectAtIndex:indexPath.row];
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
        
//        AppDelegate *appDlgt=GetAppDelegates;
        
        if([RTML.topicgotourl hasSuffix:@".html"])
        {
            webVc.url=[NSString stringWithFormat:@"%@?token=%@",RTML.topicgotourl,appDlgt.userData.token];
        }
        else
        {
            webVc.url=[NSString stringWithFormat:@"%@&token=%@",RTML.topicgotourl,appDlgt.userData.token];
        }
//        webVc.url   = RTML.topicgotourl;
        
        webVc.type= 1;
        webVc.topicid = RTML.recommendTopicID;

        webVc.shareUr=RTML.topicgotourl;
        webVc.title = RTML.title;
        webVc.isShowRightBtn=YES;
        webVc.shareTypes=4;
        [self.navigationController pushViewController:webVc animated:YES];

        
    }else if (indexPath.section ==1) {
        RecommendTopicModel * RTML = [recentlyArr objectAtIndex:indexPath.row];

        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//        AppDelegate *appDlgt=GetAppDelegates;
        if([RTML.topicgotourl hasSuffix:@".html"])
        {
            webVc.url=[NSString stringWithFormat:@"%@?token=%@",RTML.topicgotourl,appDlgt.userData.token];
        }
        else
        {
            webVc.url=[NSString stringWithFormat:@"%@&token=%@",RTML.topicgotourl,appDlgt.userData.token];
        }
//        webVc.url   = RTML.topicgotourl;
        webVc.type= 1;
        webVc.topicid = RTML.recommendTopicID;

        webVc.title = RTML.title;
        webVc.shareUr=RTML.topicgotourl;
        webVc.isShowRightBtn=YES;
        webVc.shareTypes=4;
        [self.navigationController pushViewController:webVc animated:YES];

    }else if (indexPath.section >= 2) {
        
        DynamicImgCell * cell = (DynamicImgCell * )[collectionView cellForItemAtIndexPath:indexPath];
        [self tapPicture:indexPath tapView:cell.imgV];
        
    }
    
}
#pragma mark - 点击图片放大
-(void)tapPicture :(NSIndexPath *)index
          tapView :(UIImageView *)tapView
{
    
    TopicPostModel * TPML = [(isAll ? topicPostArr:topicFollowArr) objectAtIndex:index.section - 2];
    NSInteger count = TPML.piclist.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        
        NSString *url;
        url = [[TPML.piclist objectAtIndex:i] objectForKey:@"fileurl"];;
        [photos addObject:url];
        
    }
    self.imageList = photos;
    SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
    browser.sourceImagesContainerView = tapView;
    browser.imageCount = count;
    browser.currentImageIndex = index.row;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
    
}

// 返回临时占位图片（即原来的小图）
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
//    return PLACEHOLDER_IMAGE;
//}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    return [NSURL URLWithString:self.imageList[index]];
}

#pragma  mark ------------推送消息处理-----------
-(void)subReceivePushMessages:(NSNotification *)aNotification
{
    [self setBadges];
}
///设置消息标记
-(void)setBadges
{
    ///帖子
    PushMsgModel * pushMsg = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.BBSMsg];
    if (pushMsg!=nil) {
        NSInteger tmp=pushMsg.countMsg.integerValue;
        if(tmp>0)
        {
            ////处理投诉显示标记
            [self receiveNewMsg];
        }
    }
    MainTabBars *tab=(MainTabBars *)self.tabBarController;
    [tab setTabBarBadges];
    
}
-(void)receiveNewMsg
{
    ///30001-30007
    @WeakObj(self)
    @WeakObj(lb_num)
    [PostPresenter getMsgCount:^(id  _Nullable data, ResultCode resultCode) {
        
        if (resultCode == SucceedCode) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [selfWeak.messageMenu setHidden:NO];
                if (((NSString *)data).intValue > 0) {
                    lb_numWeak.text = data;
                    self.messageMenu.hidden = NO;
                    
                }else {
                    self.messageMenu.hidden = YES;
                    
                    PushMsgModel * pushMsg = (PushMsgModel *)[UserDefaultsStorage getDataforKey:appDlgt.BBSMsg];
                    pushMsg.countMsg = @0;
                    [UserDefaultsStorage saveData:pushMsg forKey:appDlgt.BBSMsg];

                }
                
            });
            
        }
        
    }];

}

#pragma mark - 切换全部与关注
- (IBAction)titleClickAction:(id)sender {
    
    UIButton * temp_btn = (UIButton *)sender;
    self.nothingnessView.hidden = YES;
    self.collectionV.hidden = NO;

    if (temp_btn.tag == 1000) {
        
        isAll = YES;
        isShowFollow = YES;
        activeArr = recommendArr;
        //点击全部
        [self.left_title_btn setTitleColor:TABBAR_COLOR forState:UIControlStateNormal];
        [self.left_title_btn setSelected:YES];
        [self.left_title_btn setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.right_title_btn setTitleColor:UIColorFromRGB(0x8e8e8e) forState:UIControlStateNormal];
        [self.right_title_btn setSelected:NO];
        [self.right_title_btn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        
    }else if(temp_btn.tag == 1001)
    {
        
        isAll = NO;
        isShowFollow = NO;
        recentlyArr = nil;
        activeArr = followRecommendArr;
        //点击关注
        [self.right_title_btn setTitleColor:TABBAR_COLOR forState:UIControlStateNormal];
        [self.right_title_btn setSelected:YES];
        [self.right_title_btn setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.left_title_btn setTitleColor:UIColorFromRGB(0x8e8e8e) forState:UIControlStateNormal];
        [self.left_title_btn setSelected:NO];
        [self.left_title_btn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        
    }
    ///此处是为了清空残留数据
    
//    [self.collectionV reloadData];
    [self loadOne];
//    [self.collectionV reloadData];
}
#pragma mark - 创建圈子
- (IBAction)createQuanZi:(id)sender {
    
    PublishTopicVC * ptVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishTopicVC"];
    [self.navigationController pushViewController:ptVC animated:YES];
    
}
#pragma mark - 创建帖子
- (IBAction)publishTieZi:(id)sender {
    
    PublishPostVC * ppVC =[[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"PublishPostVC"];
    ppVC.navigationItem.title = @"随便聊聊";
    ppVC.topicID = @"";
    [self.navigationController pushViewController:ppVC animated:YES];
    
}

@end
