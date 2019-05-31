//
//  ZSY_ChangeAreaViewController.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/11/2.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_ChangeAreaViewController.h"
#import "ChangCityVC.h"
#import "UIButtonImageWithLable.h"
#import "TableViewDataSource.h"
#import "ChangAreaCell.h"
#import "CityCommunityModel.h"
#import "SVPullToRefresh.h"
#import "BDMapFWPresenter.h"
#import "AppSystemSetPresenters.h"
#import "SearchVC.h"
#import "CommunityManagerPresenters.h"
@interface ZSY_ChangeAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    /**
     *  列表显示数据源
     */
    TableViewDataSource * dataSource;
    
    ///当前城市数据
    CityCommunityModel * cityCurr;
    
    ///当前选中社区
    CityCommunityModel * selectCommunit;
    
    ///列表分组数扰
    NSMutableArray * groupArray;
    ///附的社区数据
    NSMutableArray * communitArray;
    ///切换过的小区数据
    NSMutableArray * changedCommunit;
    
    ///定位数据
    LocationInfo * location;
    ///定位功能
    BDMapFWPresenter * bdmap;
    
    AppDelegate * appdgt;
    
    NSInteger page;

}
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

@end

@implementation ZSY_ChangeAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isHiddenRightBar = YES;
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //初始加载数据
    [self.tableView triggerPullToRefresh];
    if (_type == 1) {
        
        changedCommunit = [NSMutableArray new];
        [groupArray replaceObjectAtIndex:0 withObject:changedCommunit];
        
    }else {
        changedCommunit=[UserDefaultsStorage getDataforKey:appdgt.userData.phone];
        
        if (changedCommunit == nil) {
            
            changedCommunit = [NSMutableArray new];
        }
        
        [groupArray replaceObjectAtIndex:0 withObject:changedCommunit];
    }
    
    
}
/**真机开始进行定位*/
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if(SIMULATOR==0)//真机
    {
        ///开始定位
        [self location];
    }
    
}




-(void)viewWillDisappear:(BOOL)animated
{
    if(selectCommunit)
    {
        CityCommunityModel * ccm;
        
        BOOL isSame=NO;
        ///判断是否已存在
        for(int i = 0;i < changedCommunit.count;i++)
        {
            ccm=[changedCommunit objectAtIndex:i];
            
            if([ccm.ID isEqualToString:selectCommunit.ID])
            {
                isSame=YES;
                //修改-------0523pm-------
                break;
            }
        }
        
        if(!isSame)
        {
            [changedCommunit addObject:selectCommunit];
            
        }
        //        appdgt.userData.communityname=selectCommunit.name;
        //        appdgt.userData.communityid=selectCommunit.ID;
        //        appdgt.userData.communityaddress=selectCommunit.address;
        //
        //        appdgt.userData.cityname=cityCurr.name;
        //        appdgt.userData.cityid=cityCurr.ID;
        
        [UserDefaultsStorage saveData:cityCurr forKey:@"CurrentCity"];
    }
    [UserDefaultsStorage saveData:changedCommunit forKey:appdgt.userData.phone];
    
}





#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    appdgt=GetAppDelegates;
    //    self.wantsFullScreenLayout=YES;
    //    self.automaticallyAdjustsScrollViewInsets=YES;
    
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangAreaCell" bundle:nil] forCellReuseIdentifier:@"ChangAreaCell"];
    //    self.tableView.allowsSelection = NO;//列表不可选择
    
    cityCurr=[UserDefaultsStorage getDataforKey:@"CurrentCity"];
    
    if (cityCurr==nil) {
        cityCurr=[CityCommunityModel new];
    }
    
    cityCurr.ID=appdgt.userData.cityid;
    cityCurr.name=appdgt.userData.cityname;
    
    [UserDefaultsStorage saveData:cityCurr forKey:@"CurrentCity"];
    
    if([XYString isBlankString:cityCurr.name])
    {
        [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:@"石家庄市" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:cityCurr.name forState:UIControlStateNormal];
        
    }
    //    [self.btn_NavTitle setTitle:@"石家庄" forState:UIControlStateNormal];
    //    self.btn_NavTitle.contentMode=UIViewContentModeCenter;
    
    self.btn_NavTitle.frame=CGRectMake(0, 0, SCREEN_WIDTH-130, 40);
    
    changedCommunit = [NSMutableArray new];
    groupArray=[NSMutableArray new];
    
    
    [groupArray addObject:changedCommunit];
    communitArray =[NSMutableArray new];
    [groupArray addObject:communitArray];
    
    @WeakObj(self);
    //    dataSource=[[TableViewDataSource alloc]initWithItems:groupArray cellIdentifier:@"ChangAreaCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
    //        [selfWeak setData:item withCell:cell withIndexPath:indexPath];
    //    }];
    //    dataSource.isSection=YES;
    self.tableView.dataSource=self;
    [self setExtraCellLineHidden:self.tableView];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        [selfWeak topRefresh];
        
    } ];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [selfWeak loadmore];
        
    }];
    bdmap=[BDMapFWPresenter new];
    
    /**
     *导航右按钮
     */
    if ([_typeStr  isEqualToString: @"phone"]) {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick:)];
        rightBarItem.tintColor = UIColorFromRGB(0x999999);
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
}



