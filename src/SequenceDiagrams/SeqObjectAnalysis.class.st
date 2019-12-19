Class {
	#name : #SeqObjectAnalysis,
	#superclass : #Object,
	#instVars : [
		'obj',
		'refs',
		'instantiates'
	],
	#category : #'SequenceDiagrams-Tally'
}

{ #category : #'as yet unclassified' }
SeqObjectAnalysis class >> analyzeAccessObj: obj filter: filter [
	| objModel accessors |
	objModel := self new obj: obj.
	accessors := obj class in: [ :c | c selectors & c instVarNames ].
	objModel
		refs:
			((accessors inject: Dictionary new into: [:dict :sel | dict at: sel put: (obj perform: sel). dict ])
				select: [ :ref | filter value: ref ]).
	^ objModel
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis class >> analyzeObj: obj [
	| ana |
	ana := self new obj: obj.
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis class >> analyzeRoot: root [
	| unVisited visited rootCat safetyCount |
	unVisited := Set new.
	unVisited add: root.
	rootCat := root class category copyUpTo: $-.
	visited := Dictionary new.
	safetyCount := 100.
	[ unVisited notEmpty ]
		whileTrue: [ | obj model |
			(safetyCount := safetyCount - 1) < 0
				ifTrue: [ ^ nil ].
			obj := unVisited anyOne.
			unVisited remove: obj.
			(visited includesKey: obj)
				ifFalse: [ model := self
						analyzeAccessObj: obj
						filter: [ :o | 
							{'Collections'.
							rootCat} includes: (o class category copyUpTo: $-) ].
					visited at: obj put: model.
					unVisited addAll: model refs values ] ].
	^ visited
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis class >> objDiagramFor: root [
	| refDict out |
	refDict := self analyzeRoot: root.
	out := String new writeStream.
	refDict values
		do: [ :model | 
			out << 'object "' << model printName << '" as '
				<< model printNameNoSpace << String cr ].
	out cr.
	refDict
		do: [ :model | 
			model refs
				keysAndValuesDo: [ :selector :target | 
					(out << model printNameNoSpace << ' "' << selector << '" --> ')
						<< (refDict at: target) printNameNoSpace;
						cr ] ].
	^ out contents
]

{ #category : #initialization }
SeqObjectAnalysis >> initialize [
	refs := OrderedCollection new.
	instantiates := OrderedCollection new.
]

{ #category : #accessing }
SeqObjectAnalysis >> instantiates [
	^ instantiates
]

{ #category : #accessing }
SeqObjectAnalysis >> instantiates: anObject [
	instantiates := anObject
]

{ #category : #accessing }
SeqObjectAnalysis >> obj [
	^ obj
]

{ #category : #accessing }
SeqObjectAnalysis >> obj: anObject [
	obj := anObject
]

{ #category : #printing }
SeqObjectAnalysis >> printName [
	^obj printString
]

{ #category : #printing }
SeqObjectAnalysis >> printNameNoSpace [
	^ obj printString onlyLetters 
]

{ #category : #accessing }
SeqObjectAnalysis >> refs [
	^ refs
]

{ #category : #accessing }
SeqObjectAnalysis >> refs: anObject [
	refs := anObject
]
