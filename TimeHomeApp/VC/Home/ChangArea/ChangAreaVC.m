//
//  ChangAreaVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ChangAreaVC.h"
#import "ChangCityVC.h"
#import "UIButtonImageWithLable.h"
#import "TableViewDataSource.h"
#import "ChangAreaCell.h"
#import "CityCommunityModel.h"
#import "BDMapFWPresenter.h"
#import "AppSystemSetPresenters.h"
#import "SearchVC.h"
#import "CommunityManagerPresenters.h"
#import "THMyInfoPresenter.h"
#import "PerfectInforVC.h"
#import "MainTabBars.h"


#import "L_AddHouseForCertifyCommunityVC.h"
#import "L_CertifyHoustListViewController.h"
#import "L_CommunityAuthoryPresenters.h"

typedef enum : NSUInteger {
    CommunityChangeType_Nearby = 1,
    CommunityChangeType_Frequently = 2,
} CommunityChangeType;

@interface ChangAreaVC ()<UITableViewDelegate,UITableViewDataSource>
{
    /**
     *  列表显示数据源
     */
    TableViewDataSource * dataSource;
    
    //当前城市数据
    CityCommunityModel * currentCity;
    //当前选中社区
    CityCommunityModel * currentCommunity;
    
    //定位数据
    LocationInfo * location;
    //定位功能
    BDMapFWPresenter * bdmap;
    
    AppDelegate * appdgt;
    
    NSInteger page;
    
    CommunityChangeType communityChangeType;/** 切换社区类型 1 附近社区 2 常出入社区 */
}

@property (nonatomic, strong) UIView *topViewBottomLine;/** 上方切换按钮下面的红线 */

/** 距上方约束 13 64 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayoutConstraint;

/** 常出入社区数组 */
@property (nonatomic, strong) NSMutableArray *userCommonCommunityArray;

/** 附的社区数据 */
@property (nonatomic, strong) NSMutableArray *communitArray;

/**
 *  城市选择
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_NavTitle;
/**
 *  搜索内容
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_SeachText;
/**
 *  小区列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 常出入社区 */
@property (weak, nonatomic) IBOutlet UIButton *firstCommunity_Btn;
/** 附近社区 */
@property (weak, nonatomic) IBOutlet UIButton *secondCommunity_Btn;
/** 上方背景view */
@property (weak, nonatomic) IBOutlet UIView *topBgView;

@end

@implementation ChangAreaVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    //初始加载数据
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ///数据统计
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(SIMULATOR==0)//真机
    {
        //开始定位
        [self location];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(currentCommunity)
    {
        if (_pageSourceType != PAGE_SOURCE_TYPE_BIKE && _pageSourceType != PAGE_SOURCE_TYPE_COMMUNNITYAUTH) {
            [UserDefaultsStorage saveData:currentCity forKey:@"currentCity"];
        }
    }
}

/**
 *  初始化视图
 */
-(void)initView {
    
    appdgt = GetAppDelegates;
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    currentCity = [UserDefaultsStorage getDataforKey:@"currentCity"];
    
    if (currentCity==nil) {
        currentCity=[CityCommunityModel new];
    }
    
    currentCity.ID=appdgt.userData.cityid;
    currentCity.name=appdgt.userData.cityname;
    
    if (_pageSourceType == PAGE_SOURCE_TYPE_BIKE) {
        if (![XYString isBlankString:_bikeCityid]) {
            currentCity.ID = _bikeCityid;
            currentCity.name = _bikeCityName;
        }
    }
    
    if (_pageSourceType != PAGE_SOURCE_TYPE_BIKE && _pageSourceType != PAGE_SOURCE_TYPE_COMMUNNITYAUTH) {
        [UserDefaultsStorage saveData:currentCity forKey:@"currentCity"];
    }
    
    if([XYString isBlankString:currentCity.name]) {
        [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:@"石家庄市" forState:UIControlStateNormal];
    }else {
        [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:currentCity.name forState:UIControlStateNormal];
    }
    
    self.btn_NavTitle.frame=CGRectMake(0, 0, SCREEN_WIDTH-130, 40);
    
    self.communitArray = [[NSMutableArray alloc] init];
    _userCommonCommunityArray = [[NSMutableArray alloc] init];
    
    @WeakObj(self);
    
    if (_pageSourceType == PAGE_SOURCE_TYPE_MYINFO) {
        communityChangeType = CommunityChangeType_Nearby;
        _topBgView.hidden = YES;
        _tableViewTopLayoutConstraint.constant = 13;
    }else {
        communityChangeType = CommunityChangeType_Frequently;
        _topBgView.hidden = NO;
        _tableViewTopLayoutConstraint.constant = 64;
        
        [_topBgView layoutIfNeeded];
        _topViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42, _topBgView.frame.size.width / 2.f, 2)];
        [_topBgView addSubview:_topViewBottomLine];
        _topViewBottomLine.backgroundColor = kNewRedColor;
        
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangAreaCell" bundle:nil] forCellReuseIdentifier:@"ChangAreaCell"];
    [self setExtraCellLineHidden:self.tableView];
    
    self.tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        selfWeak.tableView.alpha = 1;
        [selfWeak topRefreshWithType:communityChangeType];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        selfWeak.tableView.alpha = 1;
        [selfWeak loadmoreWithType:communityChangeType];
    }];
    
    bdmap=[BDMapFWPresenter new];
    
}

