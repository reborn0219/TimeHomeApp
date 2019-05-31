//
//  RentalAndSalesTableVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RentalAndSalesTableVC.h"
#import "TableViewDataSource.h"
#import "BtmFilterTools.h"
#import "RentalAndSalesCell.h"
#import "PickViewVC.h"
#import "PricePopVC.h"
#import "MultipleChoicesPopVC.h"
#import "RentalAndSalesDetailVC.h"
#import "ParkingDetailVC.h"
#import "ReleaseRentalParking.h"
#import "SolicitingHouseVC.h"
#import "HouseFunctionVC.h"

#import "BMSpacePresenter.h"
#import "BMRoomPresenter.h"
#import "BMCityPresenter.h"
#import "DateUitls.h"

#import "AppSystemSetPresenters.h"

/**
 *  地图
 */
#import "GetAddressMapVC.h"
/**
 *  定位
 */
#import "BDMapFWPresenter.h"

@interface RentalAndSalesTableVC ()<UITableViewDelegate, UITextFieldDelegate>
{
    AppDelegate *appDelegate;
    /**
     *  列表显示数据源
     */
    TableViewDataSource * dataSource;
    /**
     *  0 出租 1 买卖
     */
    NSString *sertype;
    /**
     *  传递0则为社区属于的城市id；
     */
    NSString *cityid;
    /**
     *  区域id
     */
    NSString *countyid;
    /**
     *  金额区间开始
     */
    NSString *moneybegin;
    /**
     *  金额区间结束
     */
    NSString *moneyend;
    /**
     *  负数为不限 是否固定车位：0否1是
     */
    NSString *fixed;
    /**
     *  负数为不限 是否地下车位：0否1 是
     */
    NSString *underground;
    /**
     *  返回的列表字段 + 排序 asc顺序 desc倒序
     */
    NSString *orderby;
    /**
     *  分页页码
     */
    NSInteger page;
    /**
     *  用户信息
     */
    UserData *userData;
    /**
     *  请求数据数组
     */
    NSMutableArray *dataArray;
    /**
     *  城市区
     */
    NSArray * arrayDistrict;
    /**
     *  价格
     */
    NSInteger start;
    NSInteger end;
    
    ///厅室选择数据
    NSMutableArray * bedRoom;
    ///选择厅室
    NSString *bedroom;
    /**
     *  定位功能
     */
    BDMapFWPresenter * bdmap;
    /**
     *  定位数据
     */
    LocationInfo * location;
    
    ///滚动偏移
    CGFloat _oldOffset;
    ///是否显示底部菜单
    BOOL isShowBottom;
    
}
/**
 *  显示房屋列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  搜索关键字
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_SearchText;

/**
 *  底部条件工具
 */
@property (weak, nonatomic) IBOutlet BtmFilterTools *v_BtmFilters;
/**
 *  底部条件工具高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_bottomHeight;


@end

@implementation RentalAndSalesTableVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [self getDistrictData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self.tableView.mj_header beginRefreshing];
    
    if (userData.cityid.intValue != 0) {
    
        [self getDistrictData];
        
    }else {
        
        [self getLocation];
        
    }
    
}
///返回事件
-(void)backButtonClick
{
    if(self.isFromeRelease)
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HouseFunctionVC class]]) {
                HouseFunctionVC * vc=(HouseFunctionVC *)controller;
                if(_jmpCode==0||_jmpCode==1)
                {
                    vc.jumpCode = 0;
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
                if(_jmpCode==2||_jmpCode==3||_jmpCode==4||_jmpCode==5)
                {
                    vc.jumpCode = 1;
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
                
            }
//            if ([controller isKindOfClass:[THMyPublishCarLocationViewController class]]) {
//                if(_jmpCode==2||_jmpCode==3||_jmpCode==4||_jmpCode==5)
//                {
//                    [self.navigationController popToViewController:controller animated:YES];
//                    break;
//                }
//                
//            }
//            if ([controller isKindOfClass:[THMyPublishHouseListViewController class]]) {
//                THMyPublishHouseListViewController * vc=(THMyPublishHouseListViewController *)controller;
//                if(_jmpCode==0||_jmpCode==1)
//                {
//                    vc.publishType = 0;
//                    [self.navigationController popToViewController:controller animated:YES];
//                    break;
//                }
//                
//            }
            
        }
    }
    else
    {
        [super backButtonClick];
    }
    
}



/**
 *  车位出租，出售网络请求 refresh = YES为刷新，NO为加载
 */
