Class {
	#name : #BaselineOfSequenceDiagram,
	#superclass : #BaselineOf,
	#category : #BaselineOfSequenceDiagram
}

{ #category : #baselines }
BaselineOfSequenceDiagram >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'PlantUMLBridge'
					with: [ spec repository: 'github://kasperosterbye/PlantUMLBridge' ];
				package: 'SequenceDiagrams' ]
]
