"
The name of this class is all (ALL) wrong. It is not sequence, and it is not analysis
"
Class {
	#name : #SeqObjectAnalysis,
	#superclass : #Object,
	#instVars : [
		'filter'
	],
	#category : #'SequenceDiagrams-Tally'
}

{ #category : #'as yet unclassified' }
SeqObjectAnalysis >> analyzeAccessCollection: coll [
	"return a dictionary of those objects in the collection, with a dummy key to make it compatible with non collections"

	| objModel refs |
	objModel := SeqObjectDiagramModel new obj: coll.
	coll isString
		ifTrue: [ ^ objModel ].
	refs := coll
		inject: Dictionary new
		into: [ :dict :elem | 
			(filter check: elem)
				ifTrue: [ dict at: 'Index' , elem hash asString put: elem ].
			dict ].
	objModel refs: refs.
	^ objModel
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis >> analyzeAccessObj: obj [
	| objModel accessors refs |
	objModel := SeqObjectDiagramModel new obj: obj.
	accessors := obj class
		in: [ :c | c allSelectors & c allInstVarNames ].
	refs := accessors
		inject: Dictionary new
		into: [ :dict :sel | 
			| value |
			value := obj instVarNamed: sel.
			value
				ifNotNil: [ 
					value isClass ifFalse: [(value isCollection and: [ value isEmpty ])
						ifFalse: [ (filter check: value)
								ifTrue: [
									dict at: sel put: value ] ] ]].
			dict	"for next iteration" ].
	objModel refs: refs.
	^ objModel
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis >> analyzeObj: obj [
	obj isCollection
		ifFalse: [ ^ self analyzeAccessObj: obj ]
		ifTrue: [ ^ self analyzeAccessCollection: obj ]
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis >> analyzeRoot: root [
	| unVisited visited rootCat safetyCount |
	unVisited := Set new.
	unVisited add: root.
	rootCat := root class category copyUpTo: $-.
	filter includeCategory: rootCat.
	visited := Dictionary new.
	safetyCount := 50000.
	[ unVisited notEmpty ]
		whileTrue: [ | obj model |
			(safetyCount := safetyCount - 1) < 0
				ifTrue: [ ^ nil ].
			obj := unVisited anyOne.
			unVisited remove: obj.
			(visited includesKey: obj)
				ifFalse: [ model := self analyzeObj: obj.
					visited at: obj put: model.
					unVisited addAll: model refs values ] ].
	^ self reduceRefs: visited
]

{ #category : #'filter creation' }
SeqObjectAnalysis >> excludeCategory: cat [
	filter excludeCategory: cat
]

{ #category : #'filter creation' }
SeqObjectAnalysis >> excludeSubclassesOf: aClass [
	filter excludeSubclassesOf: aClass
]

{ #category : #accessing }
SeqObjectAnalysis >> filter [
	^ filter
]

{ #category : #accessing }
SeqObjectAnalysis >> filter: anObject [
	filter := anObject
]

{ #category : #'filter creation' }
SeqObjectAnalysis >> includeCategory: cat [
	filter includeCategory: cat
]

{ #category : #'filter creation' }
SeqObjectAnalysis >> includeSubclassesOf: aClass [
	filter includeSubclassesOf: aClass
]

{ #category : #initialization }
SeqObjectAnalysis >> initialize [
	filter := SeqClassFilter new
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis >> objDiagramFor: root [
	^ PlantUMLBridge loadUML: (self objUMLFor: root)
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis >> objUMLFor: root [
	| refDict out |
	refDict := self analyzeRoot: root.
	refDict ifNil: [ self error: 'model too large' ].
	out := String new writeStream.
	self writeHeaderFor: root on: out.
	self writeObjectsIn: refDict on: out.
	self writeRefsIn: refDict on: out.
	self writeFooterOn: out.
	^ out contents
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis >> old_analyzeAccessObj: obj filter: aFilter [
	| objModel |
	objModel := self new obj: obj.
	(obj isKindOf: Collection)
		ifFalse: [ | accessors |
			accessors := obj class
				in: [ :c | c allSelectors & c allInstVarNames ].
			objModel
				refs:
					((accessors
						inject: Dictionary new
						into: [ :dict :sel | 
							| value |
							value := obj perform: sel.
							((value isKindOf: Collection) and: [ value isEmpty ])
								ifFalse: [ dict at: sel put: value ].
							dict ]) select: [ :ref | filter value: ref ]) ]
		ifTrue: [ objModel
				refs:
					((obj select: filter)
						inject: Dictionary new
						into: [ :dict :elem | 
							dict at: elem class name put: elem.
							dict ]) ].
	^ objModel
]

{ #category : #'as yet unclassified' }
SeqObjectAnalysis >> reduceRefs: refDict [
	"remove nodes from visited which are empty collections"

	| delete keep |
	keep := refDict.
	[ delete := keep
		select: [ :model | model obj isCollection and: [ model refs isEmpty ] ].
	delete isNotEmpty ]
		whileTrue: [ keep := keep copyWithoutAll: delete.
			keep values
				do: [ :model | 
					model
						refs: (model refs reject: [ :obj | (keep includesKey: obj) not ]) ] ].
				^ keep
]

{ #category : #writing }
SeqObjectAnalysis >> writeFooterOn: out [
	out << String cr << '@enduml' << String cr
]

{ #category : #writing }
SeqObjectAnalysis >> writeHeaderFor: root on: out [
	out
		<< '@startuml';
		cr;
		cr;
		<< 'title ';
		<< root printString;
		cr;
		cr.
]

{ #category : #writing }
SeqObjectAnalysis >> writeLegend: legend on: out [
	out << 'note as N1'; cr.
	legend do: [ :leg | out << leg key << ') ' << leg value; cr ].
	out << 'end note'; cr; cr.
	out << String cr << '@enduml' << String cr
]

{ #category : #writing }
SeqObjectAnalysis >> writeObjectsIn: refDict on: out [
	refDict values
		do: [ :model | 
			out << 'object "' << model printName << '" as '
				<< model printNameNoSpace; cr; cr ]
]

{ #category : #writing }
SeqObjectAnalysis >> writeRefsIn: refDict on: out [
	refDict
		do: [ :model | 
			| mark |
			model refs ifEmpty:[out << model printNameNoSpace << ' : ···'  << String cr.
				].
			mark := 1.
			model refs
				keysAndValuesDo: [ :selector :target | 
					selector first isLowercase
						ifTrue: [ out << model printNameNoSpace << ' "' << mark printString
								<< '" --> ' << (refDict at: target) printNameNoSpace
								<< String cr.
							out << model printNameNoSpace << ' : ' << mark printString
								<< ') ' << selector << String cr.
							mark := mark + 1 ]
						ifFalse: [ out << model printNameNoSpace << ' --> '
								<< (refDict at: target) printNameNoSpace << String cr ] ] ]
]
