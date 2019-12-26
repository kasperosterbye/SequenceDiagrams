Class {
	#name : #SeqClassFilter,
	#superclass : #Object,
	#instVars : [
		'includeCategories',
		'excludeCategories',
		'includeClasses',
		'excludeClasses'
	],
	#category : #'SequenceDiagrams-Tally'
}

{ #category : #initialization }
SeqClassFilter >> check: anObject [
	| objClass |
	anObject isString
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
SeqClassFilter >> excludeCategory: category [
	excludeCategories add: category 
]

{ #category : #'as yet unclassified' }
SeqClassFilter >> excludeSubclassesOf: aClass [
	excludeClasses add: aClass
]

{ #category : #accessing }
SeqClassFilter >> filterBlock [
	^[:obj | self check: obj]
]

{ #category : #'as yet unclassified' }
SeqClassFilter >> includeCategory: category [
	includeCategories add: category 
]

{ #category : #'as yet unclassified' }
SeqClassFilter >> includeSubclassesOf: aClass [
	includeClasses add: aClass
]

{ #category : #initialization }
SeqClassFilter >> initialize [
	includeCategories := OrderedCollection new.
	excludeCategories := OrderedCollection new.
	includeClasses := OrderedCollection new.
	excludeClasses := OrderedCollection new
]