#pragma mark ----------------加载数据--------------------
///定位
-(void)location
{
    //    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    //    [indicator startAnimating:self];
    
    
    [bdmap getLocationInfoForupDateViewsBlock:^(id  _Nullable data, ResultCode resultCode) {
        [bdmap stopLocation];
        
        //        [indicator stopAnimating];
        if (resultCode==SucceedCode) {
            
            location=(LocationInfo *)data;
            
            if(cityCurr.ID==nil||[cityCurr.ID integerValue]==0)
            {
                cityCurr.name=location.cityName;
                
                [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:cityCurr.name forState:UIControlStateNormal];
                
                [AppSystemSetPresenters getCityIDName:cityCurr.name UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        [indicator stopAnimating];
                        
                        if (resultCode==SucceedCode) {
                            cityCurr.ID=(NSString *)data;
                            [self.tableView triggerPullToRefresh];
                        }
                        else
                        {
                            //                            [self showToastMsg:data Duration:5.0];
                        }
                    });
                }];
            }
            
            int i = 0;
            if (i == 0) {
                
                
            }
            else
            {
                [self.tableView triggerPullToRefresh];
            }
        }else{
            if(cityCurr.ID==nil)
            {
                [self showToastMsg:@"定位失败,请手动选择城市" Duration:5.0];
                
                ChangCityVC * cityVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangCityVC"];
                
                cityVC.selectEventBlock=^(id  _Nullable data, UIView * _Nullable view, NSInteger index)
                {
                    cityCurr=(CityCommunityModel *)data;
                };
                [self.navigationController pushViewController:cityVC animated:YES];
                
            }
            else
            {
                [self.tableView triggerPullToRefresh];
            }
        }
    }];
}


///下拉刷新数据
-(void)topRefresh
{
    page=1;
    [self getData:page];
}




///上拉加载更多
-(void)loadmore
{
    page++;
    [self getData:page];
}





