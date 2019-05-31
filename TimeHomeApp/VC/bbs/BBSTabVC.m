//
//  BBSTabVC.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
#import "AppPayPresenter.h"

#import "MainTabBars.h"

#import "BBSTabVC.h"
#import "BBSModel.h"
#import "SDCycleScrollView.h"//轮播图
#import "AppSystemSetPresenters.h"
#import "PostingVC.h"//发帖弹出窗
#import "BBSSearchViewController.h"//搜索界面
#import "ChangAreaVC.h"
#import "ChatViewController.h"
#import "BBSMainPresenters.h"
#import "PraiseListVC.h"
#import "WebViewVC.h"

#import "CommunityListViewController.h"
#import "personListViewController.h"
#import "HouseOrCarViewController.h"

#import "L_NewMinePresenters.h"

//------------普通帖cell--------------
#import "BBSNormalTableViewCell.h"
#import "BBSNormal2TableViewCell.h"
#import "BBSNormal1TableViewCell.h"
#import "BBSNormal0TableViewCell.h"
//------------广告帖cell--------------
#import "BBSAdvertTableViewCell.h"
#import "BBSAdvert2TableViewCell.h"
#import "BBSAdvert1TableViewCell.h"
#import "BBSAdvert0TableViewCell.h"
//------------投票贴cell--------------
#import "BBSVotePICTableViewCell.h"
#import "BBSVotePIC2TableViewCell.h"
#import "BBSVoteTextTableViewCell.h"
#import "BBSVoteText2TableViewCell.h"
//------------问答帖cell--------------
#import "BBSQuestionPICTableViewCell.h"
#import "BBSQuestionPIC2TableViewCell.h"
#import "BBSQuestionPIC1TableViewCell.h"
#import "BBSQuestionNoPICTableViewCell.h"
//------------商品帖cell--------------
#import "BBSCommodityTableViewCell.h"
#import "BBSCommodity2TableViewCell.h"
#import "BBSCommodity1TableViewCell.h"
//------------房产帖cell--------------
#import "BBSHouseTableViewCell.h"
#import "BBSHouse2TableViewCell.h"
#import "BBSHouse1TableViewCell.h"
#import "BBSHouse0TableViewCell.h"

#import "L_NewBikeInfoViewController.h"

#import "L_NormalDetailsViewController.h"
#import "L_HouseDetailsViewController.h"
#import "BBSQusetionViewController.h"

#import "L_BBSVisitorsListViewController.h"

#import "XLBubbleTransition.h"

#import "L_ShareActivityTVC.h"

@interface BBSTabVC () <SDCycleScrollViewDelegate,UITableViewDelegate, UITableViewDataSource,changeAreaDelegate>
{
    
    AppDelegate *appDlgt;
    
    NSMutableArray *dataArray;
    
    UIView *holdView;
    
    UILabel *navigationLeft;
    
    NSArray *advArray;
    
    UITableView *tableView_;
    
    CGFloat newoffsetY;
    
    UIButton *newBt;//标签栏最新按钮
    
    UIButton *imageBt;//标签栏图说按钮
    
    UIButton *cityBt;//标签栏全城按钮
    
    UIButton *myBt;//标签栏我的按钮
    
    UIView *bottomRed;//标签栏底部红色标识线
    
    NSDictionary *topDict;//banner数据源
    
    NSArray *bannerArray;//banner数据源
    
    NSArray *tagArr;//标签栏数据源
    
    NSString *area;
    
    NSString *contype;
    
    UIView *headerView;
    
    UIView *tagView;
    
    UIImageView *left;
    
    UIScrollView *tagScrollView;//标签栏滚动视图
    
    UIView *person;//活跃用户视图
    
    NSArray *personArr;//活跃用户数据源
    
    UIButton *top;//滚动到顶部按钮
    
    NSInteger listType;//切换列表类型
    
    UIPageControl *page;
    
    NSInteger pageNo;
    
    CGRect lastRect;
}

@property (nonatomic, assign)CGFloat marginTop;

@property (nonatomic, strong) UIButton *tabbarTop_Button;

@property (nonatomic,strong) SDCycleScrollView *cycleBannerView;//轮播图
@end

@implementation BBSTabVC

#pragma mark - LifeCycle

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"linqushouye"];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc {
    NSLog(@"BBSTabVC被释放了");
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /** rootViewController不允许侧滑 */
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageNo = 1;
    
    listType = 2;
    
    dataArray = [[NSMutableArray alloc]init];
    
    appDlgt = GetAppDelegates;
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setDictionary:[UserDefaultsStorage getDataforKey:@"cityDataArr"]];
    NSMutableArray *mutableArr = [NSMutableArray array];
    [mutableArr addObjectsFromArray:mutableDict[appDlgt.userData.communityid]];
    dataArray = [BBSModel mj_objectArrayWithKeyValuesArray:mutableArr];
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configNavigaiton];
        [self configUI];
    });
}

#pragma mark - initUI
- (void)configUI {
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake( 10, 0, SCREEN_WIDTH - 2 * 10, 300)];
    headerView.backgroundColor = [UIColor clearColor];
    
    // ---------------banner
    [headerView addSubview:self.cycleBannerView];
    
    // ---------------标签
    [self setTag];
    
    //--------------活跃用户
    [self setPerson];
    
    headerView.frame = CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, headerView.frame.size.width, person.frame.origin.y + person.frame.size.height + 5);
    
    tableView_= [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 2 * 10, SCREEN_HEIGHT - (44+statuBar_Height) - 49) style:UITableViewStylePlain];
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.showsVerticalScrollIndicator = NO;
    //tableView_.scrollEnabled = NO;
    [self.view addSubview:tableView_];
    
    tableView_.tableHeaderView = headerView;
    
    holdView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height + 55, tableView_.frame.size.width, tableView_.frame.size.height - 55)];
    holdView.backgroundColor = [UIColor clearColor];
    holdView.userInteractionEnabled = YES;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake( 30,(self.view.frame.size.height - holdView.frame.origin.y - 49) / 3, holdView.frame.size.width - 30 * 2, 80)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.contentMode = UIViewContentModeCenter;
    imgView.image = [UIImage imageNamed:@"新版-无帖子"];
    [holdView addSubview:imgView];
    
    UILabel *errLal = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + 30, imgView.frame.size.width, 20)];
    errLal.text = @"当前社区还没有人发帖，赶快点击发帖，和大家打个招呼吧！";
    errLal.font = [UIFont systemFontOfSize:15];
    errLal.textColor = [UIColor blackColor];
    errLal.textAlignment = NSTextAlignmentCenter;
    [errLal setNumberOfLines:0];
    [errLal sizeToFit];
    [holdView addSubview:errLal];
    
    holdView.hidden = YES;
    holdView.alpha = 0;
    
    [tableView_ addSubview:holdView];
    
    area = @"-3";
    contype = @"0";
    
    //--------------固定按钮
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"发贴按钮"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishBtn];
    if (SCREEN_HEIGHT >= 812){
        [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@72);
            make.height.equalTo(@72);
            make.right.equalTo(tableView_.mas_right).offset(-30);
            make.bottom.equalTo(tableView_.mas_bottom).offset(-30 - bottomSafeArea_Height);
        }];
    }else {
        [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@72);
            make.height.equalTo(@72);
            make.right.equalTo(tableView_.mas_right).offset(-30);
            make.bottom.equalTo(tableView_.mas_bottom).offset(-30);
            
        }];
    }
    
    /////////////////普通帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormalTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal0TableViewCell"];
    
    /////////////////广告帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvertTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvertTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert0TableViewCell"];
    
    /////////////////投票帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVotePICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePICTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVotePIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePIC2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVoteTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteTextTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVoteText2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteText2TableViewCell"];
    
    /////////////////问答帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPICTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPIC1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionNoPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionNoPICTableViewCell"];
    
    /////////////////商品帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodityTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodity2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodity1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity1TableViewCell"];
    
    /////////////////房产帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouseTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse0TableViewCell"];
    
    [tableView_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [tableView_ registerNib:[UINib nibWithNibName:@"L_ShareActivityTVC" bundle:nil] forCellReuseIdentifier:@"L_ShareActivityTVC"];
    
    
    @WeakObj(self);
    
    tableView_.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        
        pageNo = 1;
        [selfWeak getHeaderData];
        [selfWeak getListData];
    }];
    
    tableView_.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNo = pageNo + 1;
        [selfWeak getListData];
    }];
    
    [tableView_.mj_footer setAutomaticallyHidden:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [tableView_ reloadData];
        
        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
        
        [self getListData];
        
        
    });
    
}

