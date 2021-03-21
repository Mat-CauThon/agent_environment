//
//  Node.swift
//  Agent
//
//  Created by Roman Mishchenko on 03.03.2021.
//

import Foundation

public class Node: Equatable {
    
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.position == rhs.position && lhs.parent == rhs.parent && lhs.cost == rhs.cost && lhs.weight == rhs.weight
    }
    
    public var parent: Node?
    public var position: Vector2
    
    public var distanceToTarget: Float
    public var cost: Float
    public var weight: Float
    public var f: Float {
        get {
            if distanceToTarget != -1 && cost != -1 {
                return distanceToTarget + cost
            } else {
                return -1
            }
        }
    }
    public var walkable: Bool
    
    init(pos: Vector2, walkable: Bool, weight: Float = 1) {
        self.parent = nil
        self.position = pos
        self.walkable = walkable
        self.weight = weight
        self.cost = 1
        self.distanceToTarget = -1
    }
}




public struct Vector2 {
    
    var x : Float32 = 0.0
    var y : Float32 = 0.0
    
    init() {
        
        x = 0.0
        y = 0.0
    }
    
    init(value: Float32) {
    
        x = value
        y = value
    }
    
    init(x:Float32,y:Float32) {
        
        self.x = x
        self.y = y
    }
    
    init(other: Vector2) {
    
        x = other.x
        y = other.y
    }
}

extension Vector2 {
    
    var description: String { return "[\(x),\(y)]" }
}

extension Vector2 : Equatable {
    
    func isFinite() -> Bool {
    
        return x.isFinite && y.isFinite
    }

    func distance(other: Vector2) -> Float32 {
        
        let result = self - other;
        return sqrt( result.dot(v: result) )
    }
    
    mutating func normalize() {
        
        let m = magnitude()
        
        if m > 0 {
            
            let il:Float32 = 1.0 / m
            
            x *= il
            y *= il
        }
    }
    
    func magnitude() -> Float32 {
        
        return sqrtf( x*x + y*y )
    }
    
    func dot( v: Vector2 ) -> Float32 {
        
        return x * v.x + y * v.y
    }
    
    mutating func lerp( a: Vector2, b: Vector2, coef : Float32) {
        
        let result = a + ( b - a) * coef
        
        x = result.x
        y = result.y
    }
}

public func ==(lhs: Vector2, rhs: Vector2) -> Bool {

    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}

func * (left: Vector2, right : Float32) -> Vector2 {
    
    return Vector2(x:left.x * right, y:left.y * right)
}

func * (left: Vector2, right : Vector2) -> Vector2 {
    
    return Vector2(x:left.x * right.x, y:left.y * right.y)
}

func / (left: Vector2, right : Float32) -> Vector2 {
    
    return Vector2(x:left.x / right, y:left.y / right)
}

func / (left: Vector2, right : Vector2) -> Vector2 {
    
    return Vector2(x:left.x / right.x, y:left.y / right.y)
}

func + (left: Vector2, right: Vector2) -> Vector2 {
    
    return Vector2(x:left.x + right.x, y:left.y + right.y)
}

func - (left: Vector2, right: Vector2) -> Vector2 {
    
    return Vector2(x:left.x - right.x, y:left.y - right.y)
}

func + (left: Vector2, right: Float32) -> Vector2 {
    
    return Vector2(x:left.x + right, y:left.y + right)
}

func - (left: Vector2, right: Float32) -> Vector2 {
    
    return Vector2(x:left.x - right, y:left.y - right)
}

func += ( left: inout Vector2, right: Vector2) {
    
    left = left + right
}

func -= ( left: inout Vector2, right: Vector2) {
    
    left = left - right
}

func *= ( left: inout Vector2, right: Vector2) {
    
    left = left * right
}

func /= ( left: inout Vector2, right: Vector2) {
    
    left = left / right
}
