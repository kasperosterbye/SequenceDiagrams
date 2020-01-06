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
	kind = #singleton 
		ifTrue: [ ^ ' ..> ' ].
	^ ' --> '
]

{ #category : #accessing }
ObjDiaModelReference >> destination [
	^ destination
]

{ #category : #accessing }
ObjDiaModelReference >> destination: anEntity [
	destination ifNotNil:[ destination sources remove: self].
	destination := anEntity.
	destination sources add: self.
]

{ #category : #'as yet unclassified' }
ObjDiaModelReference >> includeDestinationInPseudo: pseudo [
	| destinationEntity |
	destinationEntity := self destination.
	destinationEntity pseudoObject ifNotNil: [ ^ self ].
	(model presentationFilter check: destinationEntity)
		ifTrue: [ self source: pseudo -> 'Index' ]
		ifFalse: [ destinationEntity pseudoObject: pseudo.
			destinationEntity unvisitedSources addAll: destinationEntity sources.
			destinationEntity unvisitedDestinations
				addAll: destinationEntity destinations ]
]

{ #category : #'as yet unclassified' }
ObjDiaModelReference >> includeSourceInPseudo: pseudo [
	| sourceEntity |
	sourceEntity := self sourceNode.
	sourceEntity pseudoObject ifNotNil: [ ^ self ].
	(model presentationFilter check: sourceEntity )
		ifTrue:[ 
			self destination: pseudo. ]
		ifFalse: [ 
			sourceEntity pseudoObject: pseudo.
			sourceEntity unvisitedSources addAll: sourceEntity sources.
			sourceEntity unvisitedDestinations addAll: sourceEntity destinations ] 
	
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
ObjDiaModelReference >> source: assocEntitySelector [
	source ifNotNil: [ source destinations remove: self ].
	source := assocEntitySelector .
	source key destinations add: self .
]

{ #category : #'as yet unclassified' }
ObjDiaModelReference >> sourceNode [
	^ source key
]

{ #category : #'as yet unclassified' }
ObjDiaModelReference >> sourceSelector [
	^ source value
]
