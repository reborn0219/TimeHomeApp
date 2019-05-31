//
//  HouseTableVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "HouseTableVC.h"
#import "TableViewDataSource.h"
#import "UIButtonImageWithLable.h"
#import "HouseTableCell.h"
#import "BtmFilterTools.h"
#import "HouseFunctionVC.h"
#import "ReleaseUsedMarketVC.h"
#import "PickViewVC.h"
#import "PricePopVC.h"
#import "MultipleChoicesPopVC.h"
#import "HouseDetailVC.h"
#import "BMRoomPresenter.h"
#import "BMReplacePresenter.h"
#import "BMCityPresenter.h"
#import "UserPublishRoom.h"
#import "UserReservePic.h"
#import "DateUitls.h"
/**
 *  城市区域请求
 */
#import "AppSystemSetPresenters.h"
/**
 *  地图
 */
#import "GetAddressMapVC.h"
/**
 *  定位
 */
#import "BDMapFWPresenter.h"

@interface HouseTableVC ()<UITableViewDelegate,UITextFieldDelegate>
{
    /**
     *  列表显示数据源
     */
    TableViewDataSource * dataSource;
    /**
     *  列表数据
     */
    NSMutableArray * listData;
    /**
     *  页数
     */
    NSInteger page;
    
    AppDelegate * appDlt;
    
    /**
     *  选中区ID
     */
    NSString * countyid;
    /**
     *  选择厅室 1234 99以上
     */
    NSString * bedroom;
    /**
     *  选价格 起始
     */
    NSString * moneybegin;
    /**
     *  选价格 结束
     */
    NSString * moneyend;
    /**
     *  价格
     */
    NSInteger start;
    NSInteger end;
    
    /**
     *  选择排序  money asc顺序 money desc倒序
     */
    NSString * orderby;
    
    /**
     *  选择新旧
     */
    NSString * newness;
    /**
     *  分类id
     */
    NSString * typeid;

    /**
     *  二手物品分类数据
     */
    NSMutableArray * useMarketTypeArray;
    /**
     *  新旧选择数据
     */
    NSMutableArray * newsOldArray;
    
    
    /**
     *  城市区
     */
    NSArray * arrayDistrict;
    
