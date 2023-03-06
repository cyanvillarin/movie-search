//
//  ClassInheritance.swift
//  demo_app
//
//  Created by Villarin, Cyan on 2023/03/04.
//

import Foundation

// Inheritance means the child class will inherit the properties of a parent class
// If parent class has property A, if child class inherits parent class, the child class will also have property A

// Parent class
class Vehicle {
    let wheels: Int
    init(wheels: Int) {
        self.wheels = wheels
    }
}

// Child class 'Car' that inherits Vehicles
// Which means it has property 'wheels' as well
// And during init() we set the wheels to 4 coz cars have 4 wheels
class Car: Vehicle {
    init() {
        super.init(wheels: 4)
    }
}

// Child class 'Bike' that inherits Vehicles
// Which means it has property 'wheels' as well
// And during init() we set the wheels to 2 coz bikes have 2 wheels
class Bike: Vehicle {
    init() {
        super.init(wheels: 2)
    }
}

/*
 let bike = Bike()
 let car = Car()
 print(bike.wheels)   // prints '2'
 print(car.wheels)    // prints '4'
*/