-(void)getData:(NSInteger)pageNum
{
    ///定位与选择城市相同
    if ([cityCurr.name isEqualToString:location.cityName]) {
        
        [CommunityManagerPresenters getNearCommunityName:cityCurr.name cityid:cityCurr.ID page:[NSString stringWithFormat:@"%ld",pageNum] positionx:[NSString stringWithFormat:@"%lf",location.latitude] positiony:[NSString stringWithFormat:@"%lf",location.longitude] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hiddenNothingnessView];
                if(resultCode==SucceedCode)
                {
                    
                    if(page>1)
                        
                    {
                        [self.tableView.infiniteScrollingView stopAnimating];
                        
                        NSArray * tmparr=(NSArray *)data;
                        NSInteger count=communitArray.count;
                        
                        [communitArray addObjectsFromArray:tmparr];
                        
                        
                        [self.tableView beginUpdates];//
                        
                        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                        for (int i=0; i<[tmparr count]; i++) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:1];
                            [insertIndexPaths addObject:newPath];
                        }
                        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [self.tableView endUpdates];
                        
                    }
                    else
                    {
                        [self.tableView.pullToRefreshView stopAnimating];
                        [communitArray removeAllObjects];
                        [communitArray addObjectsFromArray:data];
                        [self.tableView reloadData];
                        
                    }
                }
                else
                {
                    if(page>1)
                    {
                        page--;
                        [self.tableView.infiniteScrollingView stopAnimating];
                        //                        [self showToastMsg:@"没有数据了" Duration:5.0];
                    }
                    else{
                        
                        [communitArray removeAllObjects];
                        [self.tableView reloadData];
                        [self.tableView.pullToRefreshView stopAnimating];
                        //                        [self showToastMsg:@"没有找到小区数据" Duration:5.0];
                    }
                    
                    
                    
                }
                if(changedCommunit.count==0&&communitArray.count==0)
                {

                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无小区数据" eventCallBack:nil];

                }
                
            });
        }];
    }
    else{///定位与选择城市不同
        
        [CommunityManagerPresenters getSearchCommunityName:@"" cityid:cityCurr.ID page:[NSString stringWithFormat:@"%ld",pageNum] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hiddenNothingnessView];
                
                if(resultCode==SucceedCode)
                {
                    
                    if(page>1)
                    {
                        [self.tableView.infiniteScrollingView stopAnimating];
                        NSArray * tmparr=(NSArray *)data;
                        NSInteger count=communitArray.count;
                        [communitArray addObjectsFromArray:tmparr];
                        
                        [self.tableView beginUpdates];
                        
                        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                        
                        for (int i=0; i<[tmparr count]; i++) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:1];
                            [insertIndexPaths addObject:newPath];
                        }
                        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                        [self.tableView endUpdates];
                        
                    }
                    else
                    {
                        [self.tableView.pullToRefreshView stopAnimating];
                        [communitArray removeAllObjects];
                        [communitArray addObjectsFromArray:data];
                        [self.tableView reloadData];
                        
                    }
                }
                else
                {
                    if(page>1)
                    {
                        page--;
                        
                        [self.tableView.infiniteScrollingView stopAnimating];
                        //                        [self showToastMsg:@"没有数据了" Duration:5.0];
                    }
                    else{
                        
                        [communitArray removeAllObjects];
                        [self.tableView reloadData];
                        [self.tableView.pullToRefreshView stopAnimating];
                        //                        [self showToastMsg:@"没有找到小区数据" Duration:5.0];
                    }
                    
                }
                if(changedCommunit.count==0&&communitArray.count==0)
                {
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无小区数据" eventCallBack:nil];

                }
                
            });
        }];
    }
}



#pragma mark ----------关于列表数据及协议处理--------------
-(void)cleanSelected
{
    CityCommunityModel * ccm;
    for(int i=0;i<communitArray.count;i++)
    {
        ccm=[communitArray objectAtIndex:i];
        ccm.isSelect=NO;
    }
}