    /**
     *  厅室选择数据
     */
    NSMutableArray * bedRoom;
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
///底部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsLay_btmFilterHeight;

@end

@implementation HouseTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    if (appDlt.userData.cityid.intValue != 0) {
        [self getDistrictData];
    }else {
        [self getLocation];
    }
    [self.tableView.mj_header beginRefreshing];
    //    [self getDistrictData];
    if(_jmpCode==2)//二手获取分类
    {
        [self getUserMarketType];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)backButtonClick
{
    if(self.isFromeRelease)
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HouseFunctionVC class]]) {
                HouseFunctionVC * vc=(HouseFunctionVC *)controller;
                if(_jmpCode==0||_jmpCode==1)
                {
                    vc.jumpCode = _jmpCode;
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
                
            }
//            if ([controller isKindOfClass:[THMyPublishHouseListViewController class]]) {
//                THMyPublishHouseListViewController * vc=(THMyPublishHouseListViewController *)controller;
//                if (_jmpCode == 2) {
//                    vc.publishType = 1;
//                    [self.navigationController popToViewController:controller animated:YES];
//                    break;
//                }
//                
//            }
        }
        [super backButtonClick];
    }
    else
    {
        [super backButtonClick];
    }
    
}
#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    appDlt=GetAppDelegates;
    
    countyid=@"0";
    bedroom=@"";
    moneybegin=@"";
    moneyend=@"";
    orderby=@"";
    newness=@"0";
    typeid=@"";
    start=0;
    end=7;
    
    
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.TF_SearchText.delegate=self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HouseTableCell" bundle:nil] forCellReuseIdentifier:@"HouseTableCell"];
    //    self.tableView.allowsSelection = NO;//列表不可选择
    
    listData=[NSMutableArray new];

    
    @WeakObj(self);
    dataSource=[[TableViewDataSource alloc]initWithItems:listData cellIdentifier:@"HouseTableCell" configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
        
        [selfWeak setData:item withCell:cell withIndexPath:indexPath];
        
    }];
    dataSource.isSection=NO;
    self.tableView.dataSource=dataSource;
    [self setExtraCellLineHidden:self.tableView];
    
    if (_jmpCode==0||_jmpCode==1) {//出租，出售
        bedRoom=[NSMutableArray new];
        NSArray * tmp=@[@"一室",@"两室",@"三室",@"四室及以上"];
        if(_jmpCode==1)
        {
            tmp=@[@"一室",@"两室",@"三室",@"四室及以上"];
        }
        MultipleChoicesModel * mcm;
        for(int i=0;i<tmp.count;i++)
        {
            mcm=[MultipleChoicesModel new];
            mcm.title=[tmp objectAtIndex:i];
            [bedRoom addObject:mcm];
        }
        
        [self setBottomFilters ];
    }
    else if (_jmpCode==2)//二手
    {
        useMarketTypeArray=[NSMutableArray new];
        NSArray * ar= @[@"全新",@"九成新",@"八成新",@"七成新",@"六成新",@"五成新",@"五成新以下"];
        newsOldArray=[NSMutableArray new];
        MultipleChoicesModel * mcm;
        for(int i=0;i<ar.count;i++)
        {
            mcm=[MultipleChoicesModel new];
            mcm.title=[ar objectAtIndex:i];
            [newsOldArray addObject:mcm];
        }

        [self setUsedBottomFilters];
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak topRefresh];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadmore];
    }];
    
}
/**
 *  搜索
 */
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    [_TF_SearchText resignFirstResponder];
    [self.tableView.mj_header beginRefreshing];
    
    return YES;
}
///下拉刷新数据
-(void)topRefresh
{
    page=1;
    if(_jmpCode==0||_jmpCode==1)
    {
        [self getRentHouseData:[NSString stringWithFormat:@"%ld",(long)page]];
    }
    else if(_jmpCode==2)
    {
        [self getUsedMarketData:[NSString stringWithFormat:@"%ld",(long)page]];
    }
}
///上拉加载更多
-(void)loadmore
{
    page++;
    if(_jmpCode==0||_jmpCode==1)
    {
        [self getRentHouseData:[NSString stringWithFormat:@"%ld",(long)page]];
    }
    else if(_jmpCode==2)
    {
         [self getUsedMarketData:[NSString stringWithFormat:@"%ld",(long)page]];
    }
}

/**
 *  出租，出售底部条件选择
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
    
    filter=[[MenuModel alloc]init];
    filter.title=@"排序";
    filter.imgName=@"车位租售_排序";
    [arr addObject:filter];
    self.v_BtmFilters.FilterArray=arr;
    self.v_BtmFilters.eventCallBack=^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if (index==0) {//区域
            [self selectQuYu];
        }
        else if (index==1)//厅室
        {
            [self selectBedRomm];
        }
        else if (index==2)//价格 0 500 1000 1500 2000 3000 5000 不限
        {
            [self selectPrice];
        }
        else if (index==3)//排序
        {
            [self selectOrbye];
        }
    };
}
/**
 *  二手底部条件选择
 */