- (void)carSearchhttpRequestForRefreshIsOrNot:(BOOL)refresh {

    NSDictionary *dict = @{@"sertype":sertype,@"cityid":cityid,@"countyid":countyid,@"moneybegin":moneybegin,@"moneyend":moneyend,@"fixed":fixed,@"underground":underground,@"name":self.TF_SearchText.text,@"orderby":orderby,@"page":[NSString stringWithFormat:@"%ld",page]};
    
    @WeakObj(self);
    [BMSpacePresenter getAppSearchCarrental:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(resultCode == SucceedCode)
            {
                if (refresh) {
                    [selfWeak.tableView.mj_header endRefreshing];

                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                }else {
                    if (((NSArray *)data).count == 0) {
                        page --;
                    }
                    [selfWeak.tableView.mj_footer endRefreshing];

                    NSArray * tmparr=(NSArray *)data;
                    NSInteger count=dataArray.count;
                    [dataArray addObjectsFromArray:tmparr];
                    [self.tableView beginUpdates];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                    for (int i=0; i<[tmparr count]; i++) {
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];

                }
                _tableView.hidden = NO;
            }
            else
            {
                if (refresh)
                {
                    [selfWeak.tableView.mj_header endRefreshing];
                    [dataArray removeAllObjects];
                    [_tableView reloadData];
                }
                else{
                    page --;
                    [selfWeak.tableView.mj_footer endRefreshing];

                }
//                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            if (dataArray.count == 0) {
                if([countyid isEqualToString:@"0"]&&moneybegin.length==0&&moneyend.length==0&&orderby.length==0&&[underground isEqualToString:@"-1"]&&[fixed isEqualToString:@"-1"]&&self.TF_SearchText.text.length==0)
                {
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无车位" eventCallBack:nil];
                }else {
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无车位" eventCallBack:nil];
                    _tableView.hidden = YES;
                    [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                }
            }
            
        });

        
    } withInfo:dict];
    
}
/**
 *  搜索求购,求租车位网络请求 refresh = YES为刷新，NO为加载
 */
- (void)carWantSearchhttpRequestForRefreshIsOrNot:(BOOL)refresh {
    
    NSDictionary *dict = @{@"sertype":sertype,@"cityid":cityid,@"countyid":countyid,@"moneybegin":moneybegin,@"moneyend":moneyend,@"name":self.TF_SearchText.text,@"orderby":orderby,@"page":[NSString stringWithFormat:@"%ld",page]};
    
    @WeakObj(self);
    
    [BMSpacePresenter getAppSearchCarrentalWant:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if(resultCode == SucceedCode)
            {
                if (refresh) {
                    [selfWeak.tableView.mj_header endRefreshing];
                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                    
                }else {
                    if (((NSArray *)data).count == 0) {
                        page --;
                    }
                    [selfWeak.tableView.mj_footer endRefreshing];

                    NSArray * tmparr=(NSArray *)data;
                    NSInteger count=dataArray.count;
                    [dataArray addObjectsFromArray:tmparr];
                    [self.tableView beginUpdates];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                    for (int i=0; i<[tmparr count]; i++) {
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                    
                }
                _tableView.hidden = NO;
            }
            else
            {
                if (refresh)
                {
                    [selfWeak.tableView.mj_header endRefreshing];
                    [dataArray removeAllObjects];
                    [_tableView reloadData];
                }
                else{
                    page --;
                    [selfWeak.tableView.mj_footer endRefreshing];
                }
//                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            if (dataArray.count == 0) {
                if([countyid isEqualToString:@"0"]&&moneybegin.length==0&&moneyend.length==0&&orderby.length==0&&[underground isEqualToString:@"-1"]&&[fixed isEqualToString:@"-1"]&&self.TF_SearchText.text.length==0)
                {
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无车位" eventCallBack:nil];
                }else {
                    _tableView.hidden = YES;
                    [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                }
            
            }
            
        });

        
    } withInfo:dict];

    
}

/**
 *  搜索求购,求租房屋网络请求 refresh = YES为刷新，NO为加载
 sertype	2 求租 3 求购
 cityid	传递0则为社区属于的城市id；
 countyid	区域id
 moneybegin	价格区间开始 如果传递 – 负数则不查询
 moneyend	价格区间结束 如果传递 – 负数则不查询
 bedroom	卧室数量 – 负数不查询 1 2 3 4 99 分别表示 整租一室，整租两室，整租三室，整租四室及以上，单间合租
 title	标题模糊搜索
 orderby	返回的列表字段 + 排序 asc顺序 desc倒序
 page	分页页码
 */
