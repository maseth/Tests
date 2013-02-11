//
//  PieView.h
//  PieViewProject
//
//  Created by Maciej Gregorczyk on 02.02.2013.
//  Copyright (c) 2013 Maciej Gregorczyk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PieView;

@protocol PieViewDataSource <NSObject>
@required
- (NSUInteger)numberOfSlicesInPieView:(PieView *)pieView;
- (float)pieView:(PieView *)pieView valueForSliceAtIndex:(NSUInteger)index;
@optional
- (NSString *)pieView:(PieView *)pieView textForSliceAtIndex:(NSUInteger)index;
@end


@interface PieView : NSView

@property (nonatomic, weak) id<PieViewDataSource>dataSource;

@property float diameter;
@property NSArray* values;
@property NSArray* colors;
@property NSFont* font;
@property NSDictionary* stringAttributes;


-(void) drawLabel:(NSNumber*) value origin:(float) origin_x origin:(float) origin_y startDeg:(float) sdeg endeg:(float) edeg;

-(void) drawFillSector:(float) inner_radius origin:(float) origin_x origin:(float) origin_y startDeg:(float) sdeg endeg:(float) edeg color:(NSColor*) color colorSpace:(CGColorSpaceRef) space;

-(void) drawSrtokeSerctor:(float) inner_radius origin:(float) origin_x origin:(float) origin_y startDeg:(float) sdeg endeg:(float) edeg color:(NSColor*) color;
@end