-(void)setUsedBottomFilters
{
    NSMutableArray * arr=[NSMutableArray new];
    MenuModel * filter=[[MenuModel alloc]init];
    filter.title=@"区域";
    filter.imgName=@"车位租售_区域";
    [arr addObject:filter];
    
    filter=[[MenuModel alloc]init];
    filter.title=@"分类";
    filter.imgName=@"跳蚤市场_分类";
    [arr addObject:filter];
    
    filter=[[MenuModel alloc]init];
    filter.title=@"新旧";
    filter.imgName=@"跳蚤市场_新旧";
    [arr addObject:filter];
    
    filter=[[MenuModel alloc]init];
    filter.title=@"排序";
    filter.imgName=@"车位租售_排序";
    [arr addObject:filter];
    
    self.v_BtmFilters.FilterArray=arr;
    @WeakObj(self);
    self.v_BtmFilters.eventCallBack=^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        NSLog(@"index==%ld",(long)index);
        
        
        if (index==0) {//区域
            [self selectQuYu];
        }
        else if (index==1)//分类
        {
            MultipleChoicesPopVC *mcpVC=[MultipleChoicesPopVC getInstance];
            
            
            [mcpVC showPopView:self data:useMarketTypeArray eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                
                if (index==ALERT_OK) {
                    
                    NSLog(@"\n\n\n\n\n\n*****data==%@*****",data);
                    
                    MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:1];
                    filter.title=@"分类";
                    MultipleChoicesModel * mcm;
                    int count=0;
                    NSMutableString * str=[NSMutableString new];
                    [str appendString:@""];
                    [self.v_BtmFilters setItemChangeForIndex:1 color:UIColorFromRGB(0xffffff)];
                    for(int i=0;i<useMarketTypeArray.count;i++)
                    {
                        mcm=[useMarketTypeArray objectAtIndex:i];
                        
                        NSLog(@"\n\n\n\n\n\n*******select==%@*******",mcm.isSelect?@"YES":@"NO");
                        
                        if(mcm.isSelect)
                        {
                            count++;
                            filter.title=mcm.title;
                            [str appendString:[NSString stringWithFormat:@"%@",mcm.ID]];
                            [str appendString:@","];
                        }
                        
                    }
                    
                    if(str.length>1)
                    {
                        [str deleteCharactersInRange:NSMakeRange([str length]-1, 1)];
                        typeid=str;
                        [self.v_BtmFilters setItemChangeForIndex:1 color:UIColorFromRGB(0xcf6262)];
                    }
                    else
                    {
                        typeid=@"";
                    }
                    
                    if(count>1)
                    {
                        filter.title=@"多选";
                    }
                    [self.v_BtmFilters setTitleTextChangeForIndex:1];
                    [self.tableView.mj_header beginRefreshing];
                    
                }
            }];
            mcpVC.lab_Title.text=@"分类";

        }
        else if (index==2)//新旧
        {
            MultipleChoicesPopVC * pickView=[MultipleChoicesPopVC getInstance];
            
            
            
            //全新 九成新 八成新 七成新 六成新 五成及以下
            [pickView showPopView:selfWeak data:newsOldArray eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                if (index==ALERT_OK) {
                    NSLog(@"data==%@",data);
                    MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:2];
                    filter.title=@"新旧";
                    MultipleChoicesModel * mcm;
                    int count=0;
                    NSMutableString * str=[NSMutableString new];
                    [str appendString:@""];
                    [self.v_BtmFilters setItemChangeForIndex:2 color:UIColorFromRGB(0xffffff)];
                    for(int i=0;i<newsOldArray.count;i++)
                    {
                        mcm=[newsOldArray objectAtIndex:i];
                        NSLog(@"select==%@",mcm.isSelect?@"YES":@"NO");
                        if(mcm.isSelect)
                        {
                            count++;
                            filter.title=mcm.title;
                            [str appendString:[NSString stringWithFormat:@"%d",(10-i)]];
                            [str appendString:@","];
                        }
                        
                    }
                    if(str.length>1)
                    {
                        [str deleteCharactersInRange:NSMakeRange([str length]-1, 1)];
                        newness=str;
                        [self.v_BtmFilters setItemChangeForIndex:2 color:UIColorFromRGB(0xcf6262)];
                    }
                    else
                    {
                        newness=@"0";
                    }
                    
                    if(count>1)
                    {
                        filter.title=@"多选";
                    }
                    [self.v_BtmFilters setTitleTextChangeForIndex:2];
                    [self.tableView.mj_header beginRefreshing];
                }
                
            }];
            pickView.lab_Title.text=@"新旧";

        }
        else if (index==3)//排序
        {
            [self selectOrbye];
        }

    };
    
    
}

