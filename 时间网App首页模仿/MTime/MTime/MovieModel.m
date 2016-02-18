//
//  MovieModel.m
//  MTime
//
//  Created by YangJingchao on 16/2/18.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"cat"] isKindOfClass:[NSNull class]]){
        self.cat = dictionary[@"cat"];
    }
    if(![dictionary[@"dir"] isKindOfClass:[NSNull class]]){
        self.dir = dictionary[@"dir"];
    }
    if(![dictionary[@"dur"] isKindOfClass:[NSNull class]]){
        self.dur = [dictionary[@"dur"] integerValue];
    }
    
    if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
        self.idField = [dictionary[@"id"] integerValue];
    }
    
    if(![dictionary[@"img"] isKindOfClass:[NSNull class]]){
        self.img = dictionary[@"img"];
    }
    if(![dictionary[@"nm"] isKindOfClass:[NSNull class]]){
        self.nm = dictionary[@"nm"];
    }
    if(![dictionary[@"rt"] isKindOfClass:[NSNull class]]){
        self.rt = dictionary[@"rt"];
    }
    if(![dictionary[@"sc"] isKindOfClass:[NSNull class]]){
        self.sc = dictionary[@"sc"];
    }
    if(![dictionary[@"scm"] isKindOfClass:[NSNull class]]){
        self.scm = dictionary[@"scm"];
    }
//    if(dictionary[@"shows"] != nil && [dictionary[@"shows"] isKindOfClass:[NSArray class]]){
//        NSArray * showsDictionaries = dictionary[@"shows"];
//        NSMutableArray * showsItems = [NSMutableArray array];
//        for(NSDictionary * showsDictionary in showsDictionaries){
//            Show * showsItem = [[Show alloc] initWithDictionary:showsDictionary];
//            [showsItems addObject:showsItem];
//        }
//        self.shows = showsItems;
//    }
    if(![dictionary[@"src"] isKindOfClass:[NSNull class]]){
        self.src = dictionary[@"src"];
    }
    if(![dictionary[@"star"] isKindOfClass:[NSNull class]]){
        self.star = dictionary[@"star"];
    }
    if(![dictionary[@"ver"] isKindOfClass:[NSNull class]]){
        self.ver = dictionary[@"ver"];
    }	
    if(![dictionary[@"wish"] isKindOfClass:[NSNull class]]){
        self.wish = [dictionary[@"wish"] integerValue];
    }
    
    return self;
}


@end