- (void)roomWantSearchForRefreshIsOrNot:(BOOL)refresh {
    
    NSDictionary *dict = @{@"sertype":sertype,
                           @"cityid":cityid,
                           @"countyid":countyid,
                           @"moneybegin":moneybegin,
                           @"moneyend":moneyend,
                           @"bedroom":bedroom,
                           @"title":self.TF_SearchText.text,
                           @"orderby":orderby,
                           @"page":[NSString stringWithFormat:@"%ld",page]};
    
    @WeakObj(self);
    
    [BMRoomPresenter getAppSearchResidenceWant:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(resultCode == SucceedCode)
            {
                if (refresh) {
                    [selfWeak.tableView.mj_header endRefreshing];

                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                }else {
                    if (((NSArray *)data).count == 0) {
                        page --;
                    }
                    [selfWeak.tableView.mj_footer endRefreshing];

                    NSArray * tmparr=(NSArray *)data;
                    NSInteger count=dataArray.count;
                    [dataArray addObjectsFromArray:tmparr];
                    [self.tableView beginUpdates];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                    for (int i=0; i<[tmparr count]; i++) {
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                    
                }
                _tableView.hidden = NO;

            }
            else
            {
                if (refresh)
                {
                    [selfWeak.tableView.mj_header endRefreshing];
                    [dataArray removeAllObjects];
                    [_tableView reloadData];
                }
                else{
                   page --;
                    [selfWeak.tableView.mj_footer endRefreshing];
                }
                
//                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            if (dataArray.count == 0) {
                
                if([countyid isEqualToString:@"0"]&&moneybegin.length==0&&moneyend.length==0&&orderby.length==0&&bedroom.length==0&&self.TF_SearchText.text.length==0)
                {
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无房源信息" eventCallBack:nil];
                }else {
//                    [selfWeak showToastMsg:@"暂无数据" Duration:5];
                    _tableView.hidden = YES;
                    [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                }
            }
            
        });
        
        
    } withInfo:dict];
    
    
}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[UINib nibWithNibName:@"RentalAndSalesCell" bundle:nil] forCellReuseIdentifier:@"RentalAndSalesCell"];

    appDelegate = GetAppDelegates;
    userData = appDelegate.userData;
    
    switch (_jmpCode) {
        case 0:
        {
            bedRoom=[NSMutableArray new];
            NSArray * tmp=@[@"整租一室", @"整租两室", @"整租三室", @"整租四室及以上", @"单间合租"];
            MultipleChoicesModel * mcm;
            for(int i=0;i<tmp.count;i++)
            {
                mcm=[MultipleChoicesModel new];
                mcm.title=[tmp objectAtIndex:i];
                [bedRoom addObject:mcm];
            }
            sertype=@"2";

        }
            break;
        case 1:
        {
            bedRoom=[NSMutableArray new];
            NSArray * tmp=@[@"一室",@"两室",@"三室",@"四室及以上"];
            MultipleChoicesModel * mcm;
            for(int i=0;i<tmp.count;i++)
            {
                mcm=[MultipleChoicesModel new];
                mcm.title=[tmp objectAtIndex:i];
                [bedRoom addObject:mcm];
            }
            sertype=@"3";

        }
            break;
        case 2:
        {
            //车位求租
            sertype = @"2";
        }
            break;
        case 3:
        {
            //车位求购
            sertype = @"3";
        }
            break;
        case 4:
        {
            //车位出租
            sertype = @"0";
        }
            break;
        case 5:
        {
            //车位出售
            sertype = @"1";
        }
            break;
        default:
            break;
    }
    cityid      = @"0";
    countyid    = @"0";
    moneybegin  = @"";
    moneyend    = @"";
    fixed       = @"-1";
    underground = @"-1";
    orderby     = @"";
    page        = 1;
    start       = 0;
    end         = 4;
    if(_jmpCode==0||_jmpCode==1)
    {
        end=7;
    }
    
    
    bedroom=@"";
    dataArray = [[NSMutableArray alloc]init];
    @WeakObj(self);
    dataSource=[[TableViewDataSource alloc]initWithItems:dataArray cellIdentifier:@"RentalAndSalesCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
        [selfWeak setData:item withCell:cell withIndexPath:indexPath];
    }];
    dataSource.isSection=NO;
    self.tableView.dataSource=dataSource;
    [self setExtraCellLineHidden:self.tableView];
    
    
    if(_jmpCode==0||_jmpCode==1)//求租，求购
    {
        [self setBottomFilters ];
    }
    else if (_jmpCode==2||_jmpCode==3)//车位求租，求购
    {
        [self setCarSolicitingBottomFilters];
    }
    else if (_jmpCode==4||_jmpCode==5)//车位出租，出售
    {
        [self setCarBottomFilters];
    }
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        if(_jmpCode==0||_jmpCode==1)//求租，求购
        {
            [self roomWantSearchForRefreshIsOrNot:YES];
        }
        else if (_jmpCode==2||_jmpCode==3)//车位求租，求购
        {
            [self carWantSearchhttpRequestForRefreshIsOrNot:YES];
        }
        else if (_jmpCode==4||_jmpCode==5)//车位出租，出售
        {
            [self carSearchhttpRequestForRefreshIsOrNot:YES];
        }
    }];
    

    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        page ++;
        if(_jmpCode==0||_jmpCode==1)//求租，求购
        {
            [self roomWantSearchForRefreshIsOrNot:NO];
        }
        else if (_jmpCode==2||_jmpCode==3)//车位求租，求购
        {
            [self carWantSearchhttpRequestForRefreshIsOrNot:NO];
        }
        else if (_jmpCode==4||_jmpCode==5)//车位出租，出售
        {
            [self carSearchhttpRequestForRefreshIsOrNot:NO];
        }

    }];
    
    _TF_SearchText.delegate = self;
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"发布信息" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick)];
    bar.tintColor = PURPLE_COLOR;
    self.navigationItem.rightBarButtonItem = bar;
    
}
- (void)rightBarClick {
    
    //房屋求租求售
    if (self.jmpCode == 0 || self.jmpCode == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LifeTab" bundle:nil];
        HouseFunctionVC *hfVC    = [storyboard instantiateViewControllerWithIdentifier:@"HouseFunctionVC"];
        hfVC.jumpCode            = 2;
        hfVC.title = @"选择发布类别";
        [self.navigationController pushViewController:hfVC animated:YES];
        
    }else {
        //车位
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LifeTab" bundle:nil];
        HouseFunctionVC *hfVC    = [storyboard instantiateViewControllerWithIdentifier:@"HouseFunctionVC"];
        hfVC.jumpCode            = 3;
        hfVC.title = @"选择发布类别";
        [self.navigationController pushViewController:hfVC animated:YES];
        
    }

}
/**
 *  搜索
 */
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {

    [_TF_SearchText resignFirstResponder];
    [self.tableView.mj_header beginRefreshing];
    
    return YES;
}
/**
 *  房屋求租、求购条件
 */
