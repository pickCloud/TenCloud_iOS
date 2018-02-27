//
//  TCEmptyPermission.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEmptyPermission.h"
#import "TCEmptyPermissionRequest.h"
#import "TCPermissionNode+CoreDataClass.h"
#import "TCCurrentCorp.h"


@interface TCEmptyPermission()
- (void) sendEmptyTemplateRequest;
@property (nonatomic, assign)   BOOL                needRetry;
@end

@implementation TCEmptyPermission

+ (instancetype) shared
{
    static TCEmptyPermission *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCEmptyPermission alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _permissionArray = [NSMutableArray new];
        _needRetry = NO;
        NSInteger corpID = [[TCCurrentCorp shared] cid];
        TCEmptyPermissionRequest *req = [[TCEmptyPermissionRequest alloc] initWithCorpID:corpID];
        if ([req loadCacheWithError:nil])
        {
            NSDictionary *dataDict = [req.responseJSONObject objectForKey:@"data"];
            [self parseDictionaryData:dataDict];
        }else
        {
            _needRetry = YES;
        }
        
        //[self sendEmptyTemplateRequest];
    }
    return self;
}

- (void) reset
{
    [self sendEmptyTemplateRequest];
}

- (void) sendEmptyTemplateRequest
{
    __weak __typeof(self) weakSelf = self;
    NSInteger corpID = [[TCCurrentCorp shared] cid];
    TCEmptyPermissionRequest *req = [[TCEmptyPermissionRequest alloc] initWithCorpID:corpID];
    [req startWithSuccess:^(NSArray<TCPermissionNode *> *nodeArray) {
        weakSelf.needRetry = NO;
        [weakSelf.permissionArray removeAllObjects];
        [weakSelf.permissionArray addObjectsFromArray:nodeArray];
        
    } failure:^(NSString *message) {
        if (weakSelf.needRetry)
        {
            [self performSelector:@selector(sendEmptyTemplateRequest) withObject:nil afterDelay:1.5];
        }
    }];
}

- (void) parseDictionaryData:(NSDictionary*)dict
{
    [_permissionArray removeAllObjects];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *templateObjArray = [TCPermissionNode mj_objectArrayWithKeyValuesArray:dict context:context];
    if (templateObjArray)
    {
        [_permissionArray addObjectsFromArray:templateObjArray];
    }
}

@end
