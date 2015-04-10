//
//  WMLDI.h
//  Wondermall
//
//  Created by Sash Zats on 2/2/15.
//  Copyright (c) 2015 Wondermall Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMLDI : NSObject

+ (instancetype)sharedDI;

- (void)enumerateClassesConformingToProtocol:(Protocol *)protocol usingBlock:(void(^)(Class class, BOOL *stop))block;

- (Class)anyClassImplementingProtocol:(Protocol *)protocol;

- (void)enumerateSubclassesOfClass:(Class)class usingBlock:(void(^)(Class class, BOOL *stop))block;

- (Class)anySubclassOfClass:(Class)class;

@end