/**
 *  设置隐藏列表分割线
 *
 *  @param tableView tableView description
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}




/**
 *  设置列表数据
 *
 *  @param data      <#data description#>
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
-(void)setData:(id) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    ChangAreaCell * caCell=(ChangAreaCell *)cell;
    CityCommunityModel * ccm=(CityCommunityModel *)data;
    
    caCell.lab_AreaName.text=ccm.name;
    caCell.lab_Addrs.text=ccm.address;
    //    caCell.cellSelectCallBack=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
    //        [self cleanSelected];
    //        ccm.isSelect=!ccm.isSelect;
    //        selectCommunit=ccm;
    //        [self.tableView reloadData];
    //
    //    };
    if(changedCommunit.count>0)
    {
        if(indexPath.section==0)
        {
            //            if([ccm.ID integerValue]==[appdgt.userData.communityid integerValue])
            //            {
            //                ccm.isSelect=YES;
            //            }
            if([ccm.ID isEqualToString:appdgt.userData.communityid])
            {
                ccm.isSelect=YES;
            }
        }
    }
    else
    {
        //        if([ccm.ID integerValue]==[appdgt.userData.communityid integerValue])
        //        {
        //            ccm.isSelect=YES;
        //        }
        if([ccm.ID isEqualToString:appdgt.userData.communityid])
        {
            ccm.isSelect=YES;
        }
    }
    
    if(ccm.isSelect)
    {
        [caCell.btn_Selected setImage:[UIImage imageNamed:@"单选_选中"] forState:UIControlStateNormal];
    }
    else
    {
        [caCell.btn_Selected setImage:[UIImage imageNamed:@"单选_未选中"] forState:UIControlStateNormal];
    }
    
    
}




#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger count=[[groupArray objectAtIndex:section] count];
    return count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count=1;
    
    count=[groupArray count];
    return count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"ChangAreaCell" forIndexPath:indexPath];
    
    CityCommunityModel * ccm=[[groupArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self setData:ccm withCell:cell withIndexPath:indexPath];
    NSLog(@"%@=======%@",ccm.ID,ccm.name);
    
    return cell;
}




/**
 *  设置列表高度
 *
 *  @param tableView tableView description
 *  @param indexPath indexPath description
 *
 *  @return return value description
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @WeakObj(self);
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section==1)
    {
        [self cleanSelected];
        
        CityCommunityModel * ccm=[communitArray objectAtIndex:indexPath.row];
        ccm.isSelect=!ccm.isSelect;
        selectCommunit=ccm;
        [self.tableView reloadData];
    }
    else{
        
        [self cleanSelected];
        CityCommunityModel * ccm=[changedCommunit objectAtIndex:indexPath.row];
        ccm.isSelect=!ccm.isSelect;
        selectCommunit=ccm;
        [self.tableView reloadData];
        
    }
    
    if ([XYString isBlankString:selectCommunit.ID]) {
        [self showToastMsg:@"修改个人社区失败！" Duration:3.0];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_type == 1) {
        
        if (self.myCallBack) {
            self.myCallBack(selectCommunit.ID,selectCommunit.name);
            appdgt.userData.communityname = selectCommunit.name;
            appdgt.userData.communityid = selectCommunit.ID;
            [appdgt saveContext];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
        
        ///切换小区数据提交
        [CommunityManagerPresenters changeCommunityCommunityid:selectCommunit.ID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if(resultCode==SucceedCode)
                {
                    NSDictionary * dic=(NSDictionary *)data;
                    NSString *carprefix=[dic objectForKey:@"carprefix"];
                    
                    appdgt.userData.carprefix=carprefix;
                    appdgt.userData.cityid=[[dic objectForKey:@"cityid"] stringValue];
                    appdgt.userData.cityname=[dic objectForKey:@"cityname"];
                    appdgt.userData.openmap=[dic objectForKey:@"openmap"];
                    appdgt.userData.lat=[[dic objectForKey:@"lat"] stringValue];
                    appdgt.userData.lng=[[dic objectForKey:@"lng"] stringValue];
                    appdgt.userData.countyid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"countyid"]];
                    appdgt.userData.countyname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"countyname"]];
                    cityCurr.name = appdgt.userData.cityname;
                    cityCurr.ID = appdgt.userData.cityid;
                    
                    appdgt.userData.communityname=selectCommunit.name;
                    appdgt.userData.communityid=selectCommunit.ID;
                    appdgt.userData.communityaddress=selectCommunit.address;
                    
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"isChangeSheQu"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [appdgt saveContext];
                    
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

/**
 *  设置Header高度
 *
 *  @param tableView tableView description
 *  @param section   section description
 *
 *  @return return value description
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 50;
}
/**
 *  设置headerView 视图
 *
 *  @param tableView tableView description
 *  @param section   section description
 *
 *  @return return value description
 */
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    UIButton * btn_title;
    
    if (!headerView) {
        headerView=[[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
        //        headerView.backgroundColor=UIColorFromRGB(0xf1f1f1);
        
        headerView.contentView.backgroundColor=UIColorFromRGB(0xf1f1f1);
        //        headerView.backgroundView=[[UIView alloc]init];
        btn_title=[[UIButton alloc]initWithFrame:CGRectMake(30, 5, tableView.frame.size.width-30, 40)];
        //        btn_title.backgroundColor=UIColorFromRGB(0xf1f1f1);
        btn_title.titleLabel.font=DEFAULT_SYSTEM_FONT(16);
        btn_title.titleLabel.textColor=UIColorFromRGB(0x595353);
        [btn_title setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn_title setTitleColor:UIColorFromRGB(0x595353) forState:UIControlStateNormal];
        [btn_title setImage:[UIImage imageNamed:@"入驻小区_附近"] forState:UIControlStateNormal];
        btn_title.tag=100;
        
        [headerView.contentView addSubview:btn_title];
    }
    
    
    btn_title=[headerView.contentView viewWithTag:100];
    NSString * title=@"附近";
    
    if (section==0) {//常住
        title=@"";
        [btn_title setImage:nil forState:UIControlStateNormal];
        
    }
    else if (section==1)//附近
    {
        title=@"附近";
    }
    [btn_title setTitle:title forState:UIControlStateNormal];
    [btn_title setTitleEdgeInsets:UIEdgeInsetsMake(0,5,
                                                   0.0,
                                                   0.0)];
    return headerView;
}





#pragma mark ----------事件处理--------------
/**
 *  城市选择事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_CitySelectEvent:(UIButton *)sender {
    ChangCityVC * cityVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangCityVC"];
    cityVC.selectEventBlock=^(id  _Nullable data, UIView * _Nullable view, NSInteger index)
    {
        cityCurr=(CityCommunityModel *)data;
        [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:cityCurr.name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:cityVC animated:YES];
}


///进入搜索
- (IBAction)btn_SearChTextEvent:(UIButton *)sender {
    
    @WeakObj(self);
    
    SearchVC *searchVC=[SearchVC getInstance];
    @WeakObj(searchVC);
    
    [searchVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        
        CityCommunityModel * ccm=( CityCommunityModel *)data;
        selectCommunit=ccm;
        
        if (_type == 1) {
            [searchVCWeak dismissVC];
            
            if (selfWeak.myCallBack) {
                selfWeak.myCallBack(ccm.ID,ccm.name);
            }
            
            [selfWeak.navigationController popViewControllerAnimated:YES];
            
        }else {
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            [indicator startAnimating:self.tabBarController];
            
            ///切换小区数据提交
            [CommunityManagerPresenters changeCommunityCommunityid:ccm.ID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [indicator stopAnimating];
                    
                    if(resultCode==SucceedCode)
                    {
                        NSDictionary * dic=(NSDictionary *)data;
                        NSString *carprefix=[dic objectForKey:@"carprefix"];
                        appdgt.userData.carprefix=carprefix;
                        appdgt.userData.cityid=[[dic objectForKey:@"cityid"] stringValue];
                        appdgt.userData.cityname=[dic objectForKey:@"cityname"];
                        appdgt.userData.openmap=[dic objectForKey:@"openmap"];
                        appdgt.userData.lat=[[dic objectForKey:@"lat"] stringValue];
                        appdgt.userData.lng=[[dic objectForKey:@"lng"] stringValue];
                        appdgt.userData.countyid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"countyid"]];
                        appdgt.userData.countyname=[NSString stringWithFormat:@"%@",[dic objectForKey:@"countyname"]];
                        cityCurr.name=appdgt.userData.cityname;
                        cityCurr.ID=appdgt.userData.cityid;
                        
                        appdgt.userData.communityname=ccm.name;
                        appdgt.userData.communityid=ccm.ID;
                        appdgt.userData.communityaddress=ccm.address;
                        
                        [appdgt saveContext];
                        
                        [searchVCWeak dismissVC];
                        
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        //[self showToastMsg:data Duration:5.0];
                    }
                    
                });
                
            }];
            
            
        }
        
    } viewsEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if(index==2)///搜索
        {
            [CommunityManagerPresenters getSearchCommunityName:(NSString *)data cityid:cityCurr.ID page:@"1" UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(resultCode==SucceedCode)
                    {
                        [searchVCWeak.searchArray removeAllObjects];
                        [searchVCWeak.searchArray addObjectsFromArray:data];
                        [searchVCWeak.tableView reloadData];
                    }
                    else
                    {
                        [self showToastMsg:@"没有找到相关的数据" Duration:5.0];
                        
                    }
                    
                });
            }];
            
        }
        
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        
        UITableViewCell * cell=(UITableViewCell *)view;
        CityCommunityModel *cmm =(CityCommunityModel *)data;
        cell.textLabel.text=cmm.name;
    }];
}

#pragma  mark ---------------删除常用小区功能----------------

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
        CityCommunityModel * ccm=[[groupArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if(ccm.isSelect)
        {
            return UITableViewCellEditingStyleNone;
        }
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}



/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        /*此处处理自己的代码，如删除数据*/
        /*删除tableView中的一行*/
        
        //        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[groupArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        NSLog(@"count ==%ld",changedCommunit.count);
        
        
    }
}
#pragma mark ---- 导航按钮点击事件
- (void)rightBarItemClick:(UIBarButtonItem *)rightItem {
    
    ChangCityVC * cityVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangCityVC"];
    cityVC.type = _typeStr;
    cityVC.selectEventBlock=^(id  _Nullable data, UIView * _Nullable view, NSInteger index)
    {
        cityCurr=(CityCommunityModel *)data;
        [self.btn_NavTitle setrightImage:[UIImage imageNamed:@"下箭头"] withTitle:cityCurr.name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:cityVC animated:YES];
    
}


@end