-(SDCycleScrollView *)cycleBannerView{
    if (!_cycleBannerView) {
        _cycleBannerView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth-20, (kScreenWidth-20)/2.2) imageNamesGroup:nil];
        _cycleBannerView.delegate = self;
        _cycleBannerView.autoScroll = NO;
        _cycleBannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleBannerView.placeholderImage = [UIImage imageNamed:@"图片加载失败@2x.png"];
    }
    return _cycleBannerView;
}

#pragma mark - 点赞、取消点赞请求
- (void)httpRequestForPraiseOrNot:(NSInteger)isPraise withPostid:(NSString *)postid callBack:(void(^)(NSInteger praiseCount))callBack {
    
    [L_NewMinePresenters addPraiseType:isPraise withPostid:postid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (resultCode == SucceedCode) {
                
                NSString *count = [NSString stringWithFormat:@"%@",[[data objectForKey:@"map"] objectForKey:@"praisecount"]];
                
                [self showToastMsg:[data objectForKey:@"errmsg"] Duration:3.0];

                if ([count isKindOfClass:[NSString class]]) {
                    
                    NSInteger praiseNum = 0;
                    if (count.integerValue >= 0) {
                        praiseNum = count.integerValue;
                        if (callBack) {
                            callBack(praiseNum);
                        }
                    }

                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

#pragma mark - network method
///获取顶部轮播图，活跃用户，热门标签数据
-(void)getHeaderData{
    [BBSMainPresenters getTopInfo:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            topDict = nil;
            if(resultCode==SucceedCode){
                topDict=(NSDictionary *)data;
                
                UIImageView *imageView;
                NSURL *url;
                NSMutableArray *viewsArray=[[NSMutableArray alloc]init];
                
                NSArray *banArr = topDict[@"bannerlist"];
                tagArr = topDict[@"tagslist"];
                personArr = topDict[@"topuserlist"];
                
                if(banArr.count > 0){
                    bannerArray = banArr;
                    [UserDefaultsStorage saveCustomArray:bannerArray forKey:@"bannerArray"];
                    NSDictionary * dic;
                    NSMutableArray *urlArray = [NSMutableArray array];
                    for(int i=0;i<bannerArray.count;i++){
                        dic=[bannerArray objectAtIndex:i];
                        imageView = [[UIImageView alloc] init];
                        url = [NSURL URLWithString:[dic objectForKey:@"picurl"]];
                        [urlArray addObject:url];
                        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
                        [viewsArray addObject:imageView];
                        
                    }
                    self.cycleBannerView.imageURLStringsGroup = urlArray;

                    if (bannerArray.count > 1) {
                        self.cycleBannerView.autoScroll = YES;
                    }
                }else{
                    NSArray *images = @[
                                        @"社区轮播图@2x.png",
                                        ];
                    self.cycleBannerView.autoScroll = NO;
                    self.cycleBannerView.localizationImageNamesGroup = images;
                }
                
                [self setTag];
                
                [self setPerson];
                
                headerView.frame = CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, headerView.frame.size.width, person.frame.origin.y + person.frame.size.height + 5);
                holdView.frame = CGRectMake(0, headerView.frame.size.height + 55, holdView.frame.size.width, holdView.frame.size.height);
                tableView_.tableHeaderView = headerView;
            }else{}
            
        });
    }];
}
-(void)getListData{
//    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
//    [indicator startAnimating:self.tabBarController];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",pageNo];
 //   [BBSMainPresenters getPostList:@"0" userid:@"" sortkey:@"new" contype:@"0" posttype:@"-1" poststate:@"-999" iscollect:@"0" isuserfollow:@"-1" tagsname:title_ pagesize:@"20" page:pageStr updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
    
    [BBSMainPresenters getPostList:area userid:@"" sortkey:@"new" contype:contype posttype:@"-1" poststate:@"-999" iscollect:@"0" isuserfollow:@"-1" tagsname:@"" pagesize:@"20" page:pageStr communityid:@"" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        [USER_DEFAULT setObject:@"no" forKey:DELETE_LIST_VALUE_OK];
        [USER_DEFAULT synchronize];
        [USER_DEFAULT setObject:@"no" forKey:NOTICE_REFRESH_EDIT_DATA];
        [USER_DEFAULT synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
            
            //[indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
    
//                [scroll.pullToRefreshView stopAnimating];
                
                if (tableView_.mj_header.isRefreshing) {
                    [tableView_.mj_header endRefreshing];
                }
                
//                [tableView_.infiniteScrollingView stopAnimating];
                
                if (tableView_.mj_footer.isRefreshing) {
                    [tableView_.mj_footer endRefreshing];
                }
                
                
                if (listType == 0) {//最新列表
                    
                    if (pageNo == 1){
                        
                        [dataArray removeAllObjects];
                        [dataArray addObjectsFromArray:data];

                        NSArray *arr = [BBSModel mj_keyValuesArrayWithObjectArray:dataArray];
                        
                        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                        [mutableDict setDictionary:[UserDefaultsStorage getDataforKey:@"newDataArr"]];
                        
                        [mutableDict removeObjectForKey:appDlgt.userData.communityid];
                        [mutableDict setObject:arr forKey:appDlgt.userData.communityid];
                        
                        [UserDefaultsStorage saveCustomArray:mutableDict forKey :@"newDataArr"];
                        
                        //[dataArray removeAllObjects];
                            
                        [tableView_ reloadData];
    
                        [self getAdvData];

                    }else{
                        
                        NSArray * tmparr = (NSArray *)data;
                        
                        if (tmparr.count == 0) {
                            
                            pageNo = pageNo - 1;
                        }else{
                            
                            NSInteger count = dataArray.count;
                            [dataArray addObjectsFromArray:tmparr];
                            
                            NSMutableArray *insertIndexPaths = [[NSMutableArray alloc]init];
                            for (int i = 0; i < tmparr.count; i++) {
                                NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                                [insertIndexPaths addObject:newPath];
                            }
//                            [tableView_ beginUpdates];
//                            [tableView_ insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//                            [tableView_ endUpdates];
                            
                            [tableView_ reloadData];
//                            if (insertIndexPaths.count > 0) {
//
//                                [tableView_ scrollToRowAtIndexPath:insertIndexPaths[0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                            }
                        }
                    }
                }else if (listType == 1){
                    
                    if (pageNo == 1){
                        
                        [dataArray removeAllObjects];
                        [dataArray addObjectsFromArray:data];
                        NSArray *arr = [BBSModel mj_keyValuesArrayWithObjectArray:dataArray];
                        
                        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                        [mutableDict setDictionary:[UserDefaultsStorage getDataforKey:@"picDataArr"]];
                        
                        [mutableDict removeObjectForKey:appDlgt.userData.communityid];
                        [mutableDict setObject:arr forKey:appDlgt.userData.communityid];
                        
                        [UserDefaultsStorage saveCustomArray:mutableDict forKey :@"picDataArr"];
                    
                        [tableView_ reloadData];
                    }else{
                        
                        NSArray * tmparr = (NSArray *)data;
                        if (tmparr.count == 0) {
                            pageNo = pageNo - 1;
                        }else{
                            
                            NSInteger count = dataArray.count;
                            [dataArray addObjectsFromArray:tmparr];
                            
                            NSMutableArray *insertIndexPaths = [[NSMutableArray alloc]init];
                            for (int i = 0; i < tmparr.count; i++) {
                                NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                                [insertIndexPaths addObject:newPath];
                            }
//                            [tableView_ beginUpdates];
//                            [tableView_ insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//                            [tableView_ endUpdates];
                            [tableView_ reloadData];
//                            if (insertIndexPaths.count > 0) {
//
//                                [tableView_ scrollToRowAtIndexPath:insertIndexPaths[0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                            }
                        }
                    }
                }else if (listType == 2){
                    
                    if (pageNo == 1){
                        
                        [dataArray removeAllObjects];
                        [dataArray addObjectsFromArray:data];
                        NSArray *arr = [BBSModel mj_keyValuesArrayWithObjectArray:dataArray];
                        
                        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
                        [mutableDict setDictionary:[UserDefaultsStorage getDataforKey:@"cityDataArr"]];
                        
                        [mutableDict removeObjectForKey:appDlgt.userData.communityid];
                        [mutableDict setObject:arr forKey:appDlgt.userData.communityid];
                        
                        [UserDefaultsStorage saveCustomArray:mutableDict forKey :@"cityDataArr"];
                            
                        [tableView_ reloadData];
                    }else{
                        
                        NSArray * tmparr = (NSArray *)data;
                        if (tmparr.count == 0) {
                            
                            pageNo = pageNo - 1;
                        }else{
                            
                            NSInteger count = dataArray.count;
                            [dataArray addObjectsFromArray:tmparr];
                            
                            NSMutableArray *insertIndexPaths = [[NSMutableArray alloc]init];
                            for (int i = 0; i < tmparr.count; i++) {
                                NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                                [insertIndexPaths addObject:newPath];
                            }
//                            [tableView_ beginUpdates];
//                            [tableView_ insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
//                            [tableView_ endUpdates];
                            [tableView_ reloadData];
//                            if (insertIndexPaths.count > 0) {
//
//                                [tableView_ scrollToRowAtIndexPath:insertIndexPaths[0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//
//                            }
                            
                        }
                    }
                }
            }else {
                
                if (tableView_.mj_header.isRefreshing) {
                    [tableView_.mj_header endRefreshing];
                }
                
                if (tableView_.mj_footer.isRefreshing) {
                    [tableView_.mj_footer endRefreshing];
                }
                
                if (pageNo != 1) {
                    
                    pageNo --;
                }
            }
            if (dataArray.count > 0) {
                
                holdView.hidden = YES;
                holdView.alpha = 0;
            }else{
                
                holdView.hidden = NO;
                holdView.alpha = 1;
            }
        });
    }];
}

