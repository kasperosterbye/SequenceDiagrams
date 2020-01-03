"
!! Purpose
I represent an object in an object diagram.


I have a reference to the object I model (==obj==), and the objects I refer to (==refs==). 

The ==refs== is a dictionary mapping instanceVariableName to an other enitity. 

I have a reference back to the ==model== (diagram) I am part of.
"
Class {
	#name : #SeqObjectDiagramModelEntity,
	#superclass : #Object,
	#instVars : [
		'obj',
		'refs',
		'model',
		'includeMe',
		'pseudoEntity'
	],
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #'instance creation' }
SeqObjectDiagramModelEntity class >> on: obj in: model [
	^self new obj: obj; model: model
]

{ #category : #analysis }
SeqObjectDiagramModelEntity >> analyzeAccess [
	"set the references of me"
	obj isCollection
		ifFalse: [ self analyzeAccessObj ]
		ifTrue: [ self analyzeAccessCollection ]
]

{ #category : #analysis }
SeqObjectDiagramModelEntity >> analyzeAccessCollection [
	"return a dictionary of those objects in the collection, with a dummy key to make it compatible with non collections. 
	The elements of a collection are not accessed using a named variable. It is used elsewhere that 'Index' below is in capitals (to tell it from an instance variable)"

	obj isString
		ifTrue: [ ^ self ].
	refs := Dictionary new.
	obj
		do: [ :elem | 
			(model investigationFilter check: elem)
				ifTrue: [ refs at: 'Index' , elem hash asString put: elem ] ]
]

{ #category : #analysis }
SeqObjectDiagramModelEntity >> analyzeAccessObj [
	| accessors |
	refs := Dictionary new.
	accessors := obj class
		in: [ :c | c allSelectors & c allInstVarNames ].
	accessors do: [ :accessor | self analyzeAccessor: accessor ]
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModelEntity >> analyzeAccessor: accessor [
	| value |
	value := obj instVarNamed: accessor.
	value ifNil: [ ^ self ].
	value isClass
		ifTrue: [ ^ self ].
	(value isCollection and: [ value isEmpty ])
		ifTrue: [ ^ self ].
	(model investigationFilter check: value)
		ifFalse: [ ^ self ].
	refs at: accessor put: value
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> categoryName [
	^ obj class category 
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> includeMe [
	includeMe ifNotNil: [ ^includeMe ].
	obj isCollection
	ifTrue:[
		refs ifEmpty: [ ^includeMe := false ]
		].
	^ includeMe := true
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> includeMe: boolean [ 
	includeMe := boolean 
]

{ #category : #initialization }
SeqObjectDiagramModelEntity >> initialize [
	refs := Dictionary new.
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> model [
	^ model
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> model: anObject [
	model := anObject
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> obj [
	^ obj
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> obj: anObject [
	obj := anObject
]

{ #category : #printing }
SeqObjectDiagramModelEntity >> printName [
	^ obj class name
]

{ #category : #printing }
SeqObjectDiagramModelEntity >> printNameNoSpace [
	^ 'obj', obj hash printString
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> refs [
	^ refs
]

{ #category : #accessing }
SeqObjectDiagramModelEntity >> refs: anObject [
	refs := anObject
]

{ #category : #writing }
SeqObjectDiagramModelEntity >> writeCollectionRefsOn: out [
	self refs
		keysAndValuesDo: [ :selector :target | 
			| targetEntity |
			targetEntity := model objectMapping at: target ifAbsent: [ nil ].
			(targetEntity notNil and: [ targetEntity includeMe ])
				ifTrue: [ out << self printNameNoSpace << ' --> '
						<< targetEntity printNameNoSpace << String cr ] ]
]

{ #category : #writing }
SeqObjectDiagramModelEntity >> writeObjectRefsOn: out [
	| mark arrowType |
	mark := 1.
	arrowType := '" --> '.
	self refs
		keysAndValuesDo: [ :selector :target | 
			| targetEntity |
			targetEntity := model objectMapping at: target ifAbsent: [ nil ].
			targetEntity
				ifNotNil: [ (targetEntity obj isCollection and: [ targetEntity obj size = 1 ])
						ifTrue: [
							targetEntity := model objectMapping at: targetEntity obj first.
							arrowType := '" ..> ' ].
					out << self printNameNoSpace << ' "' << mark printString
						<< arrowType << targetEntity printNameNoSpace << String cr.
					out << self printNameNoSpace << ' : ' << mark printString << ') '
						<< selector << String cr.
					mark := mark + 1 ] ]
]

{ #category : #printing }
SeqObjectDiagramModelEntity >> writePackageAndObjectOn: out [
	out << 'package ' << self categoryName << ' {' ;cr.
		self writeUmlObjectOn: out.
		out << '}'; cr
]

{ #category : #writing }
SeqObjectDiagramModelEntity >> writeRefsOn: out [
	self obj isCollection 
	ifTrue: [ self writeCollectionRefsOn: out ] ifFalse: [ self writeObjectRefsOn: out ]
]

{ #category : #printing }
SeqObjectDiagramModelEntity >> writeUMLon: out [
	obj isCollection 
	ifTrue: [ self writeUmlObjectOn: out ] 
	ifFalse: [ self writePackageAndObjectOn: out ]
]

{ #category : #printing }
SeqObjectDiagramModelEntity >> writeUmlObjectOn: out [
	(out << 'object "' << self printName << '" as ')
		<< self printNameNoSpace;
		cr
]
