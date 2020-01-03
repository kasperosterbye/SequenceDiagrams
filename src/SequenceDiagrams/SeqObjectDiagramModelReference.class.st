Class {
	#name : #SeqObjectDiagramModelReference,
	#superclass : #Object,
	#instVars : [
		'source',
		'destination',
		'kind'
	],
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #accessing }
SeqObjectDiagramModelReference >> destination [
	^ destination
]

{ #category : #accessing }
SeqObjectDiagramModelReference >> destination: anObject [
	destination := anObject
]

{ #category : #accessing }
SeqObjectDiagramModelReference >> kind [
	^ kind
]

{ #category : #accessing }
SeqObjectDiagramModelReference >> kind: anObject [
	kind := anObject
]

{ #category : #accessing }
SeqObjectDiagramModelReference >> source [
	^ source
]

{ #category : #accessing }
SeqObjectDiagramModelReference >> source: anObject [
	source := anObject
]