-(void)setBottomFilters
{
    NSMutableArray * arr=[NSMutableArray new];
    MenuModel * filter=[[MenuModel alloc]init];
    filter.title=@"区域";
    filter.imgName=@"车位租售_区域";
    [arr addObject:filter];
    
    filter=[[MenuModel alloc]init];
    filter.title=@"厅室";
    filter.imgName=@"房屋租售_厅室";
    [arr addObject:filter];
    
    filter=[[MenuModel alloc]init];
    filter.title=@"价格";
    filter.imgName=@"车位租售_价格";
    [arr addObject:filter];
    
    self.v_BtmFilters.FilterArray=arr;
    @WeakObj(self);
    self.v_BtmFilters.eventCallBack=^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        NSLog(@"index==%ld",(long)index);
        

        NSLog(@"index==%ld",(long)index);
        if (index==0) {//区域
            //区域
            [selfWeak selectCounty];
        }
        else if(index==1)//厅室
        {
            [selfWeak selectBedRomm];
        }
        else if (index==2)//价格
        {
            [selfWeak selectRSPrice];
            
        }


    };
}
/**
 *  车位求租、求购条件
 */
-(void)setCarSolicitingBottomFilters
{
    NSMutableArray * arr=[NSMutableArray new];
    MenuModel * filter=[[MenuModel alloc]init];
    filter.title=@"区域";
    filter.imgName=@"车位租售_区域";
    [arr addObject:filter];

    
    filter=[[MenuModel alloc]init];
    filter.title=@"价格";
    filter.imgName=@"车位租售_价格";
    [arr addObject:filter];
    
    self.v_BtmFilters.FilterArray=arr;
    @WeakObj(self);
    self.v_BtmFilters.eventCallBack=^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if (index==0) {
            //区域
            [selfWeak selectCounty];
        }
        else if (index==1)
        {
            //价格
            [selfWeak selectRSPrice];
        }
    };
}
/**
 *  车位出租、出信条件
 */
-(void)setCarBottomFilters
{
    NSMutableArray * arr=[NSMutableArray new];
    MenuModel * filter=[[MenuModel alloc]init];
    filter.title=@"区域";
    filter.imgName=@"车位租售_区域";
    [arr addObject:filter];

    
    filter=[[MenuModel alloc]init];
    filter.title=@"价格";
    filter.imgName=@"车位租售_价格";
    [arr addObject:filter];
    
    filter=[[MenuModel alloc]init];
    filter.title=@"地下";
    filter.imgName=@"车位租售_地下";
    [arr addObject:filter];
    
    filter=[[MenuModel alloc]init];
    filter.title=@"固定";
    filter.imgName=@"车位租售_固定";
    [arr addObject:filter];
    
    filter=[[MenuModel alloc]init];
    filter.title=@"排序";
    filter.imgName=@"车位租售_排序";
    [arr addObject:filter];
    
    self.v_BtmFilters.FilterArray=arr;
    @WeakObj(self);
    self.v_BtmFilters.eventCallBack=^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if (index==0) {
            //区域
            [selfWeak selectCounty];
        }
        else if (index==1)
        {
            //价格
            [selfWeak selectPrice];
        }
        else if (index==2)
        {
            //地下
            [selfWeak selectGround];
        }
        else if (index==3)
        {
            //固定
            [selfWeak selectFix];
        }
        else if (index==4)
        {
            //排序
            [selfWeak selectAscOrDesc];
        }

    };
    
}
/**
 *  选择区域
 */
