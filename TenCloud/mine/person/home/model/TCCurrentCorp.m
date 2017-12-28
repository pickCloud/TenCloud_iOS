//
//  TCCurrentCorp.m
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCurrentCorp.h"
#import "TCCorp+CoreDataClass.h"
#import "TCListCorp+CoreDataClass.h"

@interface TCCurrentCorp ()
{
    NSMutableArray      *mObserverArray;
}
@end

@implementation TCCurrentCorp

+ (instancetype) shared
{
    static TCCurrentCorp *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCCurrentCorp alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        mObserverArray = [NSMutableArray new];
    }
    return self;
}

//- (BOOL) isCurrent:(TCCorp*)corp
- (BOOL) isSameWithID:(NSInteger)cid name:(NSString*)corpName
{
    if (cid == 0 && _name == nil)
    {
        return YES;
    }
    if (cid == 0 && [_name isEqualToString:corpName])
    {
        return YES;
    }
    if (_cid == cid &&
        [_name isEqualToString:corpName])
    {
        return YES;
    }
    return NO;
}

- (void) setSelectedCorp:(TCCorp*)corp
{
    _name = corp.name;
    _mobile = corp.mobile;
    _cid = corp.cid;
    _contact = corp.contact;
}

- (void) addObserver:(id<TCCurrentCorpDelegate>)obs
{
    if (obs)
    {
        [mObserverArray addObject:obs];
    }
}

- (void) removeObserver:(id<TCCurrentCorpDelegate>)obs
{
    if (obs)
    {
        [mObserverArray removeObject:obs];
    }
}

- (void) modified
{
    TCCurrentCorp *curp = [TCCurrentCorp shared];
    for (id<TCCurrentCorpDelegate> obs in mObserverArray)
    {
        if ([obs respondsToSelector:@selector(corpModified:)])
        {
            [obs corpModified:curp];
        }
    }
}
@end