#pragma mark - 常出入社区，附近社区 按钮点击

- (IBAction)allButtonsDidTouch:(UIButton *)sender {
    
    //常出入社区
    if (sender.tag == 10) {
        communityChangeType = CommunityChangeType_Frequently;
        
        [_firstCommunity_Btn setImage:[UIImage imageNamed:@"常出入社区-红"] forState:UIControlStateNormal];
        [_secondCommunity_Btn setImage:[UIImage imageNamed:@"附近社区-灰"] forState:UIControlStateNormal];
        [_firstCommunity_Btn setTitleColor:kNewRedColor forState:UIControlStateNormal];
        [_secondCommunity_Btn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        _topViewBottomLine.frame = CGRectMake(0, 42, _topBgView.frame.size.width / 2.f, 2);
        
    }
    
    if (sender.tag == 11) {//附近社区
        communityChangeType = CommunityChangeType_Nearby;
        
        [_firstCommunity_Btn setImage:[UIImage imageNamed:@"常出入社区-灰"] forState:UIControlStateNormal];
        [_secondCommunity_Btn setImage:[UIImage imageNamed:@"附近社区-红"] forState:UIControlStateNormal];
        [_firstCommunity_Btn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        [_secondCommunity_Btn setTitleColor:kNewRedColor forState:UIControlStateNormal];
        _topViewBottomLine.frame = CGRectMake(_topBgView.frame.size.width / 2.f, 42, _topBgView.frame.size.width / 2.f, 2);
        
    }
    [_userCommonCommunityArray removeAllObjects];
    [self.communitArray removeAllObjects];
    [_tableView reloadData];
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 刷新数据

- (void)topRefresh {
    self.tableView.alpha = 1;
    [self topRefreshWithType:communityChangeType];
}

-(void)topRefreshWithType:(CommunityChangeType)selectType {
    page=1;
    [self getData:page withType:selectType];
}

-(void)loadmoreWithType:(CommunityChangeType)selectType {
    page++;
    [self getData:page withType:selectType];
}

#pragma mark - Request

/**
 获取数据
 
 @param pageNum 页数
 @param selectType 1 附近社区 2 常出入社区
 */
-(void)getData:(NSInteger)pageNum withType:(CommunityChangeType)selectType {
    
    [self hiddenNothingnessView];
    
    if (selectType == CommunityChangeType_Nearby) {
        
        UpDateViewsBlock updateBlock = ^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.tableView.mj_header.isRefreshing) {
                    [self.tableView.mj_header endRefreshing];
                }
                
                if (self.tableView.mj_footer.isRefreshing) {
                    [self.tableView.mj_footer endRefreshing];
                }
                
                if(resultCode==SucceedCode) {
                    
                    if(page>1) {
                        
                        NSArray * tmparr=(NSArray *)data;
                        NSInteger count = self.communitArray.count;
                        
                        [self.communitArray addObjectsFromArray:tmparr];
                        
                        [self.tableView beginUpdates];
                        
                        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                        for (int i=0; i<[tmparr count]; i++) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                            [insertIndexPaths addObject:newPath];
                        }
                        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [self.tableView endUpdates];
                        
                    }else {
                        
                        [self.communitArray removeAllObjects];
                        [self.communitArray addObjectsFromArray:data];
                        [self.tableView reloadData];
                    }
                    
                }else {
                    
                    if(page>1) {
                        page--;
                    }else {
                        [self.communitArray removeAllObjects];
                        [self.tableView reloadData];
                    }
                }
                
                if(self.communitArray.count==0) {
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无小区数据" eventCallBack:nil];
                    
                    self.nothingnessView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-64);
                    [self.view sendSubviewToBack:self.nothingnessView];
                    self.tableView.alpha = 0;
                }
            });
        };
        
        /** 定位与选择城市相同 */
        if ([currentCity.name isEqualToString:location.cityName]) {
            
            [CommunityManagerPresenters getNearCommunityName:currentCity.name
                                                      cityid:currentCity.ID
                                                        page:[NSString stringWithFormat:@"%ld",(long)pageNum]
                                                   positionx:[NSString stringWithFormat:@"%lf",location.latitude]
                                                   positiony:[NSString stringWithFormat:@"%lf",location.longitude]
                                             UpDataViewBlock:updateBlock];
        }else {
            /** 定位与选择城市不同 */
            [CommunityManagerPresenters getSearchCommunityName:@""
                                                        cityid:currentCity.ID
                                                          page:[NSString stringWithFormat:@"%ld",(long)pageNum]
                                               UpDataViewBlock:updateBlock];
        }
        
    }else if(selectType == CommunityChangeType_Frequently) {
        
        /*获取用户常出入社区*/
        [CommunityManagerPresenters getUserCommonCommunityWithCityid:currentCity.ID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_tableView.mj_header.isRefreshing) {
                    [_tableView.mj_header endRefreshing];
                }
                
                if (self.tableView.mj_footer.isRefreshing) {
                    [self.tableView.mj_footer endRefreshing];
                }
                [_userCommonCommunityArray removeAllObjects];
                
                if (resultCode == SucceedCode) {
                    
                    [_userCommonCommunityArray addObjectsFromArray:data];
                    
                }
                
                [_tableView reloadData];
                
                if(_userCommonCommunityArray.count==0) {
                    
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无小区数据" eventCallBack:nil];
                    
                    self.nothingnessView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-64);
                    [self.view sendSubviewToBack:self.nothingnessView];
                    self.tableView.alpha = 0;
                }
            });
            
        }];
        
    }
    
}