///显示选择区域
-(void)selectQuYu
{
    if(arrayDistrict==nil||arrayDistrict.count==0)
    {
        [self showToastMsg:@"没有获取市区数据" Duration:5];
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
            MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:0];
            filter.title=name;
            [self.v_BtmFilters setTitleTextChangeForIndex:0];
            [self.v_BtmFilters setItemChangeForIndex:0 color:UIColorFromRGB(0xffffff)];
            
            if([name isEqualToString:@"不限"])
                
            {
                filter.title=@"区域";
                [self.v_BtmFilters setTitleTextChangeForIndex:0];
                countyid=@"0";
                
                
            }
            else
            {
                NSDictionary *dics;
                for(int i=0;i<arrayDistrict.count;i++)
                {
                    dics=[arrayDistrict objectAtIndex:i];
                    NSString * tmp=[dics objectForKey:@"name"];
                    if([name isEqualToString:tmp])
                    {
                        countyid=[[dics objectForKey:@"id"] stringValue];
                        break;
                    }
                }
                [self.v_BtmFilters setItemChangeForIndex:0 color:UIColorFromRGB(0xcf6262)];
                
            }
            [self.tableView.mj_header beginRefreshing];
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
//                    if(i==(bedRoom.count-1))
//                    {
//                        [str appendString:@"99,"];
//                    }
//                    else
//                    {
                        [str appendString:[NSString stringWithFormat:@"%d",i+1]];
                        [str appendString:@","];
//                    }
                    
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
///显不价格
-(void)selectPrice
{
    PricePopVC * price=[PricePopVC getInstance];
    NSArray * array;
    if(_jmpCode==0)
    {
        array=@[@"0",@"500",@"1000",@"1500",@"2000",@"3000",@"5000",@"不限"];
    }
    else
    {
        ///50万元以下，50-100万元，100-150万元，150-200万元，200-300万元，300-500万元，500万元以上

        array=@[@"0",@"50",@"100",@"150",@"200",@"300",@"500",@"不限"];
    }
    
    price.start=start;
    price.end=end;
    
    [price showPickPopView:self data:array eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        NSArray * arr=(NSArray *)data;
        NSLog(@"start=%@  end=%@",arr[0],arr[1]);
        moneybegin=arr[0];
        moneyend=arr[1];
        MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:2];
        
        NSString * rep=@"元";
        if(_jmpCode==1)
        {
            rep=@"万";
        }
        moneybegin=[moneybegin stringByReplacingOccurrencesOfString:rep withString:@""];
        moneyend=[moneyend stringByReplacingOccurrencesOfString:rep withString:@""];
        filter.title=[NSString stringWithFormat:@"%@-%@",moneybegin,moneyend];
         [self.v_BtmFilters setItemChangeForIndex:2 color:UIColorFromRGB(0xffffff)];
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
                [self showToastMsg:@"开始结束不能相同" Duration:5];
                return ;
            }
            
        }
        if(start==0&&end==(array.count-1))
        {
            filter.title=@"价格";
        }
        if(![filter.title isEqualToString:@"价格"])
        {
             [self.v_BtmFilters setItemChangeForIndex:2 color:UIColorFromRGB(0xcf6262)];
        }
        
        [self.v_BtmFilters setTitleTextChangeForIndex:2];
        if(end==(array.count-1))
        {
            moneyend=@"";
        }
        [self.tableView.mj_header beginRefreshing];
    }];

}