///获取广告数据
-(void)getAdvData{
    
    [BBSMainPresenters getAdvlistInfo:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                advArray = (NSArray *)data;
                
                if (advArray.count > 0) {
                    
                    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc]init];
                    for (int i = 0; i < advArray.count; i++) {
                        BBSModel *model = advArray[i];
                        
                        NSInteger place = [model.shownumber integerValue];
                        if (!model.posttype) {
                            
                            model.posttype = @"5";
                        }
                        //place = 0;
                        if (place > dataArray.count) {
                            place = dataArray.count;
                        }
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:place inSection:0];
                        [insertIndexPaths addObject:newPath];
                        [dataArray insertObject:model atIndex:place];
                    }
                    if(insertIndexPaths.count > 0){
                        
                        [tableView_ beginUpdates];
                        [tableView_ insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                        [tableView_ endUpdates];
                    }
                }
            }else
            {
                //[self showToastMsg:data Duration:5.0];
            }
            if (dataArray.count > 0) {
                
                holdView.hidden = YES;
                holdView.alpha = 0;
            }else{
                
                holdView.hidden = NO;
                holdView.alpha = 1;
            }
        });
    }];
}

#pragma mark - extend method

-(void)configNavigaiton{
    
    
    //------------邻趣-tabbar新top----------------------------
    _tabbarTop_Button = [UIButton buttonWithType:UIButtonTypeCustom];
//    _tabbarTop_Button.frame = CGRectMake(SCREEN_WIDTH/4. + (SCREEN_WIDTH/4.-(self.tabBarController.tabBar.frame.size.height - 4))/2., 2, self.tabBarController.tabBar.frame.size.height - 4., self.tabBarController.tabBar.frame.size.height - 4);
    _tabbarTop_Button.frame = CGRectMake(SCREEN_WIDTH/4. + (SCREEN_WIDTH/4.-(49. - 4))/2., 2., 49 - 4., 49 - 4);

    _tabbarTop_Button.backgroundColor = self.tabBarController.tabBar.backgroundColor;
//    [_tabbarTop_Button setBackgroundImage:[UIImage imageNamed:@"邻趣-新top"] forState:UIControlStateNormal];
    [_tabbarTop_Button setImage:[UIImage imageNamed:@"邻趣-新top"] forState:UIControlStateNormal];
    [self.tabBarController.tabBar addSubview:_tabbarTop_Button];
    [self.tabBarController.tabBar bringSubviewToFront:_tabbarTop_Button];
    [_tabbarTop_Button addTarget:self action:@selector(top:) forControlEvents:UIControlEventTouchUpInside];
    _tabbarTop_Button.hidden = YES;
    //------------邻趣-tabbar新top----------------------------
    
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 100, 20)];
    
    UIImageView *bt1Image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    bt1Image.image = [UIImage imageNamed:@"邻趣-首页-顶部定位图标"];
    [bt addSubview:bt1Image];
    
    navigationLeft = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 100, 20)];
    navigationLeft.font = [UIFont systemFontOfSize:14];
    navigationLeft.textColor = TITLE_TEXT_COLOR;
    
    if (IOS_VERSION >= 11.0) {

        bt1Image.frame = CGRectMake(0, 7, 20, 20);
        navigationLeft.frame = CGRectMake(25, 7, 100, 20);
    }
    
    [bt addSubview:navigationLeft];
    
    [bt addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBt = [[UIBarButtonItem alloc]initWithCustomView:bt];
    
    self.navigationItem.leftBarButtonItem = leftBarBt;
    
    UIButton *bt2 = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 50, 20)];
    
    UIImageView *bt2Image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    bt2Image.image = [UIImage imageNamed:@"邻趣-首页-顶部搜索图标"];
    [bt2 addSubview:bt2Image];
    
    UILabel *bt2Lal = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 30, 20)];
    bt2Lal.text = @"搜索";
    bt2Lal.font = [UIFont systemFontOfSize:14];
    bt2Lal.textColor = TITLE_TEXT_COLOR;
    
    if (IOS_VERSION >= 11.0) {

        bt2Image.frame = CGRectMake(0, 7, 20, 20);
        bt2Lal.frame = CGRectMake(25, 7, 100, 20);
    }
    
    [bt2 addSubview:bt2Lal];
    [bt2 addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBt = [[UIBarButtonItem alloc]initWithCustomView:bt2];
    
    self.navigationItem.rightBarButtonItem = rightBarBt;
    
}

