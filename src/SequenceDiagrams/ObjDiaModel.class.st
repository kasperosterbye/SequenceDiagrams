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
	| unVisited visited rootCat safetyCount |
	unVisited := Set new.
	unVisited add: root.
	visited := Set new.
	rootCat := root class category copyUpTo: $-.
	buildFilter includeCategory: rootCat.
	safetyCount := 10000.	"to prevent too large an investigation"
	[ unVisited notEmpty ]
		whileTrue: [ | obj entity |
			(safetyCount := safetyCount - 1) < 0
				ifTrue: [ ^ nil ].
			obj := unVisited anyOne.
			unVisited remove: obj.
			(visited includes: obj)
				ifFalse: [ entity := self entityFor: obj. 
					entities at: obj put: entity.
					entity analyzeAccess.
					visited add: obj.
					unVisited addAll: (entity destinationObjects copyWithoutAll: visited)] ]
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

{ #category : #initialization }
ObjDiaModel >> initialize [
	entities := Dictionary new.
	refs := OrderedCollection new.
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
	self reduceModel.
	self validateModel .
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

{ #category : #'as yet unclassified' }
ObjDiaModel >> pruneEmptyCollections [
	| emptyCollections |
	emptyCollections := entities values
		select: [ :ent | ent isCollection and: [ ent destinations isEmpty ] ].
	emptyCollections do: [ :entity | entity removeFromModel ] 
]

{ #category : #'as yet unclassified' }
ObjDiaModel >> reduceModel [
	self pruneEmptyCollections 
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
ObjDiaModel >> validateModel [
	entities do: [ :entity |
		entity sources do: [ :ref | 
			(entities at: ref source key obj) = ref source key ifFalse: [ self error ].
			ref destination = entity ifFalse: [ self error ].
			(ref source key destinations includes: ref) ifFalse: [ self error ] ].
		entity destinations do: [ :ref  |
			(entities at: ref destination obj) = ref destination ifFalse: [ self error ].
			ref source key = entity ifFalse: [ self error].
			(ref destination sources includes: ref) ifFalse: [ self error ] ] ].
	refs do: [ :ref |
		(ref source key destinations includes: ref) ifFalse: [ self error ].
		(ref destination sources includes: ref) ifFalse: [ self error ] ].
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
