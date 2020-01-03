"
!! Purpose
I am a model of object dependencies. I am build with the outset in a root object, and then follows references to other objects.

I have two filters:

- an investigation filter, which is used to control which objects will be visited 
- a presentation filter, which controls which of the investigated objects will be presented. 

The ''default investigation filter'' is to include the top-level category of the root.

The ''default presentation filter'' is true (presenting all investigated objects).


In addition I have an objectMapping which maps objects (which has passed the investigationFilter) to ==SeqObjectDiagramModelEntities==.
"
Class {
	#name : #SeqObjectDiagramModel,
	#superclass : #Object,
	#instVars : [
		'investigationFilter',
		'presentationFilter',
		'referenceMapping',
		'presentationMapping',
		'investigationMapping'
	],
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #enumerating }
SeqObjectDiagramModel >> allReferencesDo: aBlock [ 
	referenceMapping  keysAndValuesDo:  [ :source :references | references do: [ :ref |
			aBlock value: ref] ]
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> analyzeRoot: root [
	| unVisited rootCat safetyCount |
	unVisited := Set new.
	unVisited add: root.
	rootCat := root class category copyUpTo: $-.
	investigationFilter includeCategory: rootCat.
	investigationMapping := Dictionary new.
	safetyCount := 10000.	"to prevent too large an investigation"
	[ unVisited notEmpty ]
		whileTrue: [ | obj model |
			(safetyCount := safetyCount - 1) < 0
				ifTrue: [ ^ nil ].
			obj := unVisited anyOne.
			unVisited remove: obj.
			(investigationMapping includesKey: obj)
				ifFalse: [ model := SeqObjectDiagramModelEntity on: obj in: self.
					investigationMapping at: obj put: model.
					model analyzeAccess.
					unVisited addAll: model refs values ] ]
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> createPresentationMapping [
	presentationMapping := Dictionary new.
	referenceMapping := Dictionary new.
	investigationMapping
		keysAndValuesDo: [ :original :model | 
			presentationMapping at: original put: model copy.
			referenceMapping at: model put: (self createReferencesFor: model) ].
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> createReferencesFor: model [
	referenceMapping := Dictionary new.
	presentationMapping valuesDo: [ :source |
			referenceMapping at: source put: ((source refs select: [:d| presentationMapping includesKey: d]) collect: [:destObj | 
				SeqObjectDiagramModelReference new
					source: source;
					destination: (presentationMapping at: destObj)])
			 ] 
]

{ #category : #accessing }
SeqObjectDiagramModel >> investigationFilter [
	^ investigationFilter
]

{ #category : #accessing }
SeqObjectDiagramModel >> investigationFilter: initializationBlock [ 
	investigationFilter := ObjDiaFilter new.
	initializationBlock value: investigationFilter .
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> objDiagramFor: root [
	^ PlantUMLBridge loadUML: (self objUMLFor: root)
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> objUMLFor: root [
	| out |
	self analyzeRoot: root.
	investigationMapping ifNil: [ self error: 'model too large' ].
	self preparePresentation.
	out := String new writeStream.
	self writeHeaderFor: root on: out.
	self writeObjectsOn: out.
	self writeRefsOn: out.
	self writeFooterOn: out.
	^ out contents
]

{ #category : #accessing }
SeqObjectDiagramModel >> objectMapping [
	^ investigationMapping
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> preparePresentation [
	self createPresentationMapping.
	self pruneCollections.
	self simplifySingletonCollections.
]

{ #category : #accessing }
SeqObjectDiagramModel >> presentationFilter [
	^ presentationFilter
]

{ #category : #accessing }
SeqObjectDiagramModel >> presentationFilter: anObject [
	presentationFilter := anObject
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> pruneCollections [
	presentationMapping  := presentationMapping
		select: [ :entity | entity includeMe ]
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> pruneModel [
	self pruneCollections
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> simplifySingletonCollections [
	self allReferencesDo: [ :ref |
		(ref destination isCollection and: [ ref destination size = 1 ])
			ifTrue:[
				ref kind: #singletonCollection.
				ref destination: (presentationMapping at: ref destination first).
				(presentationMapping at: ref destination) includeMe: false.
				]
		 ]
]

{ #category : #writing }
SeqObjectDiagramModel >> writeFooterOn: out [
	out << String cr << '@enduml' << String cr
]

{ #category : #writing }
SeqObjectDiagramModel >> writeHeaderFor: root on: out [
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

{ #category : #writing }
SeqObjectDiagramModel >> writeObjectsOn: out [
	presentationMapping  valuesDo: [ :model | model writeUMLon: out ]

	
]

{ #category : #writing }
SeqObjectDiagramModel >> writeRefsOn: out [
	presentationMapping  do: [ :model | model writeRefsOn: out ]
]