-(void)setTag{
    
    [tagView removeFromSuperview];
    float height;
    if (tagArr.count == 0) {
        
        tagView = [[UIView alloc]initWithFrame:CGRectMake( 0, self.cycleBannerView.frame.origin.y + self.cycleBannerView.frame.size.height, SCREEN_WIDTH - 2 * 10, 0)];
        height = 0;
    }else{
        
        tagView = [[UIView alloc]initWithFrame:CGRectMake( 0, self.cycleBannerView.frame.origin.y + self.cycleBannerView.frame.size.height, SCREEN_WIDTH - 2 * 10, 45)];
        height = 24.0;
    }
    tagView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:tagView];
    
    
    left = [[UIImageView alloc]initWithFrame:CGRectMake(10, (tagView.frame.size.height - height) / 2, height, height)];
    left.image = [UIImage imageNamed:@"邻趣-首页-标签可滑动按钮"];
    left.backgroundColor = [UIColor clearColor];
    [tagView addSubview:left];
    
    tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake( left.frame.origin.x + left.frame.size.width - 10, 0, tagView.frame.size.width - left.frame.origin.x - left.frame.size.width + 10, tagView.frame.size.height)];
    tagScrollView.backgroundColor = [UIColor clearColor];
    tagScrollView.showsHorizontalScrollIndicator = NO;
    [tagView addSubview:tagScrollView];
    
    lastRect = CGRectMake( -5, left.frame.origin.y, 0, left.frame.size.height);

    for (int i = 0; i < tagArr.count; i++) {
        
        UILabel *lal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        lal.text = [NSString stringWithFormat:@"%@",tagArr[i][@"name"]];
        lal.font = [UIFont systemFontOfSize:15];
        [lal setNumberOfLines:1];
        [lal sizeToFit];
        
        UILabel *tagLal = [[UILabel alloc]initWithFrame:CGRectMake(lastRect.origin.x + lastRect.size.width + 15, lastRect.origin.y, lal.frame.size.width + 20, lastRect.size.height)];
        tagLal.text = [NSString stringWithFormat:@"%@",tagArr[i][@"name"]];
        tagLal.tag = 10 + i;
        tagLal.textColor = NEW_RED_COLOR;
        tagLal.font = [UIFont systemFontOfSize:15];
        tagLal.textAlignment = NSTextAlignmentCenter;
        tagLal.layer.cornerRadius = lastRect.size.height / 2;
        tagLal.layer.masksToBounds = YES;
        //边框宽度及颜色设置
        [tagLal.layer setBorderWidth:1];
        [tagLal.layer setBorderColor:CGColorRetain(NEW_RED_COLOR.CGColor)];
        tagLal.userInteractionEnabled = YES;
        [tagScrollView addSubview:tagLal];
        lastRect = tagLal.frame;
        
        UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, tagLal.frame.size.width, tagLal.frame.size.height)];
        bt.backgroundColor = [UIColor clearColor];
        [bt addTarget:self action:@selector(tagBt:) forControlEvents:UIControlEventTouchUpInside];
        [tagLal addSubview:bt];
    }
    
    tagScrollView.contentSize = CGSizeMake(lastRect.size.width + lastRect.origin.x + 15, tagScrollView.frame.size.height);
}

-(void)setPerson{
    
//    for(int i = 0;i < [person.subviews count];i++){
//        
//        UIView *view = (UIView *)person.subviews[i];
//        [view removeFromSuperview];
//    }
    
    [person removeFromSuperview];
    
    if (personArr.count == 0) {
        
        person = [[UIView alloc]initWithFrame:CGRectMake( 0, tagView.frame.origin.y + tagView.frame.size.height, tagView.frame.size.width, 0)];
    }else{
        
        person = [[UIView alloc]initWithFrame:CGRectMake( 0, tagView.frame.origin.y + tagView.frame.size.height + 10, tagView.frame.size.width, 50)];
    }

    person.layer.cornerRadius = person.frame.size.height / 2;
    person.layer.masksToBounds = YES;
    person.backgroundColor = NEW_RED_COLOR;
    [headerView addSubview:person];
    
    for (int i = 0; i < personArr.count; i++) {
        
        UIView *user = [[UIView alloc]initWithFrame:CGRectMake( 10 + i * ((person.frame.size.width - 2 * 10) / 4) , 0, (person.frame.size.width - 2 * 10) / 4, person.frame.size.height)];
        user.backgroundColor = [UIColor clearColor];
        user.tag = 100 + i;
        UIImageView *head = [[UIImageView alloc]initWithFrame:CGRectMake( 5, user.frame.size.height / 4, user.frame.size.height / 2, user.frame.size.height / 2)];
        head.backgroundColor = [UIColor clearColor];
        head.layer.cornerRadius = head.frame.size.height / 2;
        head.layer.masksToBounds = YES;
        [head.layer setBorderWidth:1];
        [head.layer setBorderColor:CGColorRetain([UIColor whiteColor].CGColor)];
        
        NSString *headImg = [NSString stringWithFormat:@"%@",personArr[i][@"userpicurl"]];
        head.image = kHeaderPlaceHolder;
        if (headImg.length > 0 ) {
            
            [head sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:kHeaderPlaceHolder];
        }
        [user addSubview:head];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(head.frame.origin.x + head.frame.size.width + 3,head.frame.origin.y + 3, user.frame.size.width - head.frame.size.width - head.frame.origin.x, (head.frame.size.height - 5) / 2)];
        name.textColor = [UIColor whiteColor];
        name.backgroundColor = [UIColor clearColor];
        name.text = [NSString stringWithFormat:@"%@",personArr[i][@"nickname"]];
        name.font = [UIFont systemFontOfSize:10];
        //name.lineBreakMode = NSLineBreakByClipping;
        [user addSubview:name];
        
        UILabel *testLal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        testLal.text = @"文字测试";
        testLal.font = [UIFont systemFontOfSize:6];
        [testLal setNumberOfLines:1];
        [testLal sizeToFit];
        
        NSString *vip1Str = [NSString stringWithFormat:@"%@",personArr[i][@"isowner"]];
        UIImageView *vip1 = [[UIImageView alloc]initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 5, testLal.frame.size.height, testLal.frame.size.height )];
        vip1.image = [UIImage imageNamed:@"邻趣-首页-物业认证图标"];
        vip1.backgroundColor = [UIColor clearColor];
        [user addSubview:vip1];
        if ([vip1Str isEqualToString:@"0"]) {
            
            vip1.frame = CGRectMake(vip1.frame.origin.x - 1, vip1.frame.origin.y , 0, vip1.frame.size.height);
        }
        
        NSString *vip2Str = [NSString stringWithFormat:@"%@",personArr[i][@"isvaverified"]];
        UIImageView *vip2 = [[UIImageView alloc]initWithFrame:CGRectMake(vip1.frame.origin.x+ vip1.frame.size.width + 1, vip1.frame.origin.y , vip1.frame.size.height, vip1.frame.size.height)];
        vip2.image = [UIImage imageNamed:@"邻趣-首页-实名认证图标"];
        vip2.backgroundColor = [UIColor clearColor];
        [user addSubview:vip2];
        if ([vip2Str isEqualToString:@"0"]) {
            
            vip2.frame = CGRectMake(vip2.frame.origin.x - 1, vip2.frame.origin.y, 0, vip2.frame.size.height);
        }

        UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(vip2.frame.origin.x + vip2.frame.size.width + 1,vip2.frame.origin.y, user.frame.size.width - vip2.frame.origin.x - vip2.frame.size.width - 1, vip2.frame.size.height)];
        type.textColor = [UIColor whiteColor];
        type.backgroundColor = [UIColor clearColor];
        type.text = [NSString stringWithFormat:@"%@",personArr[i][@"tagsname"]];
        type.font = [UIFont systemFontOfSize:8];
        //type.lineBreakMode = NSLineBreakByWordWrapping;
        [user addSubview:type];
        
        UIButton *personBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, user.frame.size.width, user.frame.size.height)];
        personBt.backgroundColor = [UIColor clearColor];
        [personBt addTarget:self action:@selector(personTap:) forControlEvents:UIControlEventTouchUpInside];
        [user addSubview:personBt];
        
        [person addSubview:user];
    }
}

