//
//  DescribeViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "DescribeViewController.h"
#import "SignsView.h"

@interface DescribeViewController () <UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SignsView *signView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"描述";

//    [self createSignView];
    [self createTableView];
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WidthSpace(328)+20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 64;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    
    UIButton *completionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completionButton.backgroundColor = PURPLE_COLOR;
    [completionButton setTitle:@"完  成" forState:UIControlStateNormal];
    completionButton.titleLabel.font = DEFAULT_FONT(16);
    [completionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    completionButton.frame = CGRectMake(15, 15, SCREEN_WIDTH-30-14, 40);
    [view addSubview:completionButton];

    [completionButton addTarget:self action:@selector(completionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _signView = [[SignsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-14, WidthSpace(328))];
    _signView.signTextView.delegate = self;
    _signView.countsLabel.hidden = YES;
    _signView.signTextView.placeHolder.text = @"详细描述车位信息";

    if ([XYString isBlankString:_describeString]) {
        _signView.signTextView.placeHolder.hidden = NO;
        _signView.signTextView.text = @"";

    }else {
        _signView.signTextView.text = _describeString;
//        _signView.signTextView.placeHolder.text = @"";
        _signView.signTextView.placeHolder.hidden = YES;

    }
    
    [cell.contentView addSubview:_signView];
    
    return cell;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _signView.signTextView.placeHolder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([XYString isBlankString:textView.text]) {
        _signView.signTextView.placeHolder.hidden = NO;
    }else {
        _signView.signTextView.placeHolder.hidden = YES;
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    
//    if (![text isEqualToString:@""]){
//        
//        _signView.signTextView.placeHolder.hidden = YES;
//        
//    }
//    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
//        
//        _signView.signTextView.placeHolder.hidden = NO;
//        
//    }
//
//    NSString * toBeString = [ _signView.signTextView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
//    if (toBeString.length != 0) {
//        _signView.signTextView.placeHolder.hidden = YES;
//    }
//
//    return YES;
//    
//}

/**
 *  完成
 */
- (void)completionButtonClick {
    
    [_signView.signTextView resignFirstResponder];
    
    if (_signView.signTextView.text.length < 10) {
        [self showToastMsg:@"详细描述车位信息，至少10字" Duration:2.0];
        return;
    }
    
    if (self.describeCallBack) {
        self.describeCallBack(_signView.signTextView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
