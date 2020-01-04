Class {
	#name : #ObjDiaModelCollection,
	#superclass : #ObjDiaModelEntity,
	#category : #'SequenceDiagrams-ObjectDiagram'
}

{ #category : #analysis }
ObjDiaModelCollection >> analyzeAccess [
	"analyze the elements in my objects collection. Special case - do not analyze inside strings!"
	
	obj isString | obj isText
		ifTrue: [ ^ self ].
	obj
		do: [ :elem |  self analyzeElement: elem]
]

{ #category : #'as yet unclassified' }
ObjDiaModelCollection >> analyzeElement: elem [
	( model buildFilter check: elem)
		ifTrue: [ self destinationsAt: 'Index' put: elem ].
	
]

{ #category : #testing }
ObjDiaModelCollection >> isCollection [ 
	^true
]

{ #category : #removing }
ObjDiaModelCollection >> removeFromModel [
	sources copy do: [ :ref | ref removeFromModel ].
	destinations copy do: [ :ref | ref removeFromModel ].
	model entities removeKey: self obj
]

{ #category : #writing }
ObjDiaModelCollection >> writeRefsOn: out [
	destinations
		do: [ :ref | 
			out << self printNameNoSpace << ' --> '
				<< ref destination printNameNoSpace << String cr ] 
]

{ #category : #writing }
ObjDiaModelCollection >> writeUmlObjectOn: out [
	(out << 'object "' << self printName << '" as ')
		<< self printNameNoSpace;
		cr
]
