Class {
	#name : #ObjDiaFilter,
	#superclass : #Object,
	#instVars : [
		'includeCategories',
		'excludeCategories',
		'includeClasses',
		'excludeClasses'
	],
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #initialization }
ObjDiaFilter >> check: anObject [
	| objClass |
	anObject 
		ifNil: [ ^ false ].
	anObject isString
		ifTrue: [ ^ false ].
	anObject isClass
		ifTrue: [ ^ false ].
	anObject isCollection
		ifTrue: [ ^ anObject isNotEmpty  ].
	objClass := anObject class.
	((includeCategories
		anySatisfy: [ :cat | objClass category beginsWith: cat ])
		or: [ includeClasses
				anySatisfy: [ :class | objClass includesBehavior: class ] ])
		ifFalse: [ ^ false ].
	((excludeCategories
		anySatisfy: [ :cat | objClass category beginsWith: cat ])
		or: [ excludeClasses
				anySatisfy: [ :class | objClass includesBehavior: class ] ])
		ifTrue: [ ^ false ].
	^ true
]

{ #category : #'as yet unclassified' }
ObjDiaFilter >> excludeCategory: category [
	excludeCategories add: category 
]

{ #category : #'as yet unclassified' }
ObjDiaFilter >> excludeSubclassesOf: aClass [
	excludeClasses add: aClass
]

{ #category : #accessing }
ObjDiaFilter >> filterBlock [
	^[:obj | self check: obj]
]

{ #category : #'as yet unclassified' }
ObjDiaFilter >> includeCategory: category [
	includeCategories add: category 
]

{ #category : #'as yet unclassified' }
ObjDiaFilter >> includeSubclassesOf: aClass [
	includeClasses add: aClass
]

{ #category : #initialization }
ObjDiaFilter >> initialize [
	includeCategories := OrderedCollection new.
	excludeCategories := OrderedCollection new.
	includeClasses := OrderedCollection new.
	excludeClasses := OrderedCollection new
]
