//
//  TCCurrentCorp.h
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCCurrentCorp;
@class TCCorp;
@protocol TCCurrentCorpDelegate <NSObject>
- (void) corpModified:(TCCurrentCorp*)corp;
@end

@interface TCCurrentCorp : NSObject

+ (instancetype) shared;

@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, assign)   NSInteger   cid;
@property (nonatomic, strong)   NSString    *contact;
@property (nonatomic, strong)   NSString    *mobile;


//- (BOOL) isCurrent:(TCCorp*)corp;
- (BOOL) isSameWithID:(NSInteger)cid name:(NSString*)corpName;

- (void) setSelectedCorp:(TCCorp*)corp;

- (void) addObserver:(id<TCCurrentCorpDelegate>)obs;

- (void) removeObserver:(id<TCCurrentCorpDelegate>)obs;

- (void) modified;

@end
