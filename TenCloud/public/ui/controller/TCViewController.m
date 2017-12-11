//
//  TCViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCViewController.h"


@interface TCViewController ()

@end

@implementation TCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = THEME_BACKGROUND_COLOR;
    
    if (self.navigationController.viewControllers.count > 1) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchDown];
        UIImage *nomalImage = [UIImage imageNamed:@"public_back"];
        [button setImage:[nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        [button sizeToFit];
        //[button setBackgroundColor:[UIColor redColor]];
        
        /*
        if (button.bounds.size.width < 40) {
            CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
            button.bounds = CGRectMake(0, 0, width, 40);
        }
        if (button.bounds.size.height > 40) {
            CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
            button.bounds = CGRectMake(0, 0, 40, height);
        }
        
        button.imageEdgeInsets = UIEdgeInsetsZero;
         */
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
