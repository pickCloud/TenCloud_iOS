//
//  TCDissentViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/29.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCDissentViewController.h"

@interface TCDissentViewController ()
- (IBAction) onTelphoneButton:(id)sender;
@end

@implementation TCDissentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提起企业异议";
    
    
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
- (IBAction) onTelphoneButton:(id)sender
{
    NSString *telString = [NSString stringWithFormat:@"tel://%@",@"05922232326"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

@end
