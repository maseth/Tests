//
//  Ds.m
//  PieViewProject
//
//  Created by Maciej Gregorczyk on 10.02.2013.
//  Copyright (c) 2013 Maciej Gregorczyk. All rights reserved.
//

#import "Ds.h"

@implementation Ds


- (NSUInteger)numberOfSlicesInPieView:(PieView *)pieView{
	//Teraz wiecej zmian ! 
	return 7;
}


- (float) pieView:(PieView *)pieView valueForSliceAtIndex:(NSUInteger)index{
	return index * 10 +10;
}

- (NSString *)pieView:(PieView *)pieView textForSliceAtIndex:(NSUInteger)index{
	return  [NSString stringWithFormat:@"su %ld " , (unsigned long)index];
}

@end
