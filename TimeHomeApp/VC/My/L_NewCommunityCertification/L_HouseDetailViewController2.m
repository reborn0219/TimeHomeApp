//
//  L_HouseDetailViewController2.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailViewController2.h"
#import "L_HouseDetailBaseTVC5.h"

#import "L_CommunityAuthoryPresenters.h"

@interface L_HouseDetailViewController2 () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *top_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *top_Label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) L_HouseInfoModel *houseInfoModel;


@end

@implementation L_HouseDetailViewController2

#pragma mark - 房产详情

- (void)httpRequestForGetInfo {
    
    [L_CommunityAuthoryPresenters getResiInfoWithID:_theID UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                _houseInfoModel = (L_HouseInfoModel *)data;
                //1.出租 2.共享
                _houseInfoModel.infoType = _type;
                
                [_tableView reloadData];
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
            [_tableView.mj_header endRefreshing];

        });
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_type == 1) {
        
        _top_ImageView.image = [UIImage imageNamed:@"社区认证-出租"];
        _top_Label.text = @"出租";
        
    }else if (_type == 2) {
        
        _top_ImageView.image = [UIImage imageNamed:@"社区认证-房产2"];
        _top_Label.text = @"共享";
        
    }
    
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    _tableView.estimatedRowHeight = 100;
    [_tableView registerNib:[UINib nibWithNibName:@"L_HouseDetailBaseTVC5" bundle:nil] forCellReuseIdentifier:@"L_HouseDetailBaseTVC5"];
    
    @WeakObj(self)
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
         [selfWeak httpRequestForGetInfo];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_houseInfoModel.height > 0) {
        return _houseInfoModel.height;
    }else {
        return 250.f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    L_HouseDetailBaseTVC5 *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HouseDetailBaseTVC5"];
    
    cell.model = _houseInfoModel;
    
    return cell;
    
}

@end
