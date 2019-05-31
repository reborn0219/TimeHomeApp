//
//  ChangCityVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ChangCityVC.h"
#import "TableViewDataSource.h"
#import "ChangCityCell.h"
#import "ChangCityHreadCell.h"
#import "AppSystemSetPresenters.h"
#import "CityCommunityModel.h"
#import "SearchVC.h"
#import "PerfectInforVC.h"
#import "THMyInfoPresenter.h"
#import "MainTabBars.h"
#import "AppDelegate+JPush.h"
@interface ChangCityVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * arry_Index;
    NSMutableArray * array_city;
    AppDelegate * appdgt;
    
    ///选择的城市
    CityCommunityModel * cityModel;
    
    ///热门城市数据
    NSMutableArray * hotCity;
    
    ///原始数据
    NSArray * oldCityData;
}
/**
 *  搜索内容
 */
@property (weak, nonatomic) IBOutlet UITextField *TF_SeachText;
/**
 *  城市列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  城市列表数据
 */
@property(nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation ChangCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getCityListData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if(cityModel)
    {
        CityCommunityModel * ccm;
        BOOL isSame=NO;
        ///判断是否已存在
        for(int i=0;i<hotCity.count;i++)
        {
            ccm=[hotCity objectAtIndex:i];
            
            if([ccm.ID isEqualToString:cityModel.ID])
            {
                isSame=YES;
            }
        }
        if(!isSame)
        {

            [hotCity insertObject:cityModel atIndex:0];
            if(hotCity.count>4)
            {
                [hotCity removeLastObject];
            }
            [UserDefaultsStorage saveData:hotCity forKey:@"HotCitys"];
        }
    }

    
   
}

#pragma mark ----------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    appdgt=GetAppDelegates;
    if (cityModel==nil) {
        cityModel=[CityCommunityModel new];
    }
   
    cityModel.ID=appdgt.userData.cityid;
    cityModel.name=appdgt.userData.cityname;
    
    hotCity=[UserDefaultsStorage getDataforKey:@"HotCitys"];
    
    if (hotCity==nil) {
        hotCity=[NSMutableArray new];
        [hotCity addObject:cityModel];
        [UserDefaultsStorage saveData:hotCity forKey:@"HotCitys"];
    }
    
    
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangCityHreadCell" bundle:nil] forCellReuseIdentifier:@"ChangCityHreadCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangCityCell" bundle:nil] forCellReuseIdentifier:@"ChangCityCell"];
    
    //self.tableView.allowsSelection = NO;//列表不可选择
    arry_Index=[NSMutableArray new];
    
    for (int i = 0; i < 26; i++) {
        if (i == 8 || i == 14 || i == 20 || i== 21) {
            continue;
        }
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        [arry_Index addObject:cityKey];
    }

    
    /**
     *  测试数据
     */
    array_city=[NSMutableArray new];
    [array_city addObject:@[@""]];
    
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor grayColor];
   
    self.tableView.dataSource=self;
    [self setExtraCellLineHidden:self.tableView];
    
    _TF_SeachText.placeholder = @"输入城市名称";
    
    if ([_type isEqualToString: @"phone"]) {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick:)];
        rightBarItem.tintColor = UIColorFromRGB(0x999999);
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }

}



#pragma mark - Getter and Setter

// MARK: - 获取城市数据
-(void)getCityListData {
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    
    [indicator startAnimating:self];
    
    [AppSystemSetPresenters getCityAreasUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                NSArray *cityListData=(NSArray *)data;
                oldCityData=cityListData;
                [self sortCharacterForArray:cityListData];
                [self.tableView reloadData];
            }
            else
            {
//                [self showToastMsg:data Duration:5.0];
            }
            
        });

    }];
}

// MARK: - 按字母排序分组
-(void)sortCharacterForArray:(NSArray *)cityData {
    
    NSString *letter;
    NSArray * tmpArray;
    for(int i=0;i<arry_Index.count;i++)
    {
        letter=[arry_Index objectAtIndex:i];
        
        /** 描述查询 */
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstletter BEGINSWITH[c] %@", letter];
        tmpArray = [cityData filteredArrayUsingPredicate:predicate];
        [array_city addObject:tmpArray];
    }
    
}

#pragma mark ----------关于列表数据及协议处理--------------
/**
 *  设置隐藏列表分割线
 */
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/**
 *  设置列表数据
 */