-(UIView *)configSectionHeader{
    
    UIView *headerBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    headerBack.backgroundColor = BLACKGROUND_COLOR;
    //headerBack.clipsToBounds = NO;
    UIView *backWhite = [[UIView alloc]initWithFrame:CGRectMake( -10, 5, SCREEN_WIDTH, 45)];
    backWhite.backgroundColor = [UIColor whiteColor];
    [headerBack addSubview:backWhite];
    
    cityBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, (backWhite.frame.size.width - 3 * 2) / 4, backWhite.frame.size.height - 2 * 5)];
    [cityBt setTitle:@"全 城" forState:UIControlStateNormal];
    cityBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [cityBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBt addTarget:self action:@selector(cityBt:) forControlEvents:UIControlEventTouchUpInside];
    [backWhite addSubview:cityBt];
    
    UIImageView *cityRed = [[UIImageView alloc]initWithFrame:CGRectMake(cityBt.frame.size.width - 20, 0, 13, 13)];
    cityRed.backgroundColor = [UIColor clearColor];
    cityRed.image = [UIImage imageNamed:@"邻趣-首页-消息提示图标"];
    cityRed.tag = 1;
    //[newBt addSubview:newRed];
    
    
    UIView *midLine1 = [[UIView alloc]initWithFrame:CGRectMake(cityBt.frame.size.width + cityBt.frame.origin.x, backWhite.frame.size.height / 4 , 2, backWhite.frame.size.height / 2)];
    midLine1.backgroundColor = LINE_COLOR;
    [backWhite addSubview:midLine1];
    
    newBt = [[UIButton alloc]initWithFrame:CGRectMake(midLine1.frame.origin.x + midLine1.frame.size.width, cityBt.frame.origin.y, cityBt.frame.size.width, cityBt.frame.size.height)];
    [newBt setTitle:@"本社区" forState:UIControlStateNormal];
    newBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [newBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newBt addTarget:self action:@selector(newBt:) forControlEvents:UIControlEventTouchUpInside];
    [backWhite addSubview:newBt];
    
    UIImageView *newRed = [[UIImageView alloc]initWithFrame:cityRed.frame];
    newRed.backgroundColor = [UIColor clearColor];
    newRed.image = [UIImage imageNamed:@"邻趣-首页-消息提示图标"];
    newRed.tag = 2;
    //[imageBt addSubview:imageRed];
    
    UIView *midLine2 = [[UIView alloc]initWithFrame:CGRectMake(newBt.frame.size.width + newBt.frame.origin.x, midLine1.frame.origin.y, 2, midLine1.frame.size.height)];
    midLine2.backgroundColor = LINE_COLOR;
    [backWhite addSubview:midLine2];
    
    imageBt = [[UIButton alloc]initWithFrame:CGRectMake(midLine2.frame.origin.x + midLine2.frame.size.width, newBt.frame.origin.y, newBt.frame.size.width, newBt.frame.size.height)];
    [imageBt setTitle:@"图 说" forState:UIControlStateNormal];
    imageBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [imageBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imageBt addTarget:self action:@selector(imageBt:) forControlEvents:UIControlEventTouchUpInside];
    [backWhite addSubview:imageBt];
    
    UIImageView *imageRed = [[UIImageView alloc]initWithFrame:cityRed.frame];
    imageRed.backgroundColor = [UIColor clearColor];
    imageRed.image = [UIImage imageNamed:@"邻趣-首页-消息提示图标"];
    imageRed.tag = 3;
    //[cityBt addSubview:cityRed];
    
    UIView *midLine3 = [[UIView alloc]initWithFrame:CGRectMake(imageBt.frame.size.width + imageBt.frame.origin.x, midLine1.frame.origin.y, 2, midLine1.frame.size.height)];
    midLine3.backgroundColor = LINE_COLOR;
    [backWhite addSubview:midLine3];
    
    myBt = [[UIButton alloc]initWithFrame:CGRectMake(midLine3.frame.origin.x + midLine3.frame.size.width, newBt.frame.origin.y, newBt.frame.size.width, newBt.frame.size.height)];
    [myBt setTitle:@"我 的" forState:UIControlStateNormal];
    myBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [myBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [myBt addTarget:self action:@selector(myBt:) forControlEvents:UIControlEventTouchUpInside];
    [backWhite addSubview:myBt];
    
    UIImageView *myRed = [[UIImageView alloc]initWithFrame:cityRed.frame];
    myRed.backgroundColor = [UIColor clearColor];
    myRed.image = [UIImage imageNamed:@""];
    myRed.tag = 4;
    [myBt addSubview:myRed];
    
    bottomRed = [[UIView alloc]init];
    
    if (listType == 0) {
        
        [newBt setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
        bottomRed.frame = CGRectMake(newBt.frame.origin.x + 20, backWhite.frame.size.height - 2, newRed.frame.origin.x - 20, 2);
    }else if (listType == 1){
        
        [imageBt setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
        bottomRed.frame = CGRectMake(imageBt.frame.origin.x + 20, backWhite.frame.size.height - 2, newRed.frame.origin.x - 20, 2);
    }else if (listType == 2){
        
        [cityBt setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
        bottomRed.frame = CGRectMake(cityBt.frame.origin.x + 20, backWhite.frame.size.height - 2, newRed.frame.origin.x - 20, 2);
    }
    
    bottomRed.backgroundColor = NEW_RED_COLOR;
    
    [backWhite addSubview:bottomRed];
    
    return headerBack;
}

#pragma mark - Actions

-(void)personTap:(id)sender{
    
    long tag_tag = [sender superview].tag - 100;
    NSDictionary *dict = personArr[tag_tag];
    NSString *userId = [NSString stringWithFormat:@"%@",dict[@"userid"]];
    
    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:userId];
    personList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
//
//    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//    
//    if([appDlgt.userData.url_gamuserindex hasSuffix:@".html"])
//    {
//        webVc.url=[NSString stringWithFormat:@"%@?token=%@&userid=%@",appDlgt.userData.url_gamuserindex,appDlgt.userData.token,userId];
//    }
//    else
//    {
//        webVc.url=[NSString stringWithFormat:@"%@&token=%@&userid=%@",appDlgt.userData.url_gamuserindex,appDlgt.userData.token,userId];
//    }
//    webVc.isGetCurrentTitle = YES;
//    webVc.title = @"个人主页";
//    [self.navigationController pushViewController:webVc animated:YES];
}

-(void)tagBt:(id)sender{//标签栏标签点击事件
    
    long tag_tag = [sender superview].tag - 10;
    NSString *str = [NSString stringWithFormat:@"%@",tagArr[tag_tag][@"name"]];
    
    BBSSearchViewController *search = [[BBSSearchViewController alloc]init];
    [search getTitle:str search:@"1"];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

-(void)left:(id)sender{//顶部地址定位按钮跳转
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    ChangAreaVC * areaVC=[storyboard instantiateViewControllerWithIdentifier:@"ChangAreaVC"];
    areaVC.delegate = self;
    [self.navigationController pushViewController:areaVC animated:YES];
}

-(void)jumpBack{
    
    NSLog(@"跳转测试=========================");
    if (listType == 0) {
        
        [self newBt:nil];
    }else if(listType == 1){
        
        [self imageBt:nil];
    }else{
        
        [self cityBt:nil];
    }
}

-(void)changeArea{
    
    if (listType == 0) {
        
        [self newBt:nil];
    }else if(listType == 1){
        
        [self imageBt:nil];
    }else{
        
        [self cityBt:nil];
    }
}

-(void)right:(id)sender {//顶部搜索按钮跳转
    
    BBSSearchViewController *search = [[BBSSearchViewController alloc]init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)animationAlert:(UIView *)view
{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
    
}

-(void)publishBtnAction:(id)sender{////////////点击发帖
    PostingVC *pos = [[PostingVC alloc] init];
    pos.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pos animated:NO];
    
}
-(void)newBt:(id)sender{
    listType = 0;
    holdView.hidden = NO;
    holdView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{

        bottomRed.frame = CGRectMake(newBt.frame.origin.x + 20, bottomRed.frame.origin.y, bottomRed.frame.size.width, bottomRed.frame.size.height);
        
//        UIImageView *red = (UIImageView *)[self.view viewWithTag:1];
//        red.image = [UIImage imageNamed:@""];
        
        [newBt setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
        [imageBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cityBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [myBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self top:nil];
    } completion:^(BOOL finished) {

        pageNo = 1;
            
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        [mutableDict setDictionary:[UserDefaultsStorage getDataforKey:@"newDataArr"]];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [mutableArr addObjectsFromArray:mutableDict[appDlgt.userData.communityid]];
        dataArray = [BBSModel mj_objectArrayWithKeyValuesArray:mutableArr];

        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView_ reloadData];
        });
        
        area = @"-1";
        contype = @"0";
        [self getListData];
    }];
}

-(void)imageBt:(id)sender{
    
    listType = 1;
    holdView.hidden = NO;
    holdView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        
        bottomRed.frame = CGRectMake(imageBt.frame.origin.x + 20, bottomRed.frame.origin.y, bottomRed.frame.size.width, bottomRed.frame.size.height);
        
//        UIImageView *red = (UIImageView *)[self.view viewWithTag:2];
//        red.image = [UIImage imageNamed:@""];
        
        [newBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [imageBt setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
        [cityBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [myBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self top:nil];
    } completion:^(BOOL finished) {
        
        pageNo = 1;
            
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        [mutableDict setDictionary:[UserDefaultsStorage getDataforKey:@"picDataArr"]];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [mutableArr addObjectsFromArray:mutableDict[appDlgt.userData.communityid]];
        dataArray = [BBSModel mj_objectArrayWithKeyValuesArray:mutableArr];

        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView_ reloadData];
        });

        area = @"-1";
        contype = @"1";
        [self getListData];
        
    }];
    
}

