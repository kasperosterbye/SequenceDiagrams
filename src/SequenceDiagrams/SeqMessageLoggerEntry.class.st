Class {
	#name : #SeqMessageLoggerEntry,
	#superclass : #Object,
	#instVars : [
		'sender',
		'receiver',
		'selector',
		'arguments',
		'children',
		'parent'
	],
	#category : #'SequenceDiagrams-Tally'
}

{ #category : #visiting }
SeqMessageLoggerEntry >> accept: aVisitor [
	^ aVisitor visit: self
]

{ #category : #adding }
SeqMessageLoggerEntry >> addChild: childEntry [
	children add: childEntry.
	childEntry parent: self.
]

{ #category : #accessing }
SeqMessageLoggerEntry >> arguments [
	^ arguments
]

{ #category : #accessing }
SeqMessageLoggerEntry >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SeqMessageLoggerEntry >> children [
	^ children
]

{ #category : #initialization }
SeqMessageLoggerEntry >> initialize [ 
	children := OrderedCollection new.
]

{ #category : #accessing }
SeqMessageLoggerEntry >> parent [
	^ parent
]

{ #category : #accessing }
SeqMessageLoggerEntry >> parent: anObject [
	parent := anObject
]

{ #category : #printing }
SeqMessageLoggerEntry >> printOn: aStream [
	aStream 
		<< sender class name; 
		<< ' «';
		<< sender printString;
		<< '» -> ';
		<< selector;
		<< '( '. 
	arguments printOn: aStream delimiter: ', '.
	aStream
		<< ' ) -> ';
		<< receiver class name;
		<< ' «';
		<< receiver printString;
		<< '»'
]

{ #category : #accessing }
SeqMessageLoggerEntry >> receiver [
	^ receiver
]

{ #category : #accessing }
SeqMessageLoggerEntry >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
SeqMessageLoggerEntry >> selector [
	^ selector
]

{ #category : #accessing }
SeqMessageLoggerEntry >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
SeqMessageLoggerEntry >> sender [
	^ sender
]

{ #category : #accessing }
SeqMessageLoggerEntry >> sender: anObject [
	sender := anObject
]
