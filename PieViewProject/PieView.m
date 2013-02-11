
#import "PieView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PieView


#define ToRadians(degValue) ((float) degValue)*M_PI/180.0
#define SHIFT 134
#define DARKEN 0.20

#define NSColorFromRGB(rgbValue) [NSColor colorWithCalibratedRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@synthesize diameter;
@synthesize colors;
@synthesize font;
@synthesize stringAttributes;
@synthesize dataSource;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.font = [NSFont fontWithName:@"HelveticaNeue" size:10.0];
		self.stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,[NSColor whiteColor], NSForegroundColorAttributeName,  nil];
				
		self.colors = [[NSArray alloc] initWithObjects:
					   NSColorFromRGB(0x685bb7),
					   NSColorFromRGB(0x9e99cc),
					   NSColorFromRGB(0x3987c2),
					   NSColorFromRGB(0x6fadda),
					   NSColorFromRGB(0x6dc2a3),
					   NSColorFromRGB(0xaedd9d),
					   NSColorFromRGB(0xe7f68a),
					   NSColorFromRGB(0xfde17d),
					   NSColorFromRGB(0xfaaf51),
					   NSColorFromRGB(0xf06f38),
					   NSColorFromRGB(0xd1404e),
					   NSColorFromRGB(0x9a0443),
					   NSColorFromRGB(0x606060),
					   NSColorFromRGB(0xa8a8a8),
					   nil];
	}
	return self;
}

- (void)drawRectx:(NSRect)rect{}


- (void)drawRect:(NSRect)rect
{
	
	NSInteger count = [self.dataSource numberOfSlicesInPieView:self];
	
	if(count <= 0){
		return;
	}
	
	float startDeg = 0;
	float endDeg = 0;
	float margin = 15;
	self.diameter = MIN(rect.size.width, rect.size.height) - 2*margin;
	float x = (rect.size.width - self.diameter)/2;
	
	float y = (rect.size.height - self.diameter)/2;
	float inner_radius = self.diameter/2;
	float origin_x = x + self.diameter/2;
	float origin_y = y + self.diameter/2;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	
//	[NSGraphicsContext saveGraphicsState];
//	float locX = (rect.size.width/2 ) - diameter/2;
//	float locY = origin_y - diameter/2 -15/2;
//	CGContextAddEllipseInRect(ctx, NSMakeRect(locX, locY, diameter, 15));
//	CGContextFillPath(ctx);
//	CGContextClip(ctx);
//	
//	CGFloat components[8] = { 1,0.4,1, 1.0, 0,0,0.4, 1.0 }; // End color
//	CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
//	CGContextDrawRadialGradient(ctx, myGradient, NSMakePoint(, ), 80, NSMakePoint(, locY), 0,
//									 kCGGradientDrawsBeforeStartLocation);
	
	NSShadow * shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[NSColor blackColor]];
	[shadow setShadowBlurRadius:5.0];
	[shadow set];
	CGContextSetStrokeColorWithColor(ctx, [NSColor lightGrayColor].CGColor);
	CGContextMoveToPoint(ctx, origin_x, origin_y);
	
	CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (0)*M_PI/180.0, (360)*M_PI/180.0,0);
	CGContextStrokePath(ctx);
	
	[NSGraphicsContext restoreGraphicsState];
	
	float total = 0.0;
	
	//calucating total's
	for (int i=0; i<count; i++) {
		total = total + [dataSource pieView:self valueForSliceAtIndex:i];
	}
	
	//Stoke
	for (int i=0; i<count; i++) {
		NSColor *c = ((NSColor* )[self.colors objectAtIndex:i]);
		startDeg = endDeg;
		endDeg += [dataSource pieView:self valueForSliceAtIndex:i] / total *360.0;
		NSColor *cc = [NSColor colorWithCalibratedRed:[c redComponent]-0.10 green:[c greenComponent]-0.10 blue:[c blueComponent]-0.10 alpha:1.0];
		//drawStrokedSector
		[self drawSrtokeSerctor:inner_radius origin:origin_x origin:origin_y startDeg:startDeg endeg:endDeg color:cc];
		
	}
	//Fill
	for (int i=0; i<count; i++) {
		startDeg = endDeg;
		endDeg += [dataSource pieView:self valueForSliceAtIndex:i] / total *360.0;
		NSColor *c = ((NSColor* )[self.colors objectAtIndex:i]);
		
		//drawFilledSector
		[self drawFillSector:inner_radius origin:origin_x origin:origin_y startDeg:startDeg endeg:endDeg color:c colorSpace:colorSpace];
	}
	//Labels in rect
	for (int i=0; i<count; i++) {
		float v = [dataSource pieView:self valueForSliceAtIndex:i];
		startDeg = endDeg;
		endDeg += [dataSource pieView:self valueForSliceAtIndex:i] / total *360.0;
		
		//draw rect
		[self drawRoundRect:[NSNumber numberWithFloat:v] origin:origin_x origin:origin_y startDeg:startDeg endeg:endDeg];
		
		//draw label
		NSNumber *percent= [NSNumber numberWithFloat:(v / total *100)];
		[self drawLabel:percent origin:origin_x origin:origin_y startDeg:startDeg endeg:endDeg];
		
	}
	
}

