Class {
	#name : #SeqObjectDiagramModel,
	#superclass : #Object,
	#instVars : [
		'obj',
		'refs',
		'instantiates'
	],
	#category : #'SequenceDiagrams-Tally'
}

{ #category : #initialization }
SeqObjectDiagramModel >> initialize [
	refs := Dictionary new.
	instantiates := OrderedCollection new
]

{ #category : #accessing }
SeqObjectDiagramModel >> instantiates [
	^ instantiates
]

{ #category : #accessing }
SeqObjectDiagramModel >> instantiates: anObject [
	instantiates := anObject
]

{ #category : #accessing }
SeqObjectDiagramModel >> obj [
	^ obj
]

{ #category : #accessing }
SeqObjectDiagramModel >> obj: anObject [
	obj := anObject
]

{ #category : #printing }
SeqObjectDiagramModel >> printName [
	^ obj class name
]

{ #category : #printing }
SeqObjectDiagramModel >> printNameNoSpace [
	^ 'obj', obj hash printString
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> reduceOn: filter [
	self refs: (refs reject: [ :model |
		model refs = 0 ])
]

{ #category : #'as yet unclassified' }
SeqObjectDiagramModel >> reduceRefs [
	self refs: (refs reject: [ :model | model reduceRefs. model refs = 0 ])
]

{ #category : #accessing }
SeqObjectDiagramModel >> refs [
	^ refs
]

{ #category : #accessing }
SeqObjectDiagramModel >> refs: anObject [
	refs := anObject
]
