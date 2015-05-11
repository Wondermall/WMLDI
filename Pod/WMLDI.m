//
//  WMLDI.m
//  Wondermall
//
//  Created by Sash Zats on 2/2/15.
//  Copyright (c) 2015 Wondermall Inc. All rights reserved.
//

#import "WMLDI.h"

#import <objc/runtime.h>


@implementation WMLDI

+ (instancetype)di {
    static WMLDI *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)enumerateClassesConformingToProtocol:(Protocol *)protocol usingBlock:(void(^)(Class class, BOOL *stop))block {
    [self _enumerateAllClassesUsingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
        if (class_conformsToProtocol(class, protocol)) {
            block(class, stop);
        }
    }];
}

- (Class)anyClassImplementingProtocol:(Protocol *)protocol {
    __block Class result;
    [self enumerateClassesConformingToProtocol:protocol usingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
        result = class;
        *stop = YES;
    }];
    return result;
}

- (void)enumerateSubclassesOfClass:(Class)superclass usingBlock:(void (^)(__unsafe_unretained Class, BOOL *))block {
    [self _enumerateAllClassesUsingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
        if (class == superclass) {
            return;
        }
        
        Class currentClass = class;
        while (currentClass && currentClass != [NSObject class]) {
            currentClass = class_getSuperclass(currentClass);
            if (currentClass == superclass) {
                block(class, stop);
                break;
            }
        }
    }];
}

- (Class)anySubclassOfClass:(Class)inClass {
    __block Class result;
    [self enumerateSubclassesOfClass:inClass usingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
        result = class;
        *stop = YES;
    }];
    return result;
}

#pragma mark - Private

- (void)_enumerateAllClassesUsingBlock:(void(^)(Class class, BOOL *stop))block {
    unsigned int classesCount;
    BOOL stop = NO;
    Class *classList = objc_copyClassList(&classesCount);
    for (unsigned int i = 0; i < classesCount; ++i) {
        Class class = classList[i];
        if (![NSStringFromClass(class) isEqualToString:@"_NSZombie_"]) {
            block(class, &stop);
        }
        if (stop) {
            break;
        }
    }
    free(classList);
}

@end
