Class {
	#name : 'BaselineOfJaCoCoTagger',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfJaCoCoTagger',
	#package : 'BaselineOfJaCoCoTagger'
}

{ #category : 'baselines' }
BaselineOfJaCoCoTagger >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : 'baselines' }
BaselineOfJaCoCoTagger >> defineDependencies: spec [
]

{ #category : 'baselines' }
BaselineOfJaCoCoTagger >> defineGroups: spec [

	
]

{ #category : 'baselines' }
BaselineOfJaCoCoTagger >> definePackages: spec [

	spec package: 'JaCoCo-Tagger'
]
