//
//  TCGitRepo.h
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGitRepo : NSObject

@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, strong)   NSString    *address;

- (BOOL) isValid;

@end
