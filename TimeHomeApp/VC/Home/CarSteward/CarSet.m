//
//  CarSet.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarSet.h"
#import "CarSetCell.h"
#import "IntelligentGarageVC.h"
#import "ShowMapVC.h"
#import "GetAddressMapVC.h"
#import "CarControlController.h"

@interface CarSet ()<UITableViewDelegate,UITableViewDataSource,MapAdrrBackDelegate>


@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *iconDataSource;


@end

@implementation CarSet

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"绑定设备";
    self.view.backgroundColor = [UIColor clearColor];
    [self createTableView];
    [self createDataSource];
    self.tabBarController.tabBar.hidden = YES;

    
}


- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0,[UIScreen mainScreen].bounds.size.width - 10, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    /** 注册 */
    [_tableView registerNib:[UINib nibWithNibName:@"CarSetCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    

    
    
}

- (void)createDataSource {
    
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObjects:@"车辆管理",@"定位服务", nil];
    }
    if (!_iconDataSource) {
        _iconDataSource = [NSMutableArray arrayWithObjects:@"车辆设置_车辆管理图标",@"车辆设置_定位服务图标", nil];
    }
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    CarSetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    cell.iconIamge.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_iconDataSource[indexPath.row]]];
    return cell;
    
   }



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        CarSetCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.titleLabel.text isEqualToString:@"车辆管理"]) {
        
#warning 车辆管理页面
        CarControlController *carControl = [[CarControlController alloc] init];
        [self.navigationController pushViewController:carControl animated:YES];
    
        
    }else if ([cell.titleLabel.text isEqualToString:@"定位服务"]) {
        
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
        GetAddressMapVC * showMap = [secondStoryBoard instantiateViewControllerWithIdentifier:@"GetAddressMapVC"];
//        showMap.delegate = self;
        [self.navigationController pushViewController:showMap animated:YES];

#if 0
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"BDMapViews" bundle:nil];
        ShowMapVC * carMap= [secondStoryBoard instantiateViewControllerWithIdentifier:@"ShowMapVC" ];
        carMap.jumpCode=2;
        carMap.title=@"查看地图";
        BMKPoiInfo * poiInfo=[BMKPoiInfo new];
        CLLocationCoordinate2D coordinate;
//        coordinate.latitude = [self.room.mapy doubleValue];
//        coordinate.longitude = [self.room.mapx doubleValue];
        poiInfo.pt=coordinate;
//        poiInfo.address=self.room.address;
//        poiInfo.name=self.room.communityname;
        carMap.poiInfo=poiInfo;
        [self.navigationController pushViewController:carMap animated:YES];
#endif

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