-(void)setData:(CityCommunityModel *) data withCell:(id) cell withIndexPath:(NSIndexPath *)indexPath
{
    ChangCityCell * ccCell=(ChangCityCell *)cell;
    NSString * city=data.name;
    ccCell.lab_City.text=city;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [array_city count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return[[array_city objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        ChangCityHreadCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ChangCityHreadCell"
                                                                  forIndexPath:indexPath];
        NSInteger count=[hotCity count];
        CityCommunityModel * ccm;
        cell.btn_One.hidden=YES;
        cell.btn_Two.hidden=YES;
        cell.btn_Three.hidden=YES;
        cell.btn_Four.hidden=YES;
        UIButton *btn;
        for(int i=0;i<count;i++)
        {
            ccm=[hotCity objectAtIndex:i];
            btn=(UIButton *)[cell viewWithTag:(100+i)];
            [btn setTitle:ccm.name forState:UIControlStateNormal];
            if([XYString isBlankString:ccm.name])
            {
                btn.hidden=YES;
            }
            else
            {
                btn.hidden=NO;
            }
        }
        cell.eventBlock=^(id _Nullable data,UIView *_Nullable view,NSInteger index)
        {
            CityCommunityModel * ccm=[hotCity objectAtIndex:index];
            if(self.selectEventBlock)
            {
                cityModel=ccm;
                
                self.selectEventBlock(cityModel,tableView,0);
                [self.navigationController popViewControllerAnimated:YES];
            }
        
        };
        return cell;
    }
    ChangCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangCityCell"
                                                            forIndexPath:indexPath];
    CityCommunityModel * city=[[array_city objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self setData:city withCell:cell withIndexPath:indexPath];
    
    return cell;
}



//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return arry_Index;
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * indexstr=[NSString stringWithFormat:@"    %@",[arry_Index objectAtIndex:section-1]];
    return indexstr;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    
    NSLog(@"%@-%ld",title,(long)index);
    
    for(NSString *character in arry_Index)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
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
    if (indexPath.section==0) {
        return 120;
    }
    return 50;
}
//事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section>0)
    {
        CityCommunityModel * ccm=[[array_city objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if(self.selectEventBlock)
        {
            cityModel=ccm;
            
            self.selectEventBlock(cityModel,tableView,0);
            [self.navigationController popViewControllerAnimated:YES];
        }
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
    return 40;
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
//    UILabel * lab_title;
    if (!headerView) {
        headerView=[[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headerView"];
                headerView.backgroundColor=UIColorFromRGB(0xf1f1f1);
        headerView.contentView.backgroundColor=UIColorFromRGB(0xf1f1f1);

    }

    return headerView;
}





#pragma mark ----------事件处理--------------

///进入搜索
- (IBAction)btn_SeachEvent:(UIButton *)sender {
    SearchVC *searchVC=[SearchVC getInstance];
    searchVC.TF_SearchText.placeholder=@"请输入城市名称";
    @WeakObj(searchVC);
    
    [searchVC showVC:self cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        
        CityCommunityModel * ccm=(CityCommunityModel *)data;
        if(self.selectEventBlock)
        {
            cityModel=ccm;
            self.selectEventBlock(cityModel,view,0);
            [searchVCWeak dismissVC];
            [self.navigationController popViewControllerAnimated:YES];
        }

        
    } viewsEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {

//        if(index==2)
//        {
        
            NSString * Key=(NSString *)data;
            NSArray * tmpArray;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", Key];
            tmpArray = [oldCityData filteredArrayUsingPredicate:predicate];
            [searchVCWeak.searchArray removeAllObjects];
            [searchVCWeak.searchArray addObjectsFromArray:tmpArray];
            [searchVCWeak.tableView reloadData];
        if(searchVCWeak.searchArray.count==0)
        {
            [self showToastMsg:@"没有找到相关的数据" Duration:5.0];
        }
//        }
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        CityCommunityModel *cmm =(CityCommunityModel *)data;
        cell.textLabel.text=cmm.name;
    }];

}

#pragma mark -- 导航右按钮点击
- (void)rightBarItemClick:(UIBarButtonItem *)rightItem {
    ///点击调到首页
    AppDelegate *appDelegate = GetAppDelegates;
    
    /**
     *  性别，小区为空跳转到完善资料界面
     */
    if (appDelegate.userData.sex.intValue == 0 || [appDelegate.userData.communityid isEqualToString:@"0"] || [XYString isBlankString:appDelegate.userData.communityid]) {
        
        PerfectInforVC * regVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PerfectInforVC"];
        [self.navigationController pushViewController:regVC animated:YES];
        
    }
    else{
      
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
        MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
        appDelegate.window.rootViewController=MainTabBar;
        ///绑定标签
        [AppSystemSetPresenters getBindingTag];
        CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
        [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
        
    }
}

@end
