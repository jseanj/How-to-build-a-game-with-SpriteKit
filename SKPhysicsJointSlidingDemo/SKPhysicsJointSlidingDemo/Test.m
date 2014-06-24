//
//  Test.m
//  SKPhysicsJointSlidingDemo
//
//  Created by jins on 14-6-23.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

#import "Test.h"

@interface Test()
@property (nonatomic, weak) SKNode *selected;
@property (nonatomic) CGPoint next;
@end

@implementation Test

- (void)didMoveToView:(SKView *)view
{
    [self createWireWithColor:[SKColor whiteColor] point:CGPointMake(80, 50)];
    [self createWireWithColor:[SKColor redColor] point:CGPointMake(160, 50)];
    [self createWireWithColor:[SKColor greenColor] point:CGPointMake(240, 50)];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
}

- (void)createWireWithColor:(SKColor *)color point:(CGPoint)p
{
    SKNode *preNode = nil;
    for (int i=0; i<50; i++) {
        SKSpriteNode *n = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(4, 4)];
        n.name = @"rope";
        n.position = CGPointMake(p.x, p.y - i * 2);
        [self addChild:n];
        
        n.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(6, 6)];
        n.physicsBody.categoryBitMask = 0x2;
        n.physicsBody.collisionBitMask = 0x1;
        n.physicsBody.linearDamping = 0;
        n.physicsBody.angularDamping = 0;
        
        if (i == 0) {
            n.size = CGSizeMake(30, 30);
        }
        
        if (preNode) {
            SKPhysicsJointPin *pin = [SKPhysicsJointPin jointWithBodyA:n.physicsBody bodyB:preNode.physicsBody anchor:n.position];
            pin.shouldEnableLimits = YES;
            pin.upperAngleLimit = 0.2;
            pin.lowerAngleLimit = - 0.2;
            [self.physicsWorld addJoint:pin];
        }
        preNode = n;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInNode:self];
    self.next = p;
    
    SKNode *hit = [self nodeAtPoint:[[touches anyObject] locationInNode:self]];
    if ([hit.name isEqual:@"rope"]) {
        self.selected = hit;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInNode:self];
    self.next = p;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.selected = nil;
}

- (void)update:(NSTimeInterval)currentTime
{
    if (self.selected) {
        [self.selected runAction:[SKAction moveTo:self.next duration:0.01]];
    }
    
}

@end