- (void)httpRequestForCertInfoWithCommunityid:(NSString *)communityid communityName:(NSString *)communityName {
    
    THIndicatorVCStart
    [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:communityid UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if (resultCode == SucceedCode) {
             
                NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                
                if (houseArr.count > 0) {
                    
                    //---有房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                    houseListVC.fromType = 1;
                    houseListVC.houseArr = houseArr;
                    houseListVC.carArr = carArr;
                    houseListVC.communityID = communityid;
                    houseListVC.communityName = communityName;
                    [self.navigationController pushViewController:houseListVC animated:YES];
                    
                }else {
                    
                    //---无房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                    addVC.communityID = communityid;
                    addVC.communityName = communityName;
                    addVC.fromType = 1;
                    [self.navigationController pushViewController:addVC animated:YES];
                    
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
        });
    }];
}

#pragma mark - TableView Datasource

/**
 *  设置Header高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_pageSourceType == PAGE_SOURCE_TYPE_MYINFO) {
        return 50;
    }
    return 0;
}
/**
 *  设置headerView 视图
 */
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_pageSourceType == PAGE_SOURCE_TYPE_MYINFO) {
        
        UITableViewHeaderFooterView * headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        UIButton * btn_title;
        
        if (!headerView) {
            headerView=[[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
            
            headerView.contentView.backgroundColor=UIColorFromRGB(0xf1f1f1);
            btn_title=[[UIButton alloc]initWithFrame:CGRectMake(30, 5, tableView.frame.size.width-30, 40)];
            btn_title.titleLabel.font=DEFAULT_SYSTEM_FONT(16);
            btn_title.titleLabel.textColor=UIColorFromRGB(0x595353);
            [btn_title setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [btn_title setTitleColor:UIColorFromRGB(0x595353) forState:UIControlStateNormal];
            [btn_title setImage:[UIImage imageNamed:@"入驻小区_附近"] forState:UIControlStateNormal];
            btn_title.tag=100;
            
            [headerView.contentView addSubview:btn_title];
        }
        
        
        btn_title=[headerView.contentView viewWithTag:100];
        NSString * title = @"附近";
        
        [btn_title setTitle:title forState:UIControlStateNormal];
        [btn_title setTitleEdgeInsets:UIEdgeInsetsMake(0,5,0.0,0.0)];
        return headerView;
        
    }else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (communityChangeType == CommunityChangeType_Frequently) {/** 1 附近社区 2 常出入社区 */
        return _userCommonCommunityArray.count;
    }else {
        return self.communitArray.count;
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChangAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangAreaCell"];
    
    CityCommunityModel *cityModel;
    
    if (communityChangeType == CommunityChangeType_Frequently) {
        cityModel = [_userCommonCommunityArray objectAtIndex:indexPath.row];
    }else {
        cityModel = [self.communitArray objectAtIndex:indexPath.row];
    }
    
    // 回显
    if (_pageSourceType == PAGE_SOURCE_TYPE_BIKE) {
        
        if([cityModel.ID isEqualToString:_bikeCommunityID]) {
            cityModel.isSelect = YES;
        }else {
            cityModel.isSelect = NO;
        }
        
    }else {
        
        if([cityModel.ID isEqualToString:appdgt.userData.communityid]) {
            cityModel.isSelect = YES;
        }else {
            cityModel.isSelect = NO;
        }
    }
    
    [cell setCityModel:cityModel];
    
    return cell;
}

// MARK: - 设置列表高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// MARK: - 事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @WeakObj(self);
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self cleanSelected];
    
    if (communityChangeType == CommunityChangeType_Nearby) {/** 1 附近社区 2 常出入社区 */
        
        currentCommunity = [self.communitArray objectAtIndex:indexPath.row];
      
        currentCommunity.isSelect = !currentCommunity.isSelect;
        
        [self.tableView reloadData];
        
        if ([XYString isBlankString:currentCommunity.ID]) {
            [self showToastMsg:@"修改个人社区失败！" Duration:3.0];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if (_pageSourceType == PAGE_SOURCE_TYPE_MYINFO) {
            
            if (self.myCallBack) {
                self.myCallBack(currentCommunity.ID,currentCommunity.name);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (_pageSourceType == PAGE_SOURCE_TYPE_BIKE) {
            
            if (self.myCallBack) {
                self.myCallBack(currentCommunity.ID,currentCommunity.name);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (_pageSourceType == PAGE_SOURCE_TYPE_COMMUNNITYAUTH) {
            //从社区认证过来
            
            [self httpRequestForCertInfoWithCommunityid:currentCommunity.ID communityName:currentCommunity.name];
            
        }else {
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            [indicator startAnimating:self.tabBarController];
            
            /** 切换小区数据提交 */
            [CommunityManagerPresenters changeCommunityCommunityid:currentCommunity.ID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator stopAnimating];
                    
                    if(resultCode==SucceedCode)
                    {
                    
                        currentCity.name = appdgt.userData.cityname;
                        currentCity.ID = appdgt.userData.cityid;
                        
                        [selfWeak.delegate changeArea];
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [selfWeak showToastMsg:@"修改个人社区失败！" Duration:3.0];
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                    }
                });
                
            }];
        }
        
    }else {
        
        currentCommunity = [_userCommonCommunityArray objectAtIndex:indexPath.row];
        currentCommunity.isSelect=!currentCommunity.isSelect;
        
        [self.tableView reloadData];
        
        if ([XYString isBlankString:currentCommunity.ID]) {
            [self showToastMsg:@"修改个人社区失败！" Duration:3.0];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if (_pageSourceType == PAGE_SOURCE_TYPE_MYINFO) {
            
            if (self.myCallBack) {
                self.myCallBack(currentCommunity.ID,currentCommunity.name);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (_pageSourceType == PAGE_SOURCE_TYPE_BIKE) {
            
            if (self.myCallBack) {
                self.myCallBack(currentCommunity.ID,currentCommunity.name);
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (_pageSourceType == PAGE_SOURCE_TYPE_COMMUNNITYAUTH) {
            //从社区认证过来
            
            [self httpRequestForCertInfoWithCommunityid:currentCommunity.ID communityName:currentCommunity.name];
            
        }else {
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            [indicator startAnimating:self.tabBarController];
            
            /** 切换小区数据提交 */
            [CommunityManagerPresenters changeCommunityCommunityid:currentCommunity.ID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator stopAnimating];
                    
                    if(resultCode==SucceedCode)
                    {
                        currentCity.name = appdgt.userData.cityname;
                        currentCity.ID = appdgt.userData.cityid;
                        
                        [selfWeak.delegate changeArea];
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                        
                    }
                    else
                    {
                        [selfWeak showToastMsg:@"修改个人社区失败！" Duration:3.0];
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                        
                    }
                });
                
            }];
            
        }
        
    }
    
}

#pragma mark - 城市选择事件
- (IBAction)btn_CitySelectEvent:(UIButton *)sender {
    
    ChangCityVC * cityVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangCityVC"];
    cityVC.selectEventBlock=^(id  _Nullable data, UIView * _Nullable view, NSInteger index){
        currentCity=(CityCommunityModel *)data;
        [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:currentCity.name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:cityVC animated:YES];
    
}

// MARK: - 进入搜索
- (IBAction)btn_SearChTextEvent:(UIButton *)sender {
    
    @WeakObj(self);
    
    SearchVC *searchVC=[SearchVC getInstance];
    @WeakObj(searchVC);
    
    [searchVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        
        currentCommunity = ( CityCommunityModel *)data;
        
        if (_pageSourceType == PAGE_SOURCE_TYPE_MYINFO||
            _pageSourceType == PAGE_SOURCE_TYPE_BIKE) {
          
            [searchVCWeak dismissVC];
            
            if (selfWeak.myCallBack) {
                selfWeak.myCallBack(currentCommunity.ID,currentCommunity.name);
            }
            
            [selfWeak.navigationController popViewControllerAnimated:YES];
            
        }else if (_pageSourceType == PAGE_SOURCE_TYPE_COMMUNNITYAUTH) {
            
            [searchVCWeak dismissVC];
            
            [self httpRequestForCertInfoWithCommunityid:currentCommunity.ID communityName:currentCommunity.name];
            
        }else {
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            [indicator startAnimating:self.tabBarController];
            
            ///切换小区数据提交
            [CommunityManagerPresenters changeCommunityCommunityid:currentCommunity.ID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [indicator stopAnimating];
                    
                    if(resultCode==SucceedCode){
                        currentCity.name = appdgt.userData.cityname;
                        currentCity.ID = appdgt.userData.cityid;
                        
                        [searchVCWeak dismissVC];
                        
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        [self showToastMsg:data Duration:3.0];
                    }
                });
            }];
        }
        
    } viewsEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        
        if(index==2){///搜索
            [CommunityManagerPresenters getSearchCommunityName:(NSString *)data cityid:currentCity.ID page:@"1" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(resultCode==SucceedCode) {
                        
                        [searchVCWeak.searchArray removeAllObjects];
                        [searchVCWeak.searchArray addObjectsFromArray:data];
                        [searchVCWeak.tableView reloadData];
                        
                    }else {
                        [self showToastMsg:@"没有找到相关的数据" Duration:5.0];
                    }
                    
                });
            }];
        }
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        
        UITableViewCell * cell=(UITableViewCell *)view;
        CityCommunityModel *selectCommunity =(CityCommunityModel *)data;
        cell.textLabel.text=selectCommunity.name;
        
    }];
}

