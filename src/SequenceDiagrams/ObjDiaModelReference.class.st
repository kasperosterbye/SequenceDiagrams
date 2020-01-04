Class {
	#name : #ObjDiaModelReference,
	#superclass : #Object,
	#instVars : [
		'source',
		'destination',
		'kind',
		'model'
	],
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #'as yet unclassified' }
ObjDiaModelReference >> arrowType [
	kind = #singletonCollection 
		ifTrue: [ ^ ' ..> ' ].
	^ ' --> '
]

{ #category : #accessing }
ObjDiaModelReference >> destination [
	^ destination
]

{ #category : #accessing }
ObjDiaModelReference >> destination: anObject [
	destination := anObject
]

{ #category : #accessing }
ObjDiaModelReference >> kind [
	^ kind
]

{ #category : #accessing }
ObjDiaModelReference >> kind: anObject [
	kind := anObject
]

{ #category : #accessing }
ObjDiaModelReference >> model [
	^ model
]

{ #category : #accessing }
ObjDiaModelReference >> model: anObject [
	model := anObject
]

{ #category : #printing }
ObjDiaModelReference >> printOn: stream [ 
	stream << 'ModelRef:( '.
	source key printOn: stream.
	stream << ' -> '.
	destination printOn: stream.
	stream << ') '
]

{ #category : #removing }
ObjDiaModelReference >> removeFromModel [
	source key destinations remove: self.
	destination sources remove: self.
	model refs remove: self
]

{ #category : #accessing }
ObjDiaModelReference >> source [
	^ source
]

{ #category : #accessing }
ObjDiaModelReference >> source: anObject [
	source := anObject
]

{ #category : #'as yet unclassified' }
ObjDiaModelReference >> sourceNode [
	^ source key
]

{ #category : #'as yet unclassified' }
ObjDiaModelReference >> sourceSelector [
	^ source value
]