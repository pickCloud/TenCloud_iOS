//
//  TCGitRepo.m
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCGitRepo.h"

@implementation TCGitRepo

- (BOOL) isValid
{
    BOOL valid = (_address != nil) && (_address.length > 0);
    return valid;
}
@end
