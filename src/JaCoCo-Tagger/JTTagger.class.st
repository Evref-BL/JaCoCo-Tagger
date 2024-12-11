Class {
	#name : 'JTTagger',
	#superclass : 'Object',
	#instVars : [
		'famixModel',
		'sessionTag',
		'cacheFamixClassesByName'
	],
	#category : 'JaCoCo-Tagger',
	#package : 'JaCoCo-Tagger'
}

{ #category : 'api' }
JTTagger >> computeTagNameFrom: document [

	^ 'Session '
	  , ((document nodes anyOne descendantNodesDetect: [ :node |
			   node name = 'sessioninfo' ]) attributeAt: #id)
]

{ #category : 'accessing' }
JTTagger >> famixClassesByName [

	^ cacheFamixClassesByName ifNil: [
		  cacheFamixClassesByName := (self famixModel allClasses collect: [
			                              :c | c mooseNameWithDots -> c ])
			                             asOrderedCollection asDictionary ]
]

{ #category : 'accessing' }
JTTagger >> famixModel [

	^ famixModel
]

{ #category : 'accessing' }
JTTagger >> famixModel: anObject [

	famixModel := anObject
]

{ #category : 'api' }
JTTagger >> import: aFileReference [

	| document methods famixClass tagName |
	aFileReference readStreamDo: [ :xmlStream |
		document := (XMLDOMParser on: xmlStream)
			            documentReadLimit: nil;
			            parseDocument ].
	tagName := self computeTagNameFrom: document.
	sessionTag := famixModel tagNamed: tagName.

	methods := document nodes anyOne allNodesSelect: [ :node |
		           node name = 'method' ].

	methods do: [ :xmlMethod | "is the method at least partially covered"
		(xmlMethod nodes anySatisfy: [ :node |
			 (node attributeAt: #covered) asInteger > 0 ]) ifTrue: [
			| className |
			className := xmlMethod parent attributeAt: #name.
			famixClass := self searchFamixClassFromName: className.
			famixClass ifNotNil: [ sessionTag tagEntity: famixClass ] ] ]
]

{ #category : 'api' }
JTTagger >> searchFamixClassFromName: className [

	| standardClassName |
	standardClassName := className copyReplaceAll: '/' with: '.'.
	^ self famixClassesByName at: standardClassName ifAbsent: [nil].
	^ self famixModel allClasses
		  detect: [ :class | class mooseNameWithDots = standardClassName ]
		  ifNone: [ nil ]
]
