//
//  RaiN_SelectHouseVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_SelectHouseVC.h"
#import "RaiN_SelectHouseCell.h"//cell
#import "BBSMainPresenters.h"
@interface RaiN_SelectHouseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)NSIndexPath *currentIndex;
@property (nonatomic,strong)NSIndexPath *selectIndexPath;
@end

@implementation RaiN_SelectHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    if ([_isHouse isEqualToString:@"0"]) {
        self.navigationItem.title = @"选择房产";
    }else {
        self.navigationItem.title = @"选择车位";
    }
    [self createUI];
    [self createData];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)createData {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    
    
    if ([_isHouse isEqualToString:@"0"]) {
        //房产
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters getMyHouseAndUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    //成功
                    [_dataSource removeAllObjects];
                    if ([data[@"errmsg"] isEqualToString:@"暂无数据"]) {
                        [selfWeak showToastMsg:data[@"errmsg"] Duration:3.0f];
                        return ;
                    }
                    [_dataSource addObjectsFromArray:data[@"list"]];
                    [_tableView reloadData];
                }else {
                    //失败
                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                }
            });
            
        }];
        
    }else {
        
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
        [BBSMainPresenters getMyCarPortAndUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                
                if (resultCode == SucceedCode) {
                    //成功
                    [_dataSource removeAllObjects];
                    if ([data[@"errmsg"] isEqualToString:@"暂无数据"]) {
                        [selfWeak showToastMsg:data[@"errmsg"] Duration:3.0f];
                        return ;
                    }
                    [_dataSource addObjectsFromArray:data[@"list"]];
                    [_tableView reloadData];
                }else {
                    //失败
                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                }
            });
        }];
    }
    
}
- (void)createBackBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    
    UIImage *image = [UIImage imageNamed:@"返回"];
    [button setBackgroundImage:[image imageWithColor:TITLE_TEXT_COLOR] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backButton;
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)createUI {
//    [self createBackBarButton];
    AppDelegate *appdeleGate = GetAppDelegates;
    if ([appdeleGate.iphoneType isEqualToString:@"iPhone X"]) {
         _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, SCREEN_HEIGHT - 16 - bottomSafeArea_Height) style:UITableViewStylePlain];
    }else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, SCREEN_HEIGHT - 16) style:UITableViewStylePlain];
    }
   
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RaiN_SelectHouseCell" bundle:nil] forCellReuseIdentifier:@"RaiN_SelectHouseCell"];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RaiN_SelectHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RaiN_SelectHouseCell"];
    
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *issold = [NSString stringWithFormat:@"%@",_dataSource[indexPath.section][@"issold"]];
    if ([issold isEqualToString:@"1"]) {
        cell.backgroundColor = UIColorFromRGB(0xcfcfcf);
    }
    if ([_isHouse isEqualToString:@"0"]) {
        cell.iconImage.image = [UIImage imageNamed:@"房产帖-房产选择-房产图标"];
        cell.iconWidth.constant = 17.0;
    }else {
        cell.iconImage.image = [UIImage imageNamed:@"房产帖-房产选择-车位图标"];
        cell.iconWidth.constant = 20.0;
    }
//    data[@"list"][0][@""]
    cell.showLabel.text = [NSString stringWithFormat:@"%@ %@",_dataSource[indexPath.section][@"communityname"],_dataSource[indexPath.section][@"houseareaname"]];
    
    
    NSInteger row = [indexPath section];
    
    NSInteger oldRow = [_selectIndexPath section];
    
    if (row == oldRow && _selectIndexPath!=nil) {
        
        cell.selectImage.image = [UIImage imageNamed:@"选中图标"];
        
    }else{
        
        cell.selectImage.image = [UIImage imageNamed:@"未选中图标"];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *issold = [NSString stringWithFormat:@"%@",_dataSource[indexPath.section][@"issold"]];
    if ([issold isEqualToString:@"1"]) {
        return;
    }
    _currentIndex = indexPath;
    NSInteger newRow = [indexPath section];
    
    NSInteger oldRow = (_selectIndexPath !=nil)?[_selectIndexPath section]:-1;
    
    if (newRow != oldRow) {
        
        RaiN_SelectHouseCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        
        newCell.selectImage.image = [UIImage imageNamed:@"选中图标"];
        
        RaiN_SelectHouseCell *oldCell = [tableView cellForRowAtIndexPath:_selectIndexPath];
        
        oldCell.selectImage.image = [UIImage imageNamed:@"未选中图标"];
        _selectIndexPath = indexPath;
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.eventCallBack)
    {
        
        self.eventCallBack(_dataSource[indexPath.section],nil,_currentIndex);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)backButtonClick {
   [self.navigationController popViewControllerAnimated:YES];
}
@end
