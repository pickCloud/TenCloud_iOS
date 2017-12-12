//
//  TCServerMonitorViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerMonitorViewController.h"
#import "TCServerPerformanceRequest.h"

@interface TCServerMonitorViewController ()
@property (nonatomic, assign)   NSInteger   serverID;
@end

@implementation TCServerMonitorViewController

- (instancetype) initWithID:(NSInteger)serverID
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = endTime - 3600;
    TCServerPerformanceRequest *request = [[TCServerPerformanceRequest alloc] initWithServerID:_serverID type:0 startTime:startTime endTime:endTime];
    [request startWithSuccess:^(TCServerPerformance *performance) {
        NSLog(@"perfor:%@",performance);
    } failure:^(NSString *message) {
        NSLog(@"message:%@",message);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