- (void)selectCounty {
    
    if(arrayDistrict==nil||arrayDistrict.count==0)
    {
        [self showToastMsg:@"没有获取市区数据" Duration:2];
        return ;
    }
    NSMutableArray * ary=[NSMutableArray new];
    [ary addObject:@"不限"];
    NSDictionary * dic;
    for(int i=0;i<arrayDistrict.count;i++)
    {
        dic=[arrayDistrict objectAtIndex:i];
        [ary addObject:[dic objectForKey:@"name"]];
    }
    PickViewVC * pickView=[PickViewVC getInstance];
    MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:0];
    if([filter.title isEqualToString:@"区域"])
    {
        pickView.selectStr=@"不限";
    }
    else
    {
        pickView.selectStr=filter.title;
    }
    @WeakObj(self);
    [pickView showPickView:selfWeak pickData:ary EventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if (index==ALERT_OK) {
            NSString * name=(NSString *)data;
            MenuModel * filter=[selfWeak.v_BtmFilters.FilterArray objectAtIndex:0];
            filter.title=name;
            [selfWeak.v_BtmFilters setTitleTextChangeForIndex:0];
            [self.v_BtmFilters setItemChangeForIndex:0 color:UIColorFromRGB(0xffffff)];
            if([name isEqualToString:@"不限"])
            {
                filter.title=@"区域";
                [selfWeak.v_BtmFilters setTitleTextChangeForIndex:0];
                countyid=@"0";
            }
            else
            {
                NSDictionary * dtmp;
                for(int i=0;i<arrayDistrict.count;i++)
                {
                    dtmp=[arrayDistrict objectAtIndex:i];
                    if([name isEqualToString:[dtmp objectForKey:@"name"]])
                    {
                        countyid=[[dtmp objectForKey:@"id"] stringValue];
                        break;
                    }
                }
                [self.v_BtmFilters setItemChangeForIndex:0 color:UIColorFromRGB(0xcf6262)];
                
            }
            [selfWeak.tableView.mj_header beginRefreshing];
        }
        
    }];

    
}
///选择厅室显示
-(void)selectBedRomm
{
    MultipleChoicesPopVC *mcpVC=[MultipleChoicesPopVC getInstance];
    
    //整租一室，整租两室，整租三室，整租四室及以上，单间合租
    
    [mcpVC showPopView:self data:bedRoom eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if (index==ALERT_OK) {
            NSLog(@"data==%@",data);
            MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:1];
            filter.title=@"厅室";
            MultipleChoicesModel * mcm;
//            int count=0;
            NSMutableString * str=[NSMutableString new];
            [str appendString:@""];
            [self.v_BtmFilters setItemChangeForIndex:1 color:UIColorFromRGB(0xffffff)];
            for(int i=0;i<bedRoom.count;i++)
            {
                mcm=[bedRoom objectAtIndex:i];
                NSLog(@"select==%@",mcm.isSelect?@"YES":@"NO");
                if(mcm.isSelect)
                {
                    filter.title=mcm.title;
                    if(_jmpCode==1)
                    {
                        [str appendString:[NSString stringWithFormat:@"%d",i+1]];
                        [str appendString:@","];
                    }
                    else
                    {
                        if(i==(bedRoom.count-1))
                        {
                            [str appendString:@"99,"];
                        }
                        else
                        {
                            [str appendString:[NSString stringWithFormat:@"%d",i+1]];
                            [str appendString:@","];
                        }

                    }
                    
                }
                
            }
            if(str.length>1)
            {
                [str deleteCharactersInRange:NSMakeRange([str length]-1, 1)];
                bedroom=str;
                [self.v_BtmFilters setItemChangeForIndex:1 color:UIColorFromRGB(0xcf6262)];
            }
            else
            {
                bedroom=@"";
            }
            
            if(bedroom.length>1)
            {
                filter.title=@"多选";
            }
            [self.v_BtmFilters setTitleTextChangeForIndex:1];
            [self.tableView.mj_header beginRefreshing];

            
        }
    }];
    mcpVC.lab_Title.text=@"厅室";
}

///求租，求购价格
-(void)selectRSPrice
{
    NSInteger index1 = 1;
    if (_jmpCode == 0 || _jmpCode == 1) {
        index1 = 2;
    }
    NSArray * array;
    switch (_jmpCode) {
        case 0: ///房屋求售
        {
            array=@[@"不限",@"500元以下/月",@"500-1000元/月",@"1000-1500元/月",@"1500-2000元/月",@"2000-3000元/月",@"3000-5000元/月",@"5000元以上/月"];
        }
            break;
        case 1:
        {
            //房屋求售
            array=@[@"不限",@"50万元以下", @"50-100万元", @"100-150万元",
                    @"150-200万元", @"200-300万元", @"300-500万元", @"500万元以上"];
        }
            break;
        case 2:
        {
            //车位求租
            array=@[@"不限",@"100元以下/月",@"100-200元/月",@"200-300元/月",@"300-500元/月",@"500元以上/月"];
        }
            break;
        case 3:
        {
            //车位求售
            array=@[@"不限",@"5万元以下",@"5-10万元",@"10-15万元",@"15-20万元",@"20万元以上"];
        }
            break;
        default:
            break;
    }
    PickViewVC * pickView=[PickViewVC getInstance];
    MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:index1];
    if ([filter.title isEqualToString:@"价格"]) {
        pickView.selectStr = @"不限";
        start=0;
        end=0;
    }else {
        pickView.selectStr = filter.title;
    }
    @WeakObj(self);

    [pickView showPickView:self pickData:array EventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if (index==ALERT_OK) {
            NSString * str=(NSString *)data;
            MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:index1];
            
            filter.title=str;
            [self.v_BtmFilters setItemChangeForIndex:index1 color:UIColorFromRGB(0xcf6262)];
            if(_jmpCode==0||_jmpCode==2)///元/月
            {
                if([str isEqualToString:@"不限"])
                {
                    filter.title=@"价格";
                    [self.v_BtmFilters setItemChangeForIndex:index1 color:UIColorFromRGB(0xffffff)];
                    moneybegin=@"0";
                    moneyend=@"0";
                }
                else if([str hasSuffix:@"元以上/月"])
                {
                    str=[str stringByReplacingOccurrencesOfString:@"元以上/月" withString:@""];
                    moneybegin=str;
                    moneyend=@"0";
                }
                else if ([str hasSuffix:@"元以下/月"])
                {
                    str=[str stringByReplacingOccurrencesOfString:@"元以下/月" withString:@""];
                    moneyend=str;
                    moneybegin=@"0";
                }
                else
                {
                    str=[str stringByReplacingOccurrencesOfString:@"元/月" withString:@""];
                    NSArray * tmp=[str componentsSeparatedByString:@"-"];
                    moneybegin=[tmp objectAtIndex:0];
                    moneyend=[tmp objectAtIndex:1];
                }
                
            }
            else if(_jmpCode==1||_jmpCode==3)///万元
            {
                if([str isEqualToString:@"不限"])
                {
                    moneybegin=@"0";
                    moneyend=@"0";
                    filter.title=@"价格";
                    [self.v_BtmFilters setItemChangeForIndex:index1 color:UIColorFromRGB(0xffffff)];
                }
                else if([str hasSuffix:@"万元以上"])
                {
                    str=[str stringByReplacingOccurrencesOfString:@"万元以上" withString:@""];
                    moneybegin=str;
                    moneyend=@"0";
                }
                else if ([str hasSuffix:@"万元以下"])
                {
                    str=[str stringByReplacingOccurrencesOfString:@"万元以下" withString:@""];
                    moneyend=str;
                    moneybegin=@"0";
                }
                else
                {
                    str=[str stringByReplacingOccurrencesOfString:@"万元" withString:@""];
                    NSArray * tmp=[str componentsSeparatedByString:@"-"];
                    moneybegin=[tmp objectAtIndex:0];
                    moneyend=[tmp objectAtIndex:1];
                }
            }
            [selfWeak.tableView.mj_header beginRefreshing];
        }
    }];
    pickView.lab_Title.text=@"价格";
    
}