- (void)cityBt:(id)sender {
    
    listType = 2;
    
    holdView.hidden = NO;
    holdView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        bottomRed.frame = CGRectMake(cityBt.frame.origin.x + 20, bottomRed.frame.origin.y, bottomRed.frame.size.width, bottomRed.frame.size.height);
        
//        UIImageView *red = (UIImageView *)[self.view viewWithTag:3];
//        red.image = [UIImage imageNamed:@""];
        
        [newBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [imageBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cityBt setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
        [myBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self top:nil];
    } completion:^(BOOL finished) {
        
        pageNo = 1;
            
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        [mutableDict setDictionary:[UserDefaultsStorage getDataforKey:@"cityDataArr"]];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [mutableArr addObjectsFromArray:mutableDict[appDlgt.userData.communityid]];
        dataArray = [BBSModel mj_objectArrayWithKeyValuesArray:mutableArr];

        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView_ reloadData];
        });

        area = @"-3";
        contype = @"0";
        [self getListData];
    }];
}

-(void)myBt:(id)sender{//我的-点击事件
    
    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:appDlgt.userData.userID];
    personList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
    
//    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//    
//    if([appDlgt.userData.url_gamuserindex hasSuffix:@".html"])
//    {
//        webVc.url=[NSString stringWithFormat:@"%@?token=%@&userid=%@",appDlgt.userData.url_gamuserindex,appDlgt.userData.token,appDlgt.userData.userID];
//    }
//    else
//    {
//        webVc.url=[NSString stringWithFormat:@"%@&token=%@&userid=%@",appDlgt.userData.url_gamuserindex,appDlgt.userData.token,appDlgt.userData.userID];
//    }
//    
//    webVc.isGetCurrentTitle = YES;
//    webVc.title = @"个人主页";
//    [self.navigationController pushViewController:webVc animated:YES];
}

