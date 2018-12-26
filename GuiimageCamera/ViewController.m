//
//  ViewController.m
//  GuiimageCamera
//
//  Created by Liyanjun on 2018/12/25.
//  Copyright © 2018 hand. All rights reserved.
//

#import "ViewController.h"
static NSString* const ViewTableViewCellId=@"cellId";
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic ,strong) NSMutableArray*dataSource;
@end
@implementation ViewController
#pragma mark - lifecircle
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - constructView
- (void)setupUi{
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
}
#pragma mark - methods
#pragma mark - action
#pragma mark - delegate
#pragma mark  tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *viewctlStr = dic.allValues.firstObject;
    UIViewController *ctl = [[NSClassFromString(viewctlStr) alloc] init];
    [self presentViewController:ctl animated:YES completion:nil];
}
#pragma mark  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ViewTableViewCellId ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ViewTableViewCellId];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.textLabel.text = dic.allKeys.firstObject;
    return cell;
}
#pragma mark -  setter and getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        _dataSource = [@[@{@"基本滤镜":@"SimpleFiterCameraViewController"},
                         @{@"组合滤镜":@"FilterCameraGroupViewController"},]
                   copy];
    }
    return _dataSource;
}
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_StatusBar, ScreenWidth, ScreenHeight -Height_StatusBar)];
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        //注册cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ViewTableViewCellId];
        
    }
    return _tableView;
}
@end
