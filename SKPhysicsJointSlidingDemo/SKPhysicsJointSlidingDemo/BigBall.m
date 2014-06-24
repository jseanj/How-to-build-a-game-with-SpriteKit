//
//  BigBall.m
//  SKPhysicsJointSlidingDemo
//
//  Created by jins on 14-6-23.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

#import "BigBall.h"

@interface BigBall ()
@property BOOL contentCreated;
@end

@implementation BigBall

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    SKSpriteNode *ground = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(320, 10)];
    ground.position = CGPointMake(160, 10);
    [self addChild:ground];
    
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.dynamic = NO;
    
    SKShapeNode *center =[SKShapeNode node];
    center.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-10, -10, 20, 20)].CGPath;
    center.position = CGPointMake(160, 300);
    [self addChild:center];
    center.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
    center.name = @"center";
    
    float dAngle = M_PI / 10.0;
    SKNode *first;
    SKNode *previous;
    for (int i=0; i<15; i++) {
        float x = 100 * cos(dAngle * i) + 160;
        float y = 100 * sin(dAngle * i) + 300;
        
        SKShapeNode *n = [SKShapeNode node];
        n.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-10, -10, 20, 20)].CGPath;
        n.position = CGPointMake(x, y);
        [self addChild:n];
        n.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
        
        SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:center.physicsBody bodyB:n.physicsBody anchorA:CGPointMake(160, 300) anchorB:CGPointMake(x, y)];
        joint.damping = 0.2;
        joint.frequency = 10.0;
        [self.physicsWorld addJoint:joint];
        
        if (previous) {
            SKPhysicsJointLimit *limit = [SKPhysicsJointLimit jointWithBodyA:previous.physicsBody bodyB:n.physicsBody anchorA:previous.position anchorB:n.position];
            limit.maxLength = 30;
            [self.physicsWorld addJoint:limit];
        } else {
            first = n;
        }
        previous = n;
    }
    
    
    SKPhysicsJointLimit *limit = [SKPhysicsJointLimit jointWithBodyA:previous.physicsBody bodyB:first.physicsBody anchorA:previous.position anchorB:first.position];
    limit.maxLength = 30;
    [self.physicsWorld addJoint:limit];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKNode *node = [self childNodeWithName:@"center"];
    [node.physicsBody applyImpulse:CGVectorMake(0, 100)];
}

@end
