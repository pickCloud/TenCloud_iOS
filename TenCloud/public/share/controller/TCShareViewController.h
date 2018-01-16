//
//  TCShareViewController.h
//
//
//  Created by huangdx on 2017/10/21.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TCShareViewController : UIViewController

@property (nonatomic, strong)   NSString    *content;
@property (nonatomic, strong)   NSString    *urlString;
- (void) showContentView;

@end
