//
//  WScene.m
//  SKPhysicsJointSlidingDemo
//
//  Created by jins on 14-6-23.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

#import "WScene.h"

@interface WScene()
@property (nonatomic, weak) SKNode *select;
@end

@implementation WScene

- (void)didMoveToView:(SKView *)view
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    [self createSlide];
    [self createArrow];
}

- (void)createSlide
{
    for (int i=0; i<5; i++) {
        SKNode *bar = [SKNode node];
        bar.name = @"bar";
        bar.position = CGPointMake(160, i * 51 + 100);
        [self addChild:bar];
        
        SKPhysicsBody *body;
        
        if (i % 2) {
            SKSpriteNode *barR = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithHue:0.2 * i saturation:0.5 brightness:0.9 alpha:1] size:CGSizeMake(275, 50)];
            barR.position = CGPointMake(-160, 0);
            [bar addChild:barR];
            SKSpriteNode *barL = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithHue:0.2 * i saturation:0.5 brightness:0.9 alpha:1] size:CGSizeMake(275, 50)];
            barL.position = CGPointMake(160, 0);
            [bar addChild:barL];
            
            body = [SKPhysicsBody bodyWithBodies:@[[SKPhysicsBody bodyWithRectangleOfSize:barR.size center:barR.position], [SKPhysicsBody bodyWithRectangleOfSize:barL.size center:barL.position]]];
            
        } else {
            SKSpriteNode *barR = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithHue:0.2 * i saturation:0.5 brightness:0.9 alpha:1] size:CGSizeMake(150, 50)];
            barR.position = CGPointMake(-200, 0);
            [bar addChild:barR];
            
            SKSpriteNode *barM = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithHue:0.2 * i saturation:0.5 brightness:0.9 alpha:1] size:CGSizeMake(80, 50)];
            barM.position = CGPointMake(0, 0);
            [bar addChild:barM];
            
            SKSpriteNode *barL = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithHue:0.2 * i saturation:0.5 brightness:0.9 alpha:1] size:CGSizeMake(150, 50)];
            barL.position = CGPointMake(200, 0);
            [bar addChild:barL];
            
            body = [SKPhysicsBody bodyWithBodies:@[[SKPhysicsBody bodyWithRectangleOfSize:barR.size center:barR.position], [SKPhysicsBody bodyWithRectangleOfSize:barM.size center:barM.position], [SKPhysicsBody bodyWithRectangleOfSize:barL.size center:barL.position]]];
        }
        
        bar.physicsBody = body;
        SKPhysicsJointSliding *s = [SKPhysicsJointSliding jointWithBodyA:bar.physicsBody bodyB:self.physicsBody anchor:bar.position axis:CGVectorMake(1, 0)];
        [self.physicsWorld addJoint:s];
    }
}

- (void)createArrow
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-15, 20)];
    [path addLineToPoint:CGPointMake(0, 10)];
    [path addLineToPoint:CGPointMake(15, 20)];
    [path addLineToPoint:CGPointMake(15, -15)];
    [path addLineToPoint:CGPointMake(0, -25)];
    [path addLineToPoint:CGPointMake(-15, -15)];
    [path closePath];
    SKShapeNode *arrow = [SKShapeNode node];
    arrow.name = @"arrow";
    arrow.position = CGPointMake(60 + (arc4random() % 200), 400);
    arrow.path = path.CGPath;
    arrow.fillColor = [SKColor whiteColor];
    [self addChild:arrow];
    
    arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30, 45) center:CGPointMake(0, -5)];
    arrow.physicsBody.allowsRotation = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInNode:self];
    [self enumerateChildNodesWithName:@"bar" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([node containsPoint:p]) {
            self.select = node;
        }
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInNode:self];
    if (self.select) {
        float dx = p.x - [[touches anyObject] previousLocationInNode:self].x;
        self.select.position = CGPointMake(self.select.position.x + dx, self.select.position.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.select = nil;
}

- (void)didSimulatePhysics
{
    SKNode *arrow = [self childNodeWithName:@"arrow"];
    if (arrow.position.y < 40) {
        [arrow removeFromParent];
        [self createArrow];
    }
}

@end