#pragma mark - helper

/**
 *  设置隐藏列表分割线
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)cleanSelected {
    
    if (self.communitArray.count > 0) {
        CityCommunityModel * ccm;
        for(int i=0;i<self.communitArray.count;i++)
        {
            ccm=[self.communitArray objectAtIndex:i];
            ccm.isSelect=NO;
        }
    }
    
    if (_userCommonCommunityArray.count > 0) {
        CityCommunityModel * ccm1;
        for(int i=0;i<_userCommonCommunityArray.count;i++)
        {
            ccm1=[_userCommonCommunityArray objectAtIndex:i];
            ccm1.isSelect=NO;
        }
    }
}

-(void)location {
    
    [bdmap getLocationInfoForupDateViewsBlock:^(id  _Nullable data, ResultCode resultCode) {
        [bdmap stopLocation];
        
        if (resultCode==SucceedCode) {
            
            location=(LocationInfo *)data;
            
            if(currentCity.ID==nil||[currentCity.ID integerValue]==0) {
                currentCity.name=location.cityName;
                
                [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:currentCity.name forState:UIControlStateNormal];
                
                [AppSystemSetPresenters getCityIDName:currentCity.name UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (resultCode==SucceedCode) {
                            currentCity.ID=(NSString *)data;
                        }
                        
                        [self topRefresh];
                    });
                }];
                
            }else {
                [self topRefresh];
            }
            
        }else {
            
            if(currentCity.ID==nil) {
                
                [self showToastMsg:@"定位失败,请手动选择城市" Duration:5.0];
                
                ChangCityVC * cityVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangCityVC"];
                
                cityVC.selectEventBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index)
                {
                    currentCity=(CityCommunityModel *)data;
                };
                [self.navigationController pushViewController:cityVC animated:YES];
                
            }else {
                [self topRefresh];
            }
            
        }
        
    }];
    
}


@end