/**
 *  显示价格
 */
-(void)selectPrice
{
    @WeakObj(self);
    PricePopVC * price=[PricePopVC getInstance];
    NSArray * array;
    switch (_jmpCode) {
        case 4:
        {
            //车位出租
            array=@[@"0",@"100",@"300",@"500",@"不限"];
        }
            break;
        case 5:
        {
            //车位出售
            array=@[@"0",@"5",@"10",@"20",@"不限"];
        }
            break;
        default:
            break;
    }
    
    price.start = start;
    price.end   = end;
    
    [price showPickPopView:self data:array eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        NSArray * arr=(NSArray *)data;
        NSLog(@"start=%@  end=%@",arr[0],arr[1]);
        moneybegin=arr[0];
        moneyend=arr[1];
        
        NSInteger index1 = 1;
        if (_jmpCode == 0 || _jmpCode == 1) {
            index1 = 2;
        }
        
        MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:index1];
        
        NSString * rep=@"元";
        if(_jmpCode==1)
        {
            rep=@"万";
        }
        moneybegin=[moneybegin stringByReplacingOccurrencesOfString:rep withString:@""];
        moneyend=[moneyend stringByReplacingOccurrencesOfString:rep withString:@""];
        filter.title=[NSString stringWithFormat:@"%@-%@",moneybegin,moneyend];
        [self.v_BtmFilters setItemChangeForIndex:index1 color:UIColorFromRGB(0xffffff)];
        for(int i=0;i<array.count;i++)
        {
            if([arr[0] isEqualToString:[array objectAtIndex:i]])
            {
                start=i;
            }
            if([arr[1] isEqualToString:[array objectAtIndex:i]])
            {
                end=i;
            }
        }
        if(start==end)
        {
            if(end==(array.count-1))
            {
                moneybegin=@"";
                moneyend=@"";
                filter.title=@"价格";
            }
            else
            {
                [selfWeak showToastMsg:@"开始结束不能相同" Duration:5];
                return ;
            }
            
        }
        if(start==0&&end==(array.count-1))
        {
            filter.title=@"价格";
        }
        
        [selfWeak.v_BtmFilters setTitleTextChangeForIndex:index1];
        if(end==(array.count-1))
        {
            moneyend=@"";
        }
        if(![filter.title isEqualToString:@"价格"])
        {
             [self.v_BtmFilters setItemChangeForIndex:index1 color:UIColorFromRGB(0xcf6262)];
        }
        [selfWeak.tableView.mj_header beginRefreshing];
    }];

}
/**
 *  是否显示地下
 */
- (void)selectGround {
    PickViewVC * pickView=[PickViewVC getInstance];
    
    MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:2];
    if ([filter.title isEqualToString:@"地下"]) {
        pickView.selectStr = @"不限";
    }else {
        pickView.selectStr = filter.title;
    }
    
    @WeakObj(self);

    [pickView showPickView:self pickData:@[@"不限",@"是",@"否"] EventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if (index==ALERT_OK) {

            MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:2];
             [self.v_BtmFilters setItemChangeForIndex:2 color:UIColorFromRGB(0xffffff)];
            if ([data isEqualToString:@"不限"]) {
                filter.title = @"地下";
            }else {
                filter.title = data;
                 [self.v_BtmFilters setItemChangeForIndex:2 color:UIColorFromRGB(0xcf6262)];
            }
            [self.v_BtmFilters setTitleTextChangeForIndex:2];
            if ([data isEqualToString:@"不限"]) {
                underground = @"-1";
            }
            if ([data isEqualToString:@"是"]) {
                underground = @"1";
            }
            if ([data isEqualToString:@"否"]) {
                underground = @"0";
            }
            [selfWeak.tableView.mj_header beginRefreshing];

        }
        
    }];
    pickView.lab_Title.text=@"地下";
}
/**
 *  选择是否固定
 */
