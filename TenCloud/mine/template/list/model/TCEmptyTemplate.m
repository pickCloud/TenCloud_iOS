//
//  TCEmptyTemplate.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEmptyTemplate.h"
#import "TCRawTemplateRequest.h"
#import "TCPermissionSegment+CoreDataClass.h"
#import "TCCurrentCorp.h"

@interface TCEmptyTemplate()
- (void) sendEmptyTemplateRequest;
@property (nonatomic, assign)   BOOL                needRetry;
@end

@implementation TCEmptyTemplate

+ (instancetype) shared
{
    static TCEmptyTemplate *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCEmptyTemplate alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _templateArray = [NSMutableArray new];
        _needRetry = NO;
        NSInteger corpID = [[TCCurrentCorp shared] cid];
        TCRawTemplateRequest *req = [[TCRawTemplateRequest alloc] initWithCorpID:corpID];
        if ([req loadCacheWithError:nil])
        {
            NSDictionary *dataDict = [req.responseJSONObject objectForKey:@"data"];
            [self parseDictionaryData:dataDict];
        }else
        {
            _needRetry = YES;
        }
        
        [self sendEmptyTemplateRequest];
    }
    return self;
}

- (void) sendEmptyTemplateRequest
{
    __weak __typeof(self) weakSelf = self;
    NSInteger corpID = [[TCCurrentCorp shared] cid];
    TCRawTemplateRequest *req = [[TCRawTemplateRequest alloc] initWithCorpID:corpID];
    [req startWithSuccess:^(NSArray<TCPermissionSegment *> *segArray) {
        weakSelf.needRetry = NO;
        [weakSelf.templateArray removeAllObjects];
        [weakSelf.templateArray addObjectsFromArray:segArray];
    } failure:^(NSString *message) {
        if (weakSelf.needRetry)
        {
            [self performSelector:@selector(sendEmptyTemplateRequest) withObject:nil afterDelay:1.5];
        }
    }];
}

- (void) parseDictionaryData:(NSDictionary*)dict
{
    [_templateArray removeAllObjects];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *templateObjArray = [TCPermissionSegment mj_objectArrayWithKeyValuesArray:dict context:context];
    if (templateObjArray)
    {
        [_templateArray addObjectsFromArray:templateObjArray];
    }
}

- (void) print
{
    
}
@end
