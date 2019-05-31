//
//  PASuggestDetailViewController.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PASuggestDetailViewController.h"
#import "PASuggestDetailView.h"
#import "PANewSuggestService.h"

@interface PASuggestDetailViewController ()
@property (nonatomic, strong)PASuggestDetailView * detailView;
@property (nonatomic, strong)PANewSuggestService * suggestService;

@end

@implementation PASuggestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.title = @"详情";
    [self loadSuggestDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PASuggestDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[PASuggestDetailView alloc]init];
    }
    return _detailView;
}
- (PANewSuggestService *)suggestService{
    if (!_suggestService) {
        _suggestService = [[PANewSuggestService alloc]init];
    }
    return _suggestService;
}
#pragma mark - Request
- (void)loadSuggestDetailData{
    @WeakObj(self);
    [self.suggestService loadSuggestDetailWithOrderId:self.orderId?:@"" success:^(PABaseRequestService *service) {
        selfWeak.detailView.detailModel = selfWeak.suggestService.suggestDetailModel;
    } failed:^(PABaseRequestService *service, NSString *errorMsg) {
        
    }];
}
@end
