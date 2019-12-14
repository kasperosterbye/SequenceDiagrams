Class {
	#name : #BaselineOfSequenceDiagram,
	#superclass : #BaselineOf,
	#category : #BaselineOfSequenceDiagram
}

{ #category : #baselines }
BaselineOfSequenceDiagram >> baseline: spec [
	<baseline>
	
	spec for: #'common' do: [	
		spec 
			package: 'SequenceDiagrams-Bridge';
			package: 'SequenceDiagrams-Pillar';
			package: 'SequenceDiagrams-Tally'.
		spec 
			group: 'default' with: #('SequenceDiagrams-Bridge' 'SequenceDiagrams-Pillar');
			group: 'Bridge' with: #('SequenceDiagrams-Bridge') ]
]
