//
//  MyScene.m
//  SKPhysicsJointSlidingDemo
//
//  Created by jins on 14-6-20.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

#import "MyScene.h"

#define ColorHex(rgbValue) [SKColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MyScene()
@property BOOL contentCreated;
@property SKSpriteNode *node1;
@property SKSpriteNode *node2;
@end

@implementation MyScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        //[self createSceneContents];
        //[self createCar];
        [self createTemp];
        /*SKSpriteNode *fire = [SKSpriteNode spriteNodeWithImageNamed:@"fire"];
        fire.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:fire];
        [fire runAction:[SKAction rotateByAngle:M_PI/4 duration:0]];*/
        self.contentCreated = YES;
    }
}

- (void)createTemp
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGPoint position = CGPointMake(100, 60);
    CGPoint position2 = CGPointMake(100, 180);
    CGSize size = CGSizeMake(10, 100);
    
    self.node1 = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:size];
    self.node1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    self.node1.position = position;
    
    self.node2 = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:size];
    self.node2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    self.node2.position = position2;
    
    [self addChild:self.node1];
    [self addChild:self.node2];
    
    SKPhysicsJointFixed *joint = [SKPhysicsJointFixed jointWithBodyA:self.node1.physicsBody
                                                               bodyB:self.node2.physicsBody
                                                              anchor:CGPointMake(self.node1.position.x, self.node1.position.y)];
    
    [self.physicsWorld addJoint:joint];
}

- (SKShapeNode*) makeWheel
{
    SKShapeNode *wheel = [[SKShapeNode alloc] init];
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, 16, 0, M_PI*2, YES);
    wheel.path = myPath;
    return wheel;
}


- (void) createCar
{
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    // 1. car body
    SKSpriteNode *carBody = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(120, 8)];
    carBody.position = CGPointMake(100, 200);
    carBody.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:carBody.size];
    [self addChild:carBody];
    
    // 2. wheels
    SKShapeNode *leftWheel = [self makeWheel];
    leftWheel.position = CGPointMake(carBody.position.x - carBody.size.width / 2, carBody.position.y);
    leftWheel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:16];
    [self addChild:leftWheel];
    
    SKShapeNode *rightWheel = [self makeWheel];
    rightWheel.position = CGPointMake(carBody.position.x + carBody.size.width / 2, carBody.position.y);
    rightWheel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:16];
    [self addChild:rightWheel];
    
    // 3. Join wheels to car
    [self.physicsWorld addJoint:[SKPhysicsJointPin jointWithBodyA:carBody.physicsBody bodyB:leftWheel.physicsBody anchor:leftWheel.position]];
    [self.physicsWorld addJoint:[SKPhysicsJointPin jointWithBodyA:carBody.physicsBody bodyB:rightWheel.physicsBody anchor:rightWheel.position]];
    
    // 4. drive car
    [carBody.physicsBody applyForce:CGVectorMake(10, 0)];
}

- (void)createSceneContents
{
    self.backgroundColor = ColorHex(0x4B5918);
    [self createSlopes];
    [self createCocoonBall:ColorHex(0xF2F2F2)];
}

- (void)createSlopes
{
    SKSpriteNode *slopeA = [SKSpriteNode spriteNodeWithColor:ColorHex(0x262018) size:CGSizeMake(320, 10)];
    slopeA.position = CGPointMake(200, 400);
    [self addChild:slopeA];
    slopeA.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:slopeA.size];
    slopeA.physicsBody.dynamic = NO;
    slopeA.physicsBody.friction = 5.0;
    SKAction *downA = [SKAction rotateByAngle:M_PI/15.0 duration:0];
    [slopeA runAction:downA];
    
    SKSpriteNode *slopeB = [SKSpriteNode spriteNodeWithColor:ColorHex(0x262018) size:CGSizeMake(320, 10)];
    slopeB.position = CGPointMake(120, 250);
    [self addChild:slopeB];
    slopeB.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:slopeB.size];
    slopeB.physicsBody.dynamic = NO;
    slopeB.physicsBody.friction = 5.0;
    SKAction *downB = [SKAction rotateByAngle:-M_PI/15.0 duration:0];
    [slopeB runAction:downB];
    
    SKSpriteNode *slopeC = [SKSpriteNode spriteNodeWithColor:ColorHex(0x262018) size:CGSizeMake(320, 10)];
    slopeC.position = CGPointMake(200, 100);
    [self addChild:slopeC];
    slopeC.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:slopeC.size];
    slopeC.physicsBody.dynamic = NO;
    slopeC.physicsBody.friction = 5.0;
    SKAction *downC = [SKAction rotateByAngle:M_PI/15.0 duration:0];
    [slopeC runAction:downC];
}

