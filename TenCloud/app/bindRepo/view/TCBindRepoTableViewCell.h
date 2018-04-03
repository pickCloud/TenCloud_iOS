//
//  TCBindRepoTableViewCell.h
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCGitRepo;
@interface TCBindRepoTableViewCell : UITableViewCell

- (void) setRepo:(TCGitRepo*)repo;

@end