-(void)top:(id)sender{
    
    if (sender == _tabbarTop_Button) {

        if (self.tabBarController.selectedViewController != [self.tabBarController.viewControllers objectAtIndex:1]) {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
            return;
        }
        
    }
    
    //top.hidden = YES;
    if (dataArray.count == 0) {
        
        return;
    }else{
        
        if (newoffsetY >= headerView.frame.size.height + headerView.frame.origin.y) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [tableView_ scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        //[tableView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    if (bannerArray == nil||bannerArray.count==0 || [XYString isBlankString:[bannerArray[index] objectForKey:@"gotourl"]]) {
        return;
    }
    NSDictionary * dic=[bannerArray objectAtIndex:index];
    NSLog(@"活动===%@",dic);
    
    UserActivity *userModel = [[UserActivity alloc]init];
    userModel.picurl = [dic objectForKey:@"picurl"];
    userModel.gotourl = [dic objectForKey:@"gotourl"];
    userModel.title = [dic objectForKey:@"title"];
    //    userModel.gototype = [dic objectForKey:@"gototype"];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    
    if([[dic objectForKey:@"gotourl"] hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",[dic objectForKey:@"gotourl"],appDlgt.userData.token,kCurrentVersion];
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",[dic objectForKey:@"gotourl"],appDlgt.userData.token,kCurrentVersion];
    }
    
    webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    webVc.type = 5;
    webVc.shareTypes = 5;
    
    webVc.userActivityModel = userModel;
    if (![XYString isBlankString:userModel.title]) {
        webVc.title = userModel.title;
    }else {
        webVc.title = @"活动详情";
        
    }
    webVc.isGetCurrentTitle = YES;
    
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark - tableView scroll to top show method

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
//    tableView_.userInteractionEnabled = YES;
//}
//
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.marginTop != tableView_.contentInset.top) {
        self.marginTop = tableView_.contentInset.top;
    }
    //CGFloat offsetY = [change[@"new"] CGPointValue].y;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // newoffsetY 便是我们想监测的偏移offset.y，初始值为0
    // 向下滑动时<0，向上滑动时>0；
    newoffsetY = offsetY + self.marginTop;
    //NSLog(@"%f",headerView.frame.size.height + headerView.frame.origin.y);
    
    if (newoffsetY >= headerView.frame.size.height + headerView.frame.origin.y + 150 && newoffsetY > 0 && scrollView == tableView_) {
//        [scroll setContentOffset:CGPointMake(0, headerView.frame.size.height + headerView.frame.origin.y)];
//        scroll.scrollEnabled = NO;
//        tableView_.scrollEnabled = YES;
        
//        top.hidden = NO;
        
        _tabbarTop_Button.hidden = NO;
        
    }else if(newoffsetY < headerView.frame.size.height + headerView.frame.origin.y + 150 && newoffsetY > 0 && scrollView == tableView_){
        
//        top.hidden = YES;
        
        _tabbarTop_Button.hidden = YES;

    }

}

#pragma  mark ------------推送消息处理-----------
-(void)subReceivePushMessages:(NSNotification *)aNotification {
    [self setBadges];
}
/**
 *  设置消息标记
 */
-(void)setBadges {
    
    MainTabBars *tab=(MainTabBars *)self.tabBarController;
    [tab setTabBarBadges];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        //设置消息标记
        [self setBadges];
        
        NSString *noticeRefreshEditData = [USER_DEFAULT objectForKey:NOTICE_REFRESH_EDIT_DATA];
        
        NSString *deleteListValueOK = [USER_DEFAULT objectForKey:DELETE_LIST_VALUE_OK];
        
        if ([deleteListValueOK isEqualToString:@"yes"]||[noticeRefreshEditData isEqualToString:@"yes"] ) {
            
            [self changeArea];
        }
        
//        [TalkingData trackPageBegin:@"linqushouye"];
        
        [self getHeaderData];
        
        appDlgt = GetAppDelegates;
        
        NSString *areaText = [NSString stringWithFormat:@"%@",appDlgt.userData.communityname];
        navigationLeft.text = areaText;
        
        self.navigationController.navigationBarHidden = NO;
        self.hidesBottomBarWhenPushed = NO;
        self.tabBarController.tabBar.hidden = NO;
        
    });
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 55;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [self configSectionHeader];
}
// 在控制器中实现tableView:estimatedHeightForRowAtIndexPath:方法，返回一个估计高度，比如100 下方法可以调节“创建cell”和“计算cell高度”两个方法的先后执行顺序
/**
 *  返回每一行的估计高度，只要返回了估计高度，就会先调用cellForRowAtIndexPath给model赋值，然后调用heightForRowAtIndexPath返回cell真实的高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = [dataArray objectAtIndex:indexPath.row];
    
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = dataArray[indexPath.row];
    NSLog(@"%@-----%@",model.redtype,model.content);
//    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section],[indexPath row]];//以indexPath来唯一确定cell
    
    @WeakObj(self);
    
    if ([model.posttype isEqualToString:@"0"]) {///////////////////普通帖
        
        if (model.piclist.count >= 3) {//3图普通帖
            
            BBSNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormalTableViewCell"];

            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 2){//2图普通帖
            
            BBSNormal2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
            
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };

            return cell;
                
        }else if (model.piclist.count == 1){//1图普通帖
        
            BBSNormal1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
        }else if (model.piclist.count == 0){//无图普通帖
                
            BBSNormal0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal0TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"5"]) {///////////////////////广告贴
        
        if([model.advtype isEqualToString:@"100"]){
            
            BBSAdvert0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert0TableViewCell"];
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([model.advtype isEqualToString:@"101"]){
            
            if (model.piclist.count >= 3) {//3图广告贴
                
                BBSAdvertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvertTableViewCell"];
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }else if (model.piclist.count == 2){//2图广告贴
                
                BBSAdvert2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert2TableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.model = model;
                
                return cell;
                
            }else if (model.piclist.count == 1){//1图广告贴
                
                BBSAdvert1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert1TableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.model = model;
                
                return cell;
            }
        }
    }else if ([model.posttype isEqualToString:@"2"]) {///////////////////////投票贴
        if ([model.pictype isEqualToString:@"1"]) {//3图投票贴
            
            if (model.itemlist.count >= 3) {
                
                BBSVotePICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePICTableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];

                };
                
                return cell;
            }else if (model.itemlist.count == 2){//2图投票贴
                
                BBSVotePIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePIC2TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];

                };
                
                return cell;
                
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }else if ([model.pictype isEqualToString:@"0"]){//文字投票贴
            
            if(model.itemlist.count >= 3){
                
                BBSVoteTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteTextTableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];

                };
                
                return cell;
            }else if(model.itemlist.count == 2){
                
                BBSVoteText2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteText2TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];

                };
                
                return cell;
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"3"]) {///////////////////////问答贴
        if (model.piclist.count >= 3) {//3图问答贴
            
            BBSQuestionPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPICTableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };

            return cell;
            
        }else if (model.piclist.count == 2){//2图问答贴
            
            BBSQuestionPIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };

            return cell;
            
        }else if (model.piclist.count == 1){//1图问答贴
            
            BBSQuestionPIC1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){

                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            return cell;
            
        }else if (model.piclist.count == 0){//文字问答贴
            
            BBSQuestionNoPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionNoPICTableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };

            return cell;
        }
    }else if ([model.posttype isEqualToString:@"4"]) {///////////////////////房产贴
        if (model.piclist.count >= 3) {//3图房产贴
            
            BBSHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouseTableViewCell"];
            cell.type = listType;

            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                /** 0 房产 1 车位 */
                
                AppDelegate *appDlt = GetAppDelegates;
                
                if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                    return ;
                }
                
                if (index == 0) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                    houseOrCar.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
//                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//                    if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    else
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    webVc.title = kHouseListTitle;
//                    webVc.isGetCurrentTitle = YES;
//                    [self.navigationController pushViewController:webVc animated:YES];
                    
                }else if (index == 1) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                    houseOrCar.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                    
