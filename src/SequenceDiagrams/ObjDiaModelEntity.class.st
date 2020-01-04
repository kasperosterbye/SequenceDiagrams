Class {
	#name : #ObjDiaModelEntity,
	#superclass : #Object,
	#instVars : [
		'sources',
		'destinations',
		'obj',
		'model'
	],
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #'instance creation' }
ObjDiaModelEntity class >> on: obj in: model [
	| entityClass |
	entityClass := (obj isCollection
		ifTrue: [ ObjDiaModelCollection ]
		ifFalse: [ ObjDiaModelObject ]).
	^ entityClass new
		obj: obj;
		model: model
]

{ #category : #accessing }
ObjDiaModelEntity >> categoryName [
	^ obj class category 
]

{ #category : #accessing }
ObjDiaModelEntity >> destinationObjects [
	^ self destinations collect: [ :ref | ref destination obj ]
]

{ #category : #accessing }
ObjDiaModelEntity >> destinations [
	^ destinations
]

{ #category : #accessing }
ObjDiaModelEntity >> destinations: anObject [
	destinations := anObject
]

{ #category : #accessing }
ObjDiaModelEntity >> destinationsAt: accessor put: value [
	| destination ref |
	destination := model entityFor: value.
	ref := ObjDiaModelReference new
		source: self -> accessor;
		destination: destination;
		model: model.
	model refs add: ref.
	destinations add: ref. 
	destination sources add: ref
]

{ #category : #initialization }
ObjDiaModelEntity >> initialize [
	sources := OrderedCollection new.
	destinations  := OrderedCollection  new.
	
]

{ #category : #testing }
ObjDiaModelEntity >> isCollection [
	^ false
]

{ #category : #accessing }
ObjDiaModelEntity >> model [
	^ model
]

{ #category : #accessing }
ObjDiaModelEntity >> model: anObject [
	model := anObject
]

{ #category : #accessing }
ObjDiaModelEntity >> obj [
	^ obj
]

{ #category : #accessing }
ObjDiaModelEntity >> obj: anObject [
	obj := anObject
]

{ #category : #writing }
ObjDiaModelEntity >> printName [
	^ obj class name
]

{ #category : #writing }
ObjDiaModelEntity >> printNameNoSpace [
	^ obj class name, obj hash printString
]

{ #category : #printing }
ObjDiaModelEntity >> printOn: stream [
	stream << 'Model of:( '.
	obj printOn: stream.
	stream << ') '
]

{ #category : #accessing }
ObjDiaModelEntity >> sources [
	^ sources
]

{ #category : #accessing }
ObjDiaModelEntity >> sources: anObject [
	sources := anObject
]

{ #category : #accessing }
ObjDiaModelEntity >> writeUmlOn: out [
	(out << 'object "' << self printName << '" as ')
		<< self printNameNoSpace;
		cr
]