- (void)selectFix {
    PickViewVC * pickView=[PickViewVC getInstance];
    
    MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:3];
    if ([filter.title isEqualToString:@"固定"]) {
        pickView.selectStr = @"不限";
    }else {
        pickView.selectStr = filter.title;
    }
    @WeakObj(self);
    [pickView showPickView:self pickData:@[@"不限",@"是",@"否"] EventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if (index==ALERT_OK) {

            MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:3];
            [self.v_BtmFilters setItemChangeForIndex:3 color:UIColorFromRGB(0xffffff)];
            if ([data isEqualToString:@"不限"]) {
                filter.title = @"固定";
            }else {
                filter.title = data;
                [self.v_BtmFilters setItemChangeForIndex:3 color:UIColorFromRGB(0xcf6262)];
            }
            [self.v_BtmFilters setTitleTextChangeForIndex:3];
            if ([data isEqualToString:@"不限"]) {
                fixed = @"-1";
            }
            if ([data isEqualToString:@"是"]) {
                fixed = @"1";
            }
            if ([data isEqualToString:@"否"]) {
                fixed = @"0";
            }
            [selfWeak.tableView.mj_header beginRefreshing];
        }
        
    }];
    pickView.lab_Title.text=@"固定";
}
/**
 *  选择排序
 */
- (void)selectAscOrDesc {
    @WeakObj(self);

    PickViewVC * pickView=[PickViewVC getInstance];
    pickView.lab_Title.text = @"排序";
    MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:4];
    if ([filter.title isEqualToString:@"排序"]) {
        pickView.selectStr = @"默认";
    }else {
        pickView.selectStr = filter.title;
    }
    [pickView showPickView:self pickData:@[@"默认",@"价格从低到高",@"价格从高到低"] EventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        if (index==ALERT_OK) {

            MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:4];
            [self.v_BtmFilters setItemChangeForIndex:4 color:UIColorFromRGB(0xffffff)];
            if ([data isEqualToString:@"默认"]) {
                filter.title = @"排序";
            }else {
                filter.title = data;
                [self.v_BtmFilters setItemChangeForIndex:4 color:UIColorFromRGB(0xcf6262)];
            }
            [self.v_BtmFilters setTitleTextChangeForIndex:4];
            if ([data isEqualToString:@"默认"]) {
                orderby =@"";
                return ;
            }
            if ([data isEqualToString:@"价格从低到高"]) {
                orderby = @"money asc";
            }
            if ([data isEqualToString:@"价格从高到低"]) {
                orderby = @"money desc";
            }
            [selfWeak.tableView.mj_header beginRefreshing];

        }
        
    }];
    pickView.lab_Title.text=@"排序";
}

#pragma mark ----------关于列表数据及协议处理--------------
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
 *  @param data
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
-(void)setData:(id) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  赋值给cell控件
     */
    RentalAndSalesCell * rcell=(RentalAndSalesCell *)cell;
    ///0.房屋求租 1.房屋求售 2.车位求租 3.车位求售  4.车位出租 5.车位出售
    if(_jmpCode==0||_jmpCode==1)
    {
        UserPublishRoom *publishRoom = (UserPublishRoom *)data;
        rcell.lab_Title.text=publishRoom.title;

        
        if (_jmpCode == 0) {
            
            NSArray * tmp=@[@"整租一室",@"整租两室",@"整租三室",@"整租四室及以上",@"单间合租"];
            NSString * quyu=@"";
            if([publishRoom.bedroom integerValue]==99)
            {
                quyu=[NSString stringWithFormat:@"%@ - %@",@"单间合租",publishRoom.countyname];
            }
            else{
                if([publishRoom.bedroom integerValue]-1>=0&&[publishRoom.bedroom integerValue]-1<tmp.count)
                {
                    quyu=[NSString stringWithFormat:@"%@ - %@",[tmp objectAtIndex:[publishRoom.bedroom integerValue]-1],publishRoom.countyname];
                }
                
            }
            if([publishRoom.bedroom integerValue]==0)
            {
                quyu=publishRoom.countyname;
            }
            rcell.lab_RoomCommunity.text=quyu;
            
            
            if (publishRoom.moneyend.intValue == 0) {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d元以上/月",publishRoom.moneybegin.intValue];
            }else if (publishRoom.moneybegin.intValue == 0) {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d元以下/月",publishRoom.moneyend.intValue];
            }else {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d-%d元/月",publishRoom.moneybegin.intValue,publishRoom.moneyend.intValue];
            }
        }else {
            
        
            NSMutableString * room=[NSMutableString new];
            if([publishRoom.bedroom integerValue]>0)
            {
                [room appendString:publishRoom.bedroom];
                [room appendString:@"室"];
            }
            if([publishRoom.livingroom integerValue]>0)
            {
                [room appendString:publishRoom.livingroom];
                [room appendString:@"厅"];
            }
            [room appendFormat:@" - %@",publishRoom.countyname];
            rcell.lab_RoomCommunity.text=room;
            if (publishRoom.moneyend.intValue == 0) {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%@万以上",[publishRoom.moneybegin stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            }else if (publishRoom.moneybegin.intValue == 0) {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%@万以下",[publishRoom.moneyend stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            }else {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%@-%@万",[publishRoom.moneybegin stringByReplacingOccurrencesOfString:@".0" withString:@""],[publishRoom.moneyend stringByReplacingOccurrencesOfString:@".0" withString:@""]];
            }
        }

        rcell.lab_Date.text=[DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:publishRoom.releasedate]];
    }
    else if(_jmpCode==4||_jmpCode==5)
    {
        UserPublishCar *publishCar = (UserPublishCar *)data;

        rcell.lab_Title.text=publishCar.title;
        
        rcell.lab_RoomCommunity.text=[NSString stringWithFormat:@"%@-%@",publishCar.countyname,publishCar.communityname];
        if (_jmpCode==4) {
            rcell.lab_Price.text=[NSString stringWithFormat:@"%@元/月",[publishCar.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
        }else {
            rcell.lab_Price.text=[NSString stringWithFormat:@"%@万",[publishCar.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
        }
        rcell.lab_Date.text=[DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:publishCar.releasedate]];
        
    }
    else if(_jmpCode==2||_jmpCode==3)
    {
        UserPublishCar *publishCar = (UserPublishCar *)data;

        rcell.lab_Title.text=publishCar.title;
        
        rcell.lab_RoomCommunity.text=[NSString stringWithFormat:@"%@",publishCar.countyname];
        if (_jmpCode == 2) {
            
            if (publishCar.moneybegin.intValue == 0) {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d 元以下/月",publishCar.moneyend.intValue];
            }else if (publishCar.moneyend.intValue == 0) {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d 元以上/月",publishCar.moneybegin.intValue];
            }else {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d - %d元/月",publishCar.moneybegin.intValue,publishCar.moneyend.intValue];
            }
        }else {
            if (publishCar.moneybegin.intValue == 0) {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d 万以下",publishCar.moneyend.intValue];
            }else if (publishCar.moneyend.intValue == 0) {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d 万以上",publishCar.moneybegin.intValue];
            }else {
                rcell.lab_Price.text = [NSString stringWithFormat:@"%d - %d 万",publishCar.moneybegin.intValue,publishCar.moneyend.intValue];
            }

        }
        rcell.lab_Date.text=[DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:publishCar.releasedate]];
    }
    
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
    return 112;
}
//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(_jmpCode==0||_jmpCode==1)//房屋求租购
    {
        UserPublishRoom *publishRoom =[dataArray objectAtIndex:indexPath.row];
        RentalAndSalesDetailVC * DetailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RentalAndSalesDetailVC"];
        DetailVC.jmpCode=_jmpCode;
        DetailVC.publishRoom=publishRoom;
        DetailVC.title=(_jmpCode==1?@"求购详情":@"求租详情");
        [self.navigationController pushViewController:DetailVC animated:YES];
    }
    else//车位求租购
    {
        ParkingDetailVC * DetailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ParkingDetailVC"];
        UserPublishCar *userPublishCar =[dataArray objectAtIndex:indexPath.row];
        DetailVC.userPublishCar=userPublishCar;
        //2.车位求租 3.车位求售  4.车位出租 5.车位出售
        if (_jmpCode==2||_jmpCode==3) {
            DetailVC.jmpCode=1;
            DetailVC.title=(_jmpCode==3?@"求购详情":@"求租详情");
        }
        else if (_jmpCode==4||_jmpCode==5)
        {
            DetailVC.jmpCode=0;
             DetailVC.title=(_jmpCode==5?@"出售详情":@"出租详情");
        }
        [self.navigationController pushViewController:DetailVC animated:YES];

    }
}
/**
 *  获取城市区域
 */
