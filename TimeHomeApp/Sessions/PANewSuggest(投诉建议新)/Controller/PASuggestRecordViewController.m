//
//  PASuggestRecordViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PASuggestRecordViewController.h"
#import "PASuggestRecordTableViewCell.h"
#import "PASuggestDetailViewController.h"
#import "PANewSuggestService.h"
@interface PASuggestRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * recordTableView;
@property (nonatomic, strong)PANewSuggestService * suggestService;
@property (nonatomic, assign)NSInteger currentPage;
@end

@implementation PASuggestRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投诉记录";
    [self.view addSubview:self.recordTableView];
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _currentPage = 0 ;
    [self loadSuggestListData:YES];
    
    self.recordTableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [self loadSuggestListData:YES];
    }];
    self.recordTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadSuggestListData:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.rowHeight = 89;
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _recordTableView;
}
- (PANewSuggestService *)suggestService{
    if (!_suggestService) {
        _suggestService = [[PANewSuggestService alloc]init];
    }
    return _suggestService;
}


#pragma mark - Request
- (void)loadSuggestListData:(BOOL)header{
    if (header) {
        _currentPage = 1;
    } else{
        _currentPage +=1;
    }
    [self.suggestService loadSuggestListWithPage:_currentPage success:^(PABaseRequestService *service) {
        if (self.suggestService.suggestArray.count == 0) {
            [self showNoDataView];
        }
        [self.recordTableView.mj_header endRefreshing];
        [self.recordTableView.mj_footer endRefreshing];
        [self.recordTableView reloadData];
    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        [self.recordTableView.mj_header endRefreshing];
        [self.recordTableView.mj_footer endRefreshing];
        [self showNoDataView];
    }];
}
#pragma mark - Actions
- (void)showNoDataView{
    [self showNothingnessViewWithType:NoNewNoticeData Msg:@"抱歉，您暂时还没有投诉记录" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
        
    }];
}

#pragma mark - TableViewDelegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.suggestService.suggestArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"PASuggestRecordTableViewCell";
    PASuggestRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PASuggestRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.suggestModel = self.suggestService.suggestArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PASuggestListModel * model = self.suggestService.suggestArray[indexPath.row];
    PASuggestDetailViewController * detail = [[PASuggestDetailViewController alloc]init];
    detail.orderId =model.workOrderCode;
    [self.navigationController pushViewController:detail animated:YES];
}
@end
