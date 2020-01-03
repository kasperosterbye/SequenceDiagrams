"
I am an object diagram model.

I consists of entities connected by references.
Entities are either objects or collections.

My entities are build by applying a transitive closure over instance variables and collection contents. The transitive closure is restricted by the buildFilter.
"
Class {
	#name : #ObjDiaModel,
	#superclass : #Object,
	#instVars : [
		'buildFilter',
		'presentationFilter',
		'entities',
		'refs'
	],
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #'as yet unclassified' }
ObjDiaModel >> analyzeRoot: root [
	| unVisited rootCat safetyCount |
	unVisited := Set new.
	unVisited add: root.
	rootCat := root class category copyUpTo: $-.
	buildFilter includeCategory: rootCat.
	entities := Dictionary new.
	safetyCount := 10000.	"to prevent too large an investigation"
	[ unVisited notEmpty ]
		whileTrue: [ | obj entity |
			
					self halt.
			(safetyCount := safetyCount - 1) < 0
				ifTrue: [ ^ nil ].
			obj := unVisited anyOne.
			unVisited remove: obj.
			(entities includesKey: obj)
				ifFalse: [ entity := ObjDiaModelEntity on: obj in: self. 
					entities at: obj put: entity.
					entity analyzeAccess.
					unVisited addAll: entity destinationObjects ] ]
]

{ #category : #accessing }
ObjDiaModel >> buildFilter [
	^ buildFilter
]

{ #category : #accessing }
ObjDiaModel >> buildFilter: initializationBlock [
	buildFilter := ObjDiaFilter new.
	initializationBlock value: buildFilter 
]

{ #category : #accessing }
ObjDiaModel >> entities [
	^ entities
]

{ #category : #accessing }
ObjDiaModel >> entities: anObject [
	entities := anObject
]

{ #category : #'as yet unclassified' }
ObjDiaModel >> entityFor: obj [
	| newEntity |
	(entities includesKey: obj)
		ifTrue:[^ entities at: obj].
	newEntity := ObjDiaModelEntity on: obj in: self.
	entities at: obj put: newEntity.
	^newEntity
]

{ #category : #'as yet unclassified' }
ObjDiaModel >> objDiagramFor: root [
	^ PlantUMLBridge loadUML: (self objUMLFor: root)
]

{ #category : #'as yet unclassified' }
ObjDiaModel >> objUMLFor: root [
	| out |
	self analyzeRoot: root.
	entities ifNil: [ self error: 'model too large' ].
	"self preparePresentation."
	out := String new writeStream.
	self writeHeaderFor: root on: out.
	self writeObjectsOn: out.
	self writeRefsOn: out.
	self writeFooterOn: out.
	^ out contents
]

{ #category : #accessing }
ObjDiaModel >> presentationFilter [
	^ presentationFilter
]

{ #category : #accessing }
ObjDiaModel >> presentationFilter: anObject [
	presentationFilter := anObject
]

{ #category : #accessing }
ObjDiaModel >> refs [
	^ refs
]

{ #category : #accessing }
ObjDiaModel >> refs: anObject [
	refs := anObject
]

{ #category : #'as yet unclassified' }
ObjDiaModel >> writeFooterOn: out [
	out << String cr << '@enduml' << String cr
]

{ #category : #'as yet unclassified' }
ObjDiaModel >> writeHeaderFor: root on: out [
	out
		<< '@startuml';
		cr;
		<< 'skinparam packageStyle rectangle';
		cr;
		<< 'title ';
		<< root printString;
		cr;
		cr
]

{ #category : #'as yet unclassified' }
ObjDiaModel >> writeObjectsOn: out [
	entities  do: [ :entity | entity writeUmlOn: out ]

	
]

{ #category : #'as yet unclassified' }
ObjDiaModel >> writeRefsOn: out [
	entities do: [ :entity | entity writeRefsOn: out ]
]