-(void)getDistrictData
{
//    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [BMCityPresenter getCityCounty:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

            if(resultCode==SucceedCode)
            {
                arrayDistrict=(NSArray *)data;
            }
            else
            {
//                [self showToastMsg:data Duration:5.0];
            }
        });
        
    } withCityID:userData.cityid];
}
/**
 *  定位
 */
- (void)getLocation {
    @WeakObj(self);
    
    bdmap=[BDMapFWPresenter new];
//    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
//    [indicator startAnimating:self.tabBarController];
    [bdmap getLocationInfoForupDateViewsBlock:^(id  _Nullable data, ResultCode resultCode) {
        [bdmap stopLocation];
        
        if (resultCode==SucceedCode) {
            location=(LocationInfo *)data;
            
            if(appDelegate.userData.cityid.intValue == 0)
            {
                [AppSystemSetPresenters getCityIDName:location.cityName UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [indicator stopAnimating];
                        
                        if(resultCode==SucceedCode)
                        {
                            appDelegate.userData.cityid = data;
                            [appDelegate saveContext];
                            [selfWeak getDistrictData];
                        }
                        else
                        {
//                            [selfWeak showToastMsg:data Duration:5.0];
                        }
                        
                    });
                    
                }];
            }
            
        }else{
            [selfWeak showToastMsg:@"定位失败,请在设置中开启定位!" Duration:5.0];
        }
    }];
        
    
}


///滑运隐藏底部

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y>scrollView.contentSize.height) {
        return;
    }
    
    if (scrollView.contentOffset.y > _oldOffset&&scrollView.contentOffset.y>0) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        //        NSLog(@"向上滑动");
        if(self.v_BtmFilters.alpha==1)
        {
            isShowBottom=NO;
        }
        
    }else
    {
        if(self.v_BtmFilters.alpha<1)
        {
            isShowBottom=YES;
        }
        
    }
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging============");
    if(isShowBottom)
    {
        if(self.v_BtmFilters.alpha<1)
        {
            //        NSLog(@"向下滑动");
            [UIView animateWithDuration:1 animations:^{
                self.v_BtmFilters.alpha = 1;
            } completion:^(BOOL finished) {
                self.nsLay_bottomHeight.constant=55;
            }];
        }
    }
    else
    {
        if(self.v_BtmFilters.alpha>0)
        {
            [UIView animateWithDuration:1 animations:^{
                self.v_BtmFilters.alpha = 0;
            } completion:^(BOOL finished) {
                self.nsLay_bottomHeight.constant=0;
            }];
        }
    }
}


@end