- (void)createCocoonBall:(SKColor*)color
{
    float r = 20;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-r/2.0, -r/2.0, r, r)];
    
    SKShapeNode *circleA = [SKShapeNode node];
    circleA.path = circlePath.CGPath;
    circleA.position = CGPointMake(250, 470);
    circleA.strokeColor = color;
    circleA.fillColor = color;
    [self addChild:circleA];
    circleA.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:r/2.0];
    circleA.physicsBody.density = 0.1;
    circleA.name = @"cocoonPart";
    
    SKShapeNode *circleB = [SKShapeNode node];
    circleB.path = circlePath.CGPath;
    circleB.position = CGPointMake(250, 470 - r);
    circleB.strokeColor = color;
    circleB.fillColor = color;
    [self addChild:circleB];
    circleB.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:r/2.0];
    circleB.physicsBody.density = 0.1;
    circleB.name = @"cocoonPart";
    
    
    SKSpriteNode *centerBar = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(20, 1.5 * r)];
    centerBar.position = CGPointMake(250, 470 - r/2.0);
    centerBar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:centerBar.size];
    [self addChild:centerBar];
    centerBar.name = @"cocoonPart";
    
    
    SKPhysicsJointFixed *fixedA = [SKPhysicsJointFixed jointWithBodyA:circleA.physicsBody bodyB:centerBar.physicsBody anchor:circleA.position];
    [self.physicsWorld addJoint:fixedA];
    
    SKPhysicsJointFixed *fixedB = [SKPhysicsJointFixed jointWithBodyA:circleB.physicsBody bodyB:centerBar.physicsBody anchor:circleB.position];
    [self.physicsWorld addJoint:fixedB];
    
    SKShapeNode *weight = [SKShapeNode node];
    weight.name = @"cocoonPart";
    weight.path = circlePath.CGPath;
    weight.fillColor = [SKColor clearColor];
    weight.strokeColor = [SKColor clearColor];
    weight.position = centerBar.position;
    [self addChild:weight];
    weight.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:r/2.0];
    weight.physicsBody.categoryBitMask = 0x00000000;
    weight.physicsBody.collisionBitMask = 0x00000000;
    weight.physicsBody.contactTestBitMask = 0xFFFFFFFF;
    weight.physicsBody.linearDamping = 0;
    weight.physicsBody.density = 50.0;
    
    SKPhysicsJointSliding *sl = [SKPhysicsJointSliding jointWithBodyA:centerBar.physicsBody bodyB:weight.physicsBody anchor:weight.position axis:CGVectorMake(0, 1)];
    sl.shouldEnableLimits = YES;
    sl.lowerDistanceLimit = -r/2.0;
    sl.upperDistanceLimit = r/2.0;
    [self.physicsWorld addJoint:sl];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*int rand = arc4random() % 3;
    
    switch (rand) {
        case 0:
            [self createCocoonBall:ColorHex(0xF2F2F2)];
            break;
        case 1:
            [self createCocoonBall:ColorHex(0xBFAC88)];
            break;
        case 2:
            [self createCocoonBall:ColorHex(0x732D14)];
            break;
            
    }*/
    [self.node1.physicsBody applyImpulse:CGVectorMake(0, 100)];
}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"cocoonPart" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0) {
            [node removeFromParent];
        }
    }];
}

@end