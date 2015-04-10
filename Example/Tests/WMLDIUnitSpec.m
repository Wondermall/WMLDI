//
//  WMLDIUnitSpec.m
//  Wondermall
//
//  Created by Sash Zats on 2/15/15.
//  Copyright (c) 2015 Wondermall Inc. All rights reserved.
//

#import "WMLDI.h"


@protocol WMLDITestProtocol1 <NSObject> @end

@interface WMLDITestProtocol1Implementation1 : NSObject <WMLDITestProtocol1> @end
@implementation WMLDITestProtocol1Implementation1 @end

@interface WMLDITestProtocol1Implementation2 : NSObject <WMLDITestProtocol1> @end
@implementation WMLDITestProtocol1Implementation2 @end


@protocol WMLDITestProtocol2 <NSObject> @end

@interface WMLDITestProtocol2Implementation1 : NSObject <WMLDITestProtocol2> @end
@implementation WMLDITestProtocol2Implementation1 @end


@protocol WMLDITestEmptyProtocol <NSObject> @end


@interface WMLSuperclass1 : NSObject @end
@implementation WMLSuperclass1 @end

@interface WMLSuperclass1Sublclass1 : WMLSuperclass1 @end
@implementation WMLSuperclass1Sublclass1 @end

@interface WMLSuperclass1Sublclass2 : WMLSuperclass1 @end
@implementation WMLSuperclass1Sublclass2 @end


@interface WMLSuperclass2 : NSObject @end
@implementation WMLSuperclass2 @end

@interface WMLSuperclass2Subclass1 : WMLSuperclass2 @end
@implementation WMLSuperclass2Subclass1 @end


@interface WMLSuperclass3 : NSObject @end
@implementation WMLSuperclass3 @end

@interface WMLSuperclass3Subclass1 : WMLSuperclass3 @end
@implementation WMLSuperclass3Subclass1 @end

@interface WMLSuperclass3Subclass1Grandsubclass1 : WMLSuperclass3Subclass1 @end
@implementation WMLSuperclass3Subclass1Grandsubclass1 @end



@interface WMLEmptySuperclass : NSObject @end
@implementation WMLEmptySuperclass @end



SpecBegin(WMLDIUnit)

describe(@"WMLDI", ^{
    context(@"protocols", ^{
        describe(@"enumerateClassesConformingToProtocol", ^{
            it(@"should enumerate through all classes implementing protocol", ^{
                NSMutableSet *conformingClasses = [NSMutableSet set];
                [[WMLDI sharedDI] enumerateClassesConformingToProtocol:@protocol(WMLDITestProtocol1) usingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
                    [conformingClasses addObject:class];
                }];
                expect(conformingClasses).to.haveCountOf(2);
                expect(conformingClasses).to.contain([WMLDITestProtocol1Implementation1 class]);
                expect(conformingClasses).to.contain([WMLDITestProtocol1Implementation2 class]);
            });
            
            it(@"should not enumerate if protocol is not implemented by any class", ^{
                NSMutableSet *conformingClasses = [NSMutableSet set];
                [[WMLDI sharedDI] enumerateClassesConformingToProtocol:@protocol(WMLDITestEmptyProtocol) usingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
                    [conformingClasses addObject:class];
                }];
                expect(conformingClasses).to.beEmpty();
            });
        });
        
        describe(@"enumerateClassesConformingToProtocol", ^{
            it(@"should return any class for protocol", ^{
                Class class = [[WMLDI sharedDI] anyClassImplementingProtocol:@protocol(WMLDITestProtocol2)];
                expect(class).to.equal([WMLDITestProtocol2Implementation1 class]);
            });
            
            it(@"should return nil for protocol not implemented by any classes", ^{
                Class class = [[WMLDI sharedDI] anyClassImplementingProtocol:@protocol(WMLDITestEmptyProtocol)];
                expect(class).to.beNil();
            });
        });
    });
    
    context(@"subclasses", ^{
        describe(@"enumerateSubclassesOfClass", ^{
            it(@"should include direct subclasses of a class", ^{
                NSMutableSet *subclasses = [NSMutableSet set];
                [[WMLDI sharedDI] enumerateSubclassesOfClass:[WMLSuperclass1 class] usingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
                    [subclasses addObject:class];
                }];
                expect(subclasses).to.haveCountOf(2);
                expect(subclasses).to.contain([WMLSuperclass1Sublclass1 class]);
                expect(subclasses).to.contain([WMLSuperclass1Sublclass2 class]);
            });
            
            it(@"should include not direct subclasses", ^{
                NSMutableSet *subclasses = [NSMutableSet set];
                [[WMLDI sharedDI] enumerateSubclassesOfClass:[WMLSuperclass3 class] usingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
                    [subclasses addObject:class];
                }];
                expect(subclasses).to.haveCountOf(2);
                expect(subclasses).to.contain([WMLSuperclass3Subclass1Grandsubclass1 class]);
            });
            
            it(@"should not include any classes for a class that does not have any subclasses", ^{
                NSMutableSet *subclasses = [NSMutableSet set];
                [[WMLDI sharedDI] enumerateSubclassesOfClass:[WMLEmptySuperclass class] usingBlock:^(__unsafe_unretained Class class, BOOL *stop) {
                    [subclasses addObject:class];
                }];
                expect(subclasses).to.beEmpty();
            });
        });
        
        describe(@"anySubclassOfClass", ^{
            it(@"should return correct subclass for superclass", ^{
                Class class = [[WMLDI sharedDI] anySubclassOfClass:[WMLSuperclass2 class]];
                expect(class).to.equal([WMLSuperclass2Subclass1 class]);
            });
        
            it(@"should not return any entities of a class that does not have any subclasses", ^{
                Class class = [[WMLDI sharedDI] anySubclassOfClass:[WMLEmptySuperclass class]];
                expect(class).to.beNil();
            });
        });
    });
});

SpecEnd