//                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//                    if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    else
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    webVc.title = kCarListTitle;
//                    webVc.isGetCurrentTitle = YES;
//                    [self.navigationController pushViewController:webVc animated:YES];
                    
                }
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };

            return cell;
            
        }else if (model.piclist.count == 2){//2图房产贴
            
            BBSHouse2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                /** 0 房产 1 车位 */
                
                AppDelegate *appDlt = GetAppDelegates;
                
                if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                    return ;
                }
                
                if (index == 0) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                    houseOrCar.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
//                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//                    if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    else
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    webVc.title = kHouseListTitle;
//                    webVc.isGetCurrentTitle = YES;
//                    [self.navigationController pushViewController:webVc animated:YES];
                    
                }else if (index == 1) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                    
                    [self.navigationController pushViewController:houseOrCar animated:YES];
//                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//                    if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    else
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    webVc.title = kCarListTitle;
//                    webVc.isGetCurrentTitle = YES;
//                    [self.navigationController pushViewController:webVc animated:YES];
                    
                }
                
            };

            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };

            return cell;
            
        }else if (model.piclist.count == 1){//1图房产贴
            
            BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                /** 0 房产 1 车位 */
                
                AppDelegate *appDlt = GetAppDelegates;
                
                if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                    return ;
                }
                
                if (index == 0) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                    houseOrCar.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
//                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//                    if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    else
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    webVc.title = kHouseListTitle;
//                    webVc.isGetCurrentTitle = YES;
//                    [self.navigationController pushViewController:webVc animated:YES];
                    
                }else if (index == 1) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                    houseOrCar.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
//                    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//                    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//                    if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    else
//                    {
//                        webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
//                    }
//                    webVc.title = kCarListTitle;
//                    webVc.isGetCurrentTitle = YES;
//                    [self.navigationController pushViewController:webVc animated:YES];
                    
                }
                
            };

            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };

            return cell;
        }else if (model.piclist.count == 0){//0图房产贴
            
            BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:0];

            };
            
            cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
            };
            
            cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                /** 0 房产 1 车位 */
                
                AppDelegate *appDlt = GetAppDelegates;
                
                if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                    return ;
                }
                
                if (index == 0) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                    houseOrCar.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                    
                }else if (index == 1) {
                    
                    HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                    [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                    houseOrCar.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:houseOrCar animated:YES];
                    
                }
                
            };
            
            @WeakObj(cell);
            cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.praiseLal.text = model.praisecount;
                        
                    });
                    
                }];
                
            };
            
            return cell;
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"1"]) {///////////////////////商品贴
        
        if (model.piclist.count >= 3) {//3图商品贴
            
            BBSCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodityTableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            
        }else if (model.piclist.count == 2){//2图商品贴
            
            BBSCommodity2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            
        }else if (model.piclist.count == 1){//1图商品贴
            
            BBSCommodity1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
    }else if (model.posttype.integerValue == 9) {//活动分享
        
        //=========活动分享到邻趣======================
        L_ShareActivityTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_ShareActivityTVC"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (listType == 1 || listType == 0) {
            cell.cellType = 2;
        }else {
            cell.cellType = 1;
        }
        
        cell.model = model;
        
        @WeakObj(cell);
        cell.cellBtnDidClickBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
          
            //1.头像 2.点赞 3.社区
            if (index == 1) {
                [self gotoCommunityWebviewWithModel:model withListType:1];
            }
            
            if (index == 2) {
                
                NSInteger isPraise = 0;
                if (model.ispraise.integerValue == 0) {
                    isPraise = 0;
                }else {
                    isPraise = 1;
                }
                
                [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (model.ispraise.integerValue == 0) {
                            
                            model.ispraise = @"1";
                            
                            cellWeak.praise_ImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                            
                        }else {
                            
                            model.ispraise = @"0";
                            
                            cellWeak.praise_ImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                            
                        }
                        
                        model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                        cellWeak.dianzan_Label.text = model.praisecount;
                        
                    });
                    
                }];
                
            }
            
            if (index == 3) {
                [self gotoCommunityWebviewWithModel:model withListType:2];
            }
            
        };
        
        return cell;
        
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BBSModel *model = dataArray[indexPath.row];
    
    if (model.posttype.integerValue == 0) {//普通帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
        normalDetailVC.postID = model.theid;
        
        normalDetailVC.deleteRefreshBlock = ^(){
            
            [dataArray removeObject:model];
            [tableView_ deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        normalDetailVC.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
            
            if (![XYString isBlankString:praise]) {
                
                model.praisecount = praise;
            }
            
            if (![XYString isBlankString:comment]) {
                
                model.commentcount = comment;
            }
            
            if (![XYString isBlankString:type]) {
                if (type.integerValue == 0) {
                    model.ispraise = @"1";
                }else {
                    model.ispraise = @"0";
                }
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        };

        
        [self.navigationController pushViewController:normalDetailVC animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 4) {//房产车位帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
        houseDetailVC.postID = model.theid;
        houseDetailVC.bbsModel = model;
        
        houseDetailVC.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
            
            if (![XYString isBlankString:praise]) {
                
                model.praisecount = praise;
            }
            
            if (![XYString isBlankString:comment]) {
                
                model.commentcount = comment;
            }
            
            if (![XYString isBlankString:type]) {
                if (type.integerValue == 0) {
                    model.ispraise = @"1";
                }else {
                    model.ispraise = @"0";
                }
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        };
        
        [self.navigationController pushViewController:houseDetailVC animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 3) {//问答帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
        qusetion.postID = model.theid;
        
        qusetion.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
            
            
            if (![XYString isBlankString:comment]) {
                
                model.commentcount = comment;
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        };
        
        qusetion.deleteRefreshBlock = ^(){
            
            [dataArray removeObject:model];
            [tableView_ deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        [self.navigationController pushViewController:qusetion animated:YES];
        return;
        
    }
    
    if (model.posttype.integerValue == 9) {//活动分享
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
        
        if([model.sharegotourl hasSuffix:@".html"]) {
            webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",model.sharegotourl,appDlgt.userData.token,kCurrentVersion];
        }else {
            webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",model.sharegotourl,appDlgt.userData.token,kCurrentVersion];
        }
        
//        webVc.url = [NSString stringWithFormat:@"%@",model.sharegotourl];
        webVc.type = 5;
        webVc.shareTypes = 5;
        
        UserActivity *userModel = [[UserActivity alloc]init];
        userModel.gotourl = [NSString stringWithFormat:@"%@",model.sharegotourl];
        webVc.userActivityModel = userModel;
        
        if (![XYString isBlankString:model.title]) {
            webVc.title = model.title;
        }else {
            webVc.title = @"活动详情";
        }
        webVc.isGetCurrentTitle = YES;
        
        webVc.talkingName = @"shequhuodong";
        webVc.isNoRefresh = YES;
        
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

/**
 进入社区帖子,进入个人中心 listtype==2为社区帖子
 */
- (void)gotoCommunityWebviewWithModel:(BBSModel *)model withListType:(NSInteger)listtype {
    
//    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    if (listtype == 2) {
        
        CommunityListViewController *CommunityList = [[CommunityListViewController alloc]init];
        [CommunityList getCommunityID:model.communityid communityName:model.communityname];
        CommunityList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CommunityList animated:YES];

    }else {
        
        personListViewController *personList = [[personListViewController alloc]init];
        [personList getuserID:model.userid];
        personList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personList animated:YES];

    }
}


@end