-(void)selectOrbye
{
    PickViewVC * pickView=[PickViewVC getInstance];
    NSArray * array=@[@"默认",@"价格从低到高",@"价格从高到低"];
    
    if([orderby isEqualToString:@""])
    {
        pickView.selectStr=@"默认";
    }
    else if([orderby isEqualToString:@"money asc"])
    {
        pickView.selectStr=@"价格从低到高";
    }
    else if([orderby isEqualToString:@"money desc"])
    {
        pickView.selectStr=@"价格从高到低";
    }
    else
    {
        pickView.selectStr=@"默认";
    }
    
    @WeakObj(self);
    
    [pickView showPickView:selfWeak pickData:array EventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        
        if (index==ALERT_OK) {
            
            NSLog(@"Str===%@",(NSString *)data);
            
            NSString * tmp=(NSString *)data;
            MenuModel * filter=[self.v_BtmFilters.FilterArray objectAtIndex:3];
            filter.title=tmp;
            [self.v_BtmFilters setItemChangeForIndex:3 color:UIColorFromRGB(0xffffff)];
            
            if([tmp isEqualToString:@"默认"])
            {
                filter.title=@"排序";
                orderby=@"";
            }
            else if([tmp isEqualToString:@"价格从低到高"])
            {
                orderby=@"money asc";
            }
            else if([tmp isEqualToString:@"价格从高到低"])
            {
                orderby=@"money desc";
            }
            if(![orderby isEqualToString:@""])
            {
                [self.v_BtmFilters setItemChangeForIndex:3 color:UIColorFromRGB(0xcf6262)];
            }
            
            [self.v_BtmFilters setTitleTextChangeForIndex:3];
            [self.tableView.mj_header beginRefreshing];
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
 *  @param data      <#data description#>
 *  @param cell      cell description
 *  @param indexPath indexPath description
 */
-(void)setData:(id) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    HouseTableCell * hCell=(HouseTableCell * )cell;
    UserPublishRoom * upr=(UserPublishRoom *)data;
    ///
    if(upr.piclist!=nil&&upr.piclist.count>0)
    {
        UserReservePic * urPic= [upr.piclist objectAtIndex:0];
        [hCell.img_Pic sd_setImageWithURL:[NSURL URLWithString:urPic.fileurl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
    }
    else
    {
        [hCell.img_Pic setImage:[UIImage imageNamed:@"未上传照片"]];
    }
    if(_jmpCode==0)//出租
    {
        hCell.lab_Title.text=upr.title;
        NSString * quyu=[NSString stringWithFormat:@"%@室 - %@ - %@",upr.bedroom,upr.countyname,upr.communityname];
        hCell.lab_QuYu.text=quyu;
        hCell.lab_Price.text=[NSString stringWithFormat:@"%@元/月",[upr.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
        
        hCell.lab_Date.text=[DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:upr.releasedate]];
    }
    else if(_jmpCode==1)//出售
    {
        hCell.lab_Title.text=upr.title;
        NSString * quyu=[NSString stringWithFormat:@"%@室 - %@ - %@",upr.bedroom,upr.countyname,upr.communityname];
        hCell.lab_QuYu.text=quyu;
        hCell.lab_Price.text=[NSString stringWithFormat:@"%@万",[upr.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
        hCell.lab_Date.text=[DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:upr.releasedate]];
    }
    else if(_jmpCode==2)//二手
    {
        hCell.lab_Title.text=upr.name;
        NSString * quyu=[NSString stringWithFormat:@"%@成新 - %@ - %@",upr.newness,upr.countyname,upr.communityname];
        hCell.lab_QuYu.text=quyu;
        hCell.lab_Price.text=[NSString stringWithFormat:@"%@元",[upr.money stringByReplacingOccurrencesOfString:@".0" withString:@""]];
        hCell.lab_Date.text=[DateUitls  prettyDateWithReference:[DateUitls tranfromStingToData:upr.releasedate]];
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
    HouseDetailVC * detailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"HouseDetailVC"];
    detailVC.room = [listData objectAtIndex:indexPath.row];
    detailVC.jumCode=_jmpCode;
    if (_jmpCode==0||_jmpCode==1) {
        detailVC.title=@"房源详情";
    }
    else if(_jmpCode==2)
    {
        detailVC.title=@"物品详情";
    }
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

#pragma mark ----------事件处理--------------
/**
 *  发布信息事件
 *
 *  @param sender sender description
 */
- (IBAction)Nav_LeftEvent:(UIBarButtonItem *)sender {
    if (_jmpCode==0||_jmpCode==1) {//出租
        
        HouseFunctionVC *hfVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HouseFunctionVC"];
        
        hfVC.jumpCode=2;
        hfVC.title=@"选择发布类别";
        [self.navigationController pushViewController:hfVC animated:YES];
    }
    else if (_jmpCode==2)//二手物品
    {
        ReleaseUsedMarketVC *rVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReleaseUsedMarketVC"];
        rVC.title=@"发布物品信息";
        [self.navigationController pushViewController:rVC animated:YES];
    }
    
}

#pragma  mark --------------网络----------------
///获取出租房屋数据
-(void)getRentHouseData:(NSString *)pages
{
    /**
     sertype	0 出租 1 买卖
     cityid	传递0则为社区属于的城市id；
     countyid	区域id
     moneybegin	价格区间开始 如果传递 – 负数则不查询
     moneyend	价格区间结束 如果传递 – 负数则不查询
     bedroom	卧室数量 – 负数不查询
     title	标题模糊搜索
     orderby	返回的列表字段 + 排序 asc顺序 desc倒序
     page	分页页码
     */
    
    NSDictionary *dic=@{@"sertype":[NSString stringWithFormat:@"%d",self.jmpCode],
                        @"cityid":@"0",
                        @"countyid":countyid,
                        @"moneybegin":moneybegin,
                        @"moneyend":moneyend,
                        @"bedroom":bedroom,
                        @"title":self.TF_SearchText.text,
                        @"orderby":orderby,
                        @"page":pages,
                        };
    
    [BMRoomPresenter getAppSearchResidence:^(id  _Nullable data, ResultCode resultCode) {
        [self upDataTableView:data resultCode:resultCode];
    } withInfo:dic];
}

///获取二手物品数据
-(void)getUsedMarketData:(NSString *)pages
{
    /**
     cityid	传递0则为社区属于的城市id；
     countyid	区域id
     newness	新旧程度 0 全部 4 五成新一下 5 成新 6、8、9、10全新
     name	名称
     typeid	类型id
     orderby	返回的列表字段 + 排序 asc顺序 desc倒序
     page	分页页码
     */
    NSDictionary *dic=@{@"sertype":[NSString stringWithFormat:@"%d",self.jmpCode],
                        @"cityid":@"0",
                        @"countyid":countyid,
                        @"newness":newness,
                         @"name":self.TF_SearchText.text,
                        @"typeid":typeid,
                        @"orderby":orderby,
                        @"page":pages,
                        };
    [BMReplacePresenter getAppSearchusedInfo:^(id  _Nullable data, ResultCode resultCode) {
        [self upDataTableView:data resultCode:resultCode];
    } withInfo:dic];
}




///更新视图
-(void)upDataTableView:(id )data resultCode:(ResultCode)resultCode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(resultCode==SucceedCode)
        {
            if(page>1)
            {
                [self.tableView.mj_footer endRefreshing];
                NSArray * tmparr=(NSArray *)data;
                NSInteger count=listData.count;
                [listData addObjectsFromArray:tmparr];
                [self.tableView beginUpdates];
                NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                for (int i=0; i<[tmparr count]; i++) {
                    NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                    [insertIndexPaths addObject:newPath];
                }
                [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
            }
            else
            {
                [self.tableView.mj_header endRefreshing];
                [listData removeAllObjects];
                [listData addObjectsFromArray:data];
                [self.tableView reloadData];
                
            }
        }
        else if(resultCode==FailureCode)
        {
            if(data==nil||![data isKindOfClass:[NSDictionary class]])
            {
                return ;
            }
            NSDictionary *dicJson=(NSDictionary *)data;
            NSInteger errcode=[[dicJson objectForKey:@"errcode"]intValue];
//            NSString * errmsg=[dicJson objectForKey:@"errmsg"];
            if(page>1)
            {
                page--;
                [self.tableView.mj_footer endRefreshing];

            }
            else{
                [self.tableView.mj_header endRefreshing];
                
                [listData removeAllObjects];
                [self.tableView reloadData];
                if(errcode==99999)
                {
                    if(_jmpCode==2)
                    {
                        if([countyid isEqualToString:@"0"]&&moneybegin.length==0&&moneyend.length==0&&orderby.length==0&&[newness isEqualToString:@"0"]&&typeid.length==0&&bedroom.length==0&&self.TF_SearchText.text.length==0)
                        {
                            [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无二手物品" eventCallBack:nil];

                            return ;
                        }

                    }
                    else
                    {
                        if([countyid isEqualToString:@"0"]&&moneybegin.length==0&&moneyend.length==0&&orderby.length==0&&[newness isEqualToString:@"0"]&&typeid.length==0&&bedroom.length==0&&self.TF_SearchText.text.length==0)
                        {
                            [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无房源信息" eventCallBack:nil];

                            return ;
                        }

                    }
                    
                    
                }
                
            }
            
            
            
        }
        else if(resultCode==NONetWorkCode)//无网络处理
        {
            if(page>1)
            {
                page--;
                [self.tableView.mj_footer endRefreshing];
            }
            else{
                [self.tableView.mj_header endRefreshing];
                if(_jmpCode==2)
                {
                    if([countyid isEqualToString:@"0"]&&moneybegin.length==0&&moneyend.length==0&&orderby.length==0&&[newness isEqualToString:@"0"]&&typeid.length==0&&bedroom.length==0&&self.TF_SearchText.text.length==0)
                    {

                        [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无二手物品" eventCallBack:nil];

                        return ;
                    }
                    
                }
                else
                {
                    if([countyid isEqualToString:@"0"]&&moneybegin.length==0&&moneyend.length==0&&orderby.length==0&&[newness isEqualToString:@"0"]&&typeid.length==0&&bedroom.length==0&&self.TF_SearchText.text.length==0)
                    {
                        [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无房源信息" eventCallBack:nil];

                        return ;
                    }
                    
                }

            }
           
            
        }
        
        
    });
}
///获取二手分类
-(void)getUserMarketType
{
    [BMReplacePresenter getUsedType:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultCode==SucceedCode)
            {
                NSArray * array=(NSArray *)data;
                
                MultipleChoicesModel * mcm;
                NSDictionary * dic;
                [useMarketTypeArray removeAllObjects];
                for(int i=0;i<array.count;i++)
                {
                    dic=[array objectAtIndex:i];
                    mcm=[MultipleChoicesModel new];
                    mcm.title=[dic objectForKey:@"typename"];
                    mcm.ID=[dic objectForKey:@"id"];
                    [useMarketTypeArray addObject:mcm];
                }
 
            }
            else if(resultCode==FailureCode)
            {
            
            }
            else if(resultCode==NONetWorkCode)//无网络处理
            {

            }
            
            
        });

    }];
}
///获取城市区域
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
    } withCityID:appDlt.userData.cityid];
}


/**
 *  定位
 */
- (void)getLocation {
    @WeakObj(self);
    
    bdmap=[BDMapFWPresenter new];

    [bdmap getLocationInfoForupDateViewsBlock:^(id  _Nullable data, ResultCode resultCode) {
        [bdmap stopLocation];
        
        if (resultCode==SucceedCode) {
            location=(LocationInfo *)data;
            
            if(appDlt.userData.cityid.intValue == 0)
            {
                [AppSystemSetPresenters getCityIDName:location.cityName UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(resultCode==SucceedCode)
                        {
                            appDlt.userData.cityid = data;
                            [appDlt saveContext];
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
        if(self.v_BtmFilters.alpha < 1)
        {
            //        NSLog(@"向下滑动");
            [UIView animateWithDuration:1 animations:^{
                self.v_BtmFilters.alpha = 1;
            } completion:^(BOOL finished) {
                self.nsLay_btmFilterHeight.constant=55;
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
                self.nsLay_btmFilterHeight.constant=0;
            }];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
