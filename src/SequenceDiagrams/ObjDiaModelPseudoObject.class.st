Class {
	#name : #ObjDiaModelPseudoObject,
	#superclass : #ObjDiaModelCollection,
	#instVars : [
		'unvisitedSources',
		'unvisitedDestinations'
	],
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #initialization }
ObjDiaModelPseudoObject >> initialize [
	super initialize.
	unvisitedSources := OrderedCollection new.
	unvisitedDestinations := OrderedCollection new.
]

{ #category : #initialization }
ObjDiaModelPseudoObject >> preparePresentation [
	[ unvisitedSources notEmpty | unvisitedDestinations notEmpty ]
		whileTrue: [ unvisitedSources notEmpty
				ifTrue:
					[ unvisitedSources removeLast includeSourceInPseudo: self ]
				ifFalse: [ unvisitedDestinations removeLast includeDestinationInPseudo: self ] ]
]

{ #category : #accessing }
ObjDiaModelPseudoObject >> unvisitedDestinations [
	^ unvisitedDestinations
]

{ #category : #accessing }
ObjDiaModelPseudoObject >> unvisitedDestinations: anObject [
	unvisitedDestinations := anObject
]

{ #category : #accessing }
ObjDiaModelPseudoObject >> unvisitedSources [
	^ unvisitedSources
]

{ #category : #accessing }
ObjDiaModelPseudoObject >> unvisitedSources: anObject [
	unvisitedSources := anObject
]