-(void) drawRoundRect:(NSNumber*) value origin:(float) origin_x origin:(float) origin_y startDeg:(float) sdeg endeg:(float) edeg {
	[NSGraphicsContext saveGraphicsState];
	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	float x = origin_x + (diameter/2*0.75)*cos(ToRadians( sdeg + ((edeg - sdeg) / 2) - SHIFT ));
	float y = origin_y + (diameter/2*0.75)*sin(ToRadians( sdeg + ((edeg - sdeg) / 2) - SHIFT ));
	
	NSString *string = [NSString stringWithFormat:@"%dXX", [value intValue]];
	NSSize size = [string sizeWithAttributes:stringAttributes];
	size.width = ceilf(size.width);
	size.height	= ceilf(size.height);
	
	CGContextSetFillColorWithColor(ctx, [NSColor colorWithCalibratedRed:0.0	green:0.0 blue:0.0 alpha:0.4f].CGColor);
	CGContextSetStrokeColorWithColor(ctx, [NSColor colorWithCalibratedRed:0.6	green:0.6 blue:0.6 alpha:0.7f].CGColor);
	CGContextAddRoundRect(ctx, NSMakeRect(x-size.width/2, y-size.height/2+1, size.width, size.height), 2.5);
	CGContextFillPath(ctx);
	CGContextAddRoundRect(ctx, NSMakeRect(x-size.width/2, y-size.height/2+1, size.width, size.height), 2.5);
	CGContextStrokePath(ctx);
	[NSGraphicsContext restoreGraphicsState];

}

-(void) drawSrtokeSerctor:(float) inner_radius origin:(float) origin_x origin:(float) origin_y startDeg:(float) sdeg endeg:(float) edeg color:(NSColor*) color{
	[NSGraphicsContext saveGraphicsState];
	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSetStrokeColorWithColor(ctx, color.CGColor);
	CGContextMoveToPoint(ctx, origin_x, origin_y);
	CGContextAddArc(ctx, origin_x, origin_y, inner_radius, ToRadians(sdeg-SHIFT),ToRadians(edeg-SHIFT), 0);
	CGContextClosePath(ctx);
	CGContextStrokePath(ctx);
	[NSGraphicsContext restoreGraphicsState];
}

-(void) drawFillSector:(float) inner_radius origin:(float) origin_x origin:(float) origin_y startDeg:(float) sdeg endeg:(float) edeg color:(NSColor*) color colorSpace:(CGColorSpaceRef) space{
	[NSGraphicsContext saveGraphicsState];
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.3, 1.0 };
	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextMoveToPoint(ctx, origin_x, origin_y);
	CGContextAddArc(ctx, origin_x, origin_y, inner_radius, ToRadians(sdeg-SHIFT),ToRadians(edeg-SHIFT), 0);
	CGContextClosePath(ctx);
	CGContextClip(ctx);
	CGFloat components[8] = { [color redComponent], [color greenComponent], [color blueComponent], 1.0,
		[color redComponent]-DARKEN, [color greenComponent]-DARKEN, [color blueComponent]-DARKEN, 1.0 };
	CGGradientRef myGradient = CGGradientCreateWithColorComponents (space, components, locations, num_locations);
	CGContextDrawRadialGradient (ctx, myGradient, NSMakePoint(origin_x, origin_y), 0, NSMakePoint(origin_x, origin_y), diameter/2+(diameter/2/2),kCGGradientDrawsBeforeStartLocation);
	[NSGraphicsContext restoreGraphicsState];
}

-(void) drawLabel:(NSNumber*) value origin:(float) origin_x origin:(float) origin_y startDeg:(float) sdeg endeg:(float) edeg{
	[NSGraphicsContext saveGraphicsState];
	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSetLineWidth(ctx, 0.5);
	CGContextSetStrokeColorWithColor(ctx, [NSColor blackColor].CGColor);
	CGContextSetFillColorWithColor(ctx, [NSColor blackColor].CGColor);
	NSString* string = [NSString stringWithFormat:@"%d%%", [value intValue]];
	float x = origin_x + (diameter/2*0.75)*cos(ToRadians( sdeg + ((edeg - sdeg) / 2) - SHIFT ));
	float y = origin_y + (diameter/2*0.75)*sin(ToRadians( sdeg + ((edeg - sdeg) / 2) - SHIFT ));
	NSSize size = [string sizeWithAttributes:stringAttributes];
	[string drawAtPoint:NSMakePoint(x-size.width/2, y-size.height/2+2) withAttributes:stringAttributes];
	[NSGraphicsContext restoreGraphicsState];
}

void CGContextAddRoundRect(CGContextRef context, CGRect rect, float radius){

	[NSGraphicsContext saveGraphicsState];
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI , M_PI / 2, 1);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,rect.origin.y + rect.size.height);
	CGContextAddArc(context, rect.origin.x + rect.size.width - radius,rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,radius, 0.0f, -M_PI / 2, 1);
	CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
	CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,-M_PI / 2, M_PI, 1);
	[NSGraphicsContext restoreGraphicsState];
}

@end
