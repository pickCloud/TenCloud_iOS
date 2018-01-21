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

#define CORP_NAME       @"CORP_NAME"
#define CORP_CID        @"CORP_CID"
#define CORP_MOBILE     @"CORP_MOBILE"
#define CORP_CONTACT    @"CORP_CONTACT"
#define CORP_IS_ADMIN   @"CORP_IS_ADMIN"
#define CORP_IMAGE_URL  @"CORP_IMAGE_URL"

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
        NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileName = [array.firstObject stringByAppendingPathComponent:@"currrentCorpArchiverModel"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
        {
            NSData *undata = [[NSData alloc] initWithContentsOfFile:fileName];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:undata];
            self = [unarchiver decodeObjectForKey:@"corp_model"];
            [unarchiver finishDecoding];
        }
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        mObserverArray = [NSMutableArray new];
        self.name = [aDecoder decodeObjectForKey:CORP_NAME];
        self.mobile = [aDecoder decodeObjectForKey:CORP_MOBILE];
        self.cid = [aDecoder decodeIntegerForKey:CORP_CID];
        self.contact = [aDecoder decodeObjectForKey:CORP_CONTACT];
        self.isAdmin = [aDecoder decodeBoolForKey:CORP_IS_ADMIN];
        self.image_url = [aDecoder decodeObjectForKey:CORP_IMAGE_URL];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.cid forKey:CORP_CID];
    [aCoder encodeObject:self.name forKey:CORP_NAME];
    [aCoder encodeObject:self.mobile forKey:CORP_MOBILE];
    [aCoder encodeObject:self.contact forKey:CORP_CONTACT];
    [aCoder encodeBool:self.isAdmin forKey:CORP_IS_ADMIN];
    [aCoder encodeObject:self.image_url forKey:CORP_IMAGE_URL];
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
    _isAdmin = corp.is_admin;
    [self save];
}

- (void) setIsAdmin:(BOOL)isAdmin
{
    _isAdmin = isAdmin;
    [self modified];
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

- (BOOL) exist
{
    BOOL isExist = self.cid > 0;
    return isExist;
}

- (void) modified
{
    for (id<TCCurrentCorpDelegate> obs in mObserverArray)
    {
        if (obs && [obs respondsToSelector:@selector(corpModified:)])
        {
            [obs corpModified:self];
        }
    }
}

- (void) reset
{
    _name = @"";
    _mobile = @"";
    _cid = 0;
    _contact = @"";
    _isAdmin = 0;
    _image_url = @"";
    [self save];
}

- (void) save
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[TCCurrentCorp shared] forKey:@"corp_model"];
    [archiver finishEncoding];
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [array.firstObject stringByAppendingPathComponent:@"currrentCorpArchiverModel"];
    if([data writeToFile:fileName atomically:YES]){
        NSLog(@"归档成功");
    }
}
